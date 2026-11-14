package com.travel.controller.customer;

import com.travel.model.Customer;
import com.travel.model.Booking;
import com.travel.model.Payment;
import com.travel.model.Receipt;
import com.travel.service.BookingService;
import com.travel.service.PaymentService;
import com.travel.service.ReceiptService;
import com.travel.service.CustomerService;
import com.travel.service.PackageService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

public class PaymentReceiptServlet extends HttpServlet {
    private PaymentService paymentService;
    private BookingService bookingService;
    private ReceiptService receiptService;
    private CustomerService customerService;
    private PackageService packageService;

    @Override
    public void init() {
        paymentService = new PaymentService();
        bookingService = new BookingService();
        receiptService = new ReceiptService();
        customerService = new CustomerService();
        packageService = new PackageService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null ||
                !"customer".equals(session.getAttribute("userType"))) {
            response.sendRedirect(request.getContextPath() + "/tour-login");
            return;
        }

        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/")) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        // Extract booking ID from path
        String[] pathParts = pathInfo.split("/");
        if (pathParts.length < 2) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        try {
            int bookingId = Integer.parseInt(pathParts[1]);
            Customer customer = (Customer) session.getAttribute("user");
            int customerId = customer.getCustomerId();

            // Verify this booking belongs to the current customer
            Booking booking = bookingService.getBookingById(bookingId);
            if (booking == null || booking.getCustomerId() != customerId) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "You don't have permission to view this receipt");
                return;
            }

            // Get payment information
            Payment payment = paymentService.getPaymentByBookingId(bookingId);
            if (payment == null) {
                request.setAttribute("errorMessage", "No payment found for this booking");
                request.getRequestDispatcher("/views/common/error.jsp").forward(request, response);
                return;
            }

            // Generate payment receipt content
            String paymentReceiptContent = generatePaymentReceiptContent(booking, payment, customer);

            request.setAttribute("paymentReceiptContent", paymentReceiptContent);
            request.setAttribute("booking", booking);
            request.setAttribute("payment", payment);
            request.getRequestDispatcher("/views/customer/payment-receipt.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid booking ID");
        }
    }

    private String generatePaymentReceiptContent(Booking booking, Payment payment, Customer customer) {
        StringBuilder receipt = new StringBuilder();
        
        receipt.append("========================================\n");
        receipt.append("        PAYMENT RECEIPT\n");
        receipt.append("========================================\n\n");
        
        // Receipt Information
        receipt.append("PAYMENT RECEIPT INFORMATION:\n");
        receipt.append("----------------------------\n");
        receipt.append("Receipt Generated: ").append(new java.util.Date()).append("\n");
        receipt.append("Payment ID: ").append(payment.getPaymentId()).append("\n");
        receipt.append("Booking ID: ").append(booking.getBookingId()).append("\n");
        receipt.append("Payment Date: ").append(payment.getPaymentDate()).append("\n");
        receipt.append("Payment Status: ").append(payment.getStatus()).append("\n\n");
        
        // Payment Details
        receipt.append("PAYMENT DETAILS:\n");
        receipt.append("----------------\n");
        receipt.append("Payment Method: ").append(payment.getMethod()).append("\n");
        receipt.append("Payment Type: ").append(payment.getPaymentType()).append("\n");
        
        // Mask card number for security (show only last 4 digits)
        if (payment.getCardNumber() != null && !payment.getCardNumber().isEmpty()) {
            String cardNumber = payment.getCardNumber();
            String maskedCard = "****-****-****-" + cardNumber.substring(Math.max(0, cardNumber.length() - 4));
            receipt.append("Card Number: ").append(maskedCard).append("\n");
        }
        
        receipt.append("Amount Paid: $").append(String.format("%.2f", payment.getAmount())).append("\n\n");
        
        // Customer Information
        receipt.append("CUSTOMER INFORMATION:\n");
        receipt.append("--------------------\n");
        receipt.append("Customer ID: ").append(customer.getCustomerId()).append("\n");
        receipt.append("Customer Name: ").append(customer.getCustomerName()).append("\n");
        receipt.append("Email: ").append(customer.getEmail()).append("\n");
        receipt.append("Contact: ").append(customer.getContactNumber()).append("\n\n");
        
        // Booking Reference
        receipt.append("BOOKING REFERENCE:\n");
        receipt.append("-----------------\n");
        receipt.append("Booking Date: ").append(booking.getBookingDate()).append("\n");
        receipt.append("Booking Status: ").append(booking.getConfirmationStatus()).append("\n");
        receipt.append("Number of Travelers: ").append(booking.getNumTravelers()).append("\n");
        receipt.append("Total Price: $").append(String.format("%.2f", booking.getTotalPrice())).append("\n\n");
        
        // Footer
        receipt.append("========================================\n");
        receipt.append("This is your payment receipt.\n");
        receipt.append("Keep this receipt for your records.\n");
        receipt.append("For any payment inquiries, contact us.\n");
        receipt.append("========================================\n");
        
        return receipt.toString();
    }
}
