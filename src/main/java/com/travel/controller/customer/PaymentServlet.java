package com.travel.controller.customer;

import com.travel.dao.BookingDAO;
import com.travel.dao.PaymentDAO;
import com.travel.model.Booking;
import com.travel.model.Payment;
import com.travel.service.PaymentService;
import java.io.IOException;
import java.util.Date;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class PaymentServlet extends HttpServlet {
    private PaymentDAO paymentDAO;
    private BookingDAO bookingDAO;
    private PaymentService paymentService;

    @Override
    public void init() throws ServletException {
        super.init();
        paymentDAO = new PaymentDAO();
        bookingDAO = new BookingDAO();
        paymentService = new PaymentService();
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
            pathInfo = "/history";
        }

        switch (pathInfo) {
            case "/history":
                viewPaymentHistory(request, response);
                break;
            case "/make":
                showMakePaymentForm(request, response);
                break;
            case "/demo-strategy":
                demonstrateStrategyPattern(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null ||
                !"customer".equals(session.getAttribute("userType"))) {
            response.sendRedirect(request.getContextPath() + "/tour-login");
            return;
        }

        String pathInfo = request.getPathInfo();

        switch (pathInfo) {
            case "/make":
                makePayment(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void demonstrateStrategyPattern(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Demonstrate the strategy pattern
        paymentService.demonstrateStrategyPattern();

        request.setAttribute("message", "Strategy Pattern demonstrated successfully. Check server console for details.");
        request.getRequestDispatcher("/views/customer/payments/demo-strategy.jsp").forward(request, response);
    }

    private void viewPaymentHistory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        int customerId = ((com.travel.model.Customer) session.getAttribute("user")).getCustomerId();

        List<Payment> payments = paymentDAO.getPaymentsByCustomerId(customerId);
        request.setAttribute("payments", payments);

        request.getRequestDispatcher("/views/customer/payments/history.jsp").forward(request, response);
    }

    private void showMakePaymentForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        int customerId = ((com.travel.model.Customer) session.getAttribute("user")).getCustomerId();

        String bookingIdParam = request.getParameter("bookingId");
        Booking booking = null;

        if (bookingIdParam != null) {
            try {
                int bookingId = Integer.parseInt(bookingIdParam);
                booking = bookingDAO.getBookingById(bookingId);
            } catch (NumberFormatException e) {
            }
        }

        if (booking == null) {
            List<Booking> bookings = bookingDAO.getBookingsByCustomerId(customerId);
            if (!bookings.isEmpty()) {
                booking = bookings.get(0);
            }
        }

        if (booking == null) {
            request.setAttribute("errorMessage", "No booking found. Please make a booking first.");
        } else {
            request.setAttribute("booking", booking);
        }

        request.getRequestDispatcher("/views/customer/payments/make.jsp").forward(request, response);
    }

    private void makePayment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        com.travel.model.Customer customer = (com.travel.model.Customer) session.getAttribute("user");
        int customerId = customer.getCustomerId();

        // Get booking information
        String bookingIdParam = request.getParameter("bookingId");
        if (bookingIdParam == null || bookingIdParam.isEmpty()) {
            request.setAttribute("errorMessage", "Booking ID is required");
            showMakePaymentForm(request, response);
            return;
        }

        int bookingId;
        try {
            bookingId = Integer.parseInt(bookingIdParam);
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid booking ID format");
            showMakePaymentForm(request, response);
            return;
        }

        Booking booking = bookingDAO.getBookingById(bookingId);
        if (booking == null) {
            request.setAttribute("errorMessage", "Booking not found");
            showMakePaymentForm(request, response);
            return;
        }

        // Verify this booking belongs to the current customer
        if (booking.getCustomerId() != customerId) {
            request.setAttribute("errorMessage", "This booking does not belong to you");
            showMakePaymentForm(request, response);
            return;
        }

        // Get payment method and type
        String method = request.getParameter("method");
        String paymentType = request.getParameter("paymentType");

        if (method == null || method.isEmpty() || paymentType == null || paymentType.isEmpty()) {
            request.setAttribute("errorMessage", "Payment method and type are required");
            request.setAttribute("booking", booking);
            showMakePaymentForm(request, response);
            return;
        }

        String cardNumber = request.getParameter("cardNumber");
        String expiryDate = request.getParameter("expiryDate");
        String cvv = request.getParameter("cvv");
        String paypalEmail = request.getParameter("paypalEmail");

        try {
            Payment payment = new Payment();
            payment.setPaymentDate(new Date());
            payment.setAmount(booking.getTotalPrice() > 0 ? booking.getTotalPrice() : 0);
            payment.setMethod(method);
            payment.setStatus("Pending");
            payment.setCustomerId(customerId);
            payment.setBookingId(bookingId);
            payment.setPackageId(booking.getPackageId());
            payment.setCardNumber(cardNumber);
            payment.setExpiryDate(expiryDate);
            payment.setCvv(cvv);
            payment.setPaymentType(paymentType);

            boolean success = paymentService.processPayment(payment, paymentType);

            if (success) {
                request.setAttribute("successMessage",
                        "Payment submitted successfully using " + paymentType +
                                ". Your payment ID is: " + payment.getPaymentId());
            } else {
                request.setAttribute("errorMessage", "Failed to process payment using " + paymentType);
            }
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Error processing payment: " + e.getMessage());
        }

        request.setAttribute("booking", booking);
        request.getRequestDispatcher("/views/customer/payments/make.jsp").forward(request, response);
    }
}