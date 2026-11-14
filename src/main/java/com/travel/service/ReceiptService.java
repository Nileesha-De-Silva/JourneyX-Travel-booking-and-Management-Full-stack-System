// File: src/main/java/com/travel/service/ReceiptService.java
package com.travel.service;

import com.travel.dao.ReceiptDAO;
import com.travel.model.Booking;
import com.travel.model.Receipt;
import com.travel.model.Payment;
import com.travel.model.Customer;
import com.travel.model.Package;
import com.travel.service.BookingService;
import com.travel.service.PaymentService;
import com.travel.service.CustomerService;
import com.travel.service.PackageService;

import java.util.Date;
import java.util.List;

public class ReceiptService {
    private ReceiptDAO receiptDAO;
    private BookingService bookingService;
    private PaymentService paymentService;
    private CustomerService customerService;
    private PackageService packageService;

    public ReceiptService() {
        receiptDAO = new ReceiptDAO();
        bookingService = new BookingService();
        paymentService = new PaymentService();
        customerService = new CustomerService();
        packageService = new PackageService();
    }

    public int generateReceipt(int bookingId) {
        Booking booking = bookingService.getBookingById(bookingId);
        if (booking == null || !"Confirmed".equals(booking.getConfirmationStatus())) {
            return -1; // Invalid booking
        }

        // Check if receipt already exists
        Receipt existingReceipt = receiptDAO.getReceiptByBookingId(bookingId);
        if (existingReceipt != null) {
            return existingReceipt.getReceiptId();
        }

        // Get payment information
        Payment payment = paymentService.getPaymentByBookingId(bookingId);
        Customer customer = customerService.getCustomerById(booking.getCustomerId());
        Package packageInfo = packageService.getPackageById(booking.getPackageId());

        // Generate comprehensive receipt content
        String content = generateReceiptContent(booking, payment, customer, packageInfo);

        Receipt receipt = new Receipt(bookingId, content);
        return receiptDAO.addReceipt(receipt);
    }

    private String generateReceiptContent(Booking booking, Payment payment, Customer customer, Package packageInfo) {
        StringBuilder receipt = new StringBuilder();
        
        receipt.append("========================================\n");
        receipt.append("        TRAVEL AGENCY RECEIPT\n");
        receipt.append("========================================\n\n");
        
        // Receipt Information
        receipt.append("RECEIPT INFORMATION:\n");
        receipt.append("-------------------\n");
        receipt.append("Receipt Generated: ").append(new Date()).append("\n");
        receipt.append("Booking ID: ").append(booking.getBookingId()).append("\n");
        receipt.append("Booking Date: ").append(booking.getBookingDate()).append("\n");
        receipt.append("Booking Status: ").append(booking.getConfirmationStatus()).append("\n\n");
        
        // Payment Information
        if (payment != null) {
            receipt.append("PAYMENT INFORMATION:\n");
            receipt.append("-------------------\n");
            receipt.append("Payment ID: ").append(payment.getPaymentId()).append("\n");
            receipt.append("Payment Date: ").append(payment.getPaymentDate()).append("\n");
            receipt.append("Payment Status: ").append(payment.getStatus()).append("\n");
            receipt.append("Payment Method: ").append(payment.getMethod()).append("\n");
            receipt.append("Payment Type: ").append(payment.getPaymentType()).append("\n");
            
            // Mask card number for security (show only last 4 digits)
            if (payment.getCardNumber() != null && !payment.getCardNumber().isEmpty()) {
                String cardNumber = payment.getCardNumber();
                String maskedCard = "****-****-****-" + cardNumber.substring(Math.max(0, cardNumber.length() - 4));
                receipt.append("Card Number: ").append(maskedCard).append("\n");
            }
            
            receipt.append("Amount Paid: $").append(String.format("%.2f", payment.getAmount())).append("\n\n");
        }
        
        // Customer Information
        if (customer != null) {
            receipt.append("CUSTOMER INFORMATION:\n");
            receipt.append("--------------------\n");
            receipt.append("Customer ID: ").append(customer.getCustomerId()).append("\n");
            receipt.append("Customer Name: ").append(customer.getCustomerName()).append("\n");
            receipt.append("Email: ").append(customer.getEmail()).append("\n");
            receipt.append("Contact: ").append(customer.getContactNumber()).append("\n");
            receipt.append("Address: ").append(customer.getAddress()).append("\n\n");
        }
        
        // Package Information
        if (packageInfo != null) {
            receipt.append("PACKAGE INFORMATION:\n");
            receipt.append("-------------------\n");
            receipt.append("Package ID: ").append(packageInfo.getPackageId()).append("\n");
            receipt.append("Package Name: ").append(packageInfo.getPackageName()).append("\n");
            receipt.append("Package Price: $").append(String.format("%.2f", packageInfo.getPrice())).append("\n");
            receipt.append("Duration: ").append(packageInfo.getDuration()).append("\n");
            receipt.append("Destinations: ").append(packageInfo.getDestinations()).append("\n");
            receipt.append("Start Date: ").append(packageInfo.getStartDate()).append("\n");
            receipt.append("End Date: ").append(packageInfo.getEndDate()).append("\n\n");
        }
        
        // Booking Details
        receipt.append("BOOKING DETAILS:\n");
        receipt.append("----------------\n");
        receipt.append("Number of Travelers: ").append(booking.getNumTravelers()).append("\n");
        receipt.append("Total Price: $").append(String.format("%.2f", booking.getTotalPrice())).append("\n\n");
        
        // Footer
        receipt.append("========================================\n");
        receipt.append("Thank you for choosing our travel agency!\n");
        receipt.append("For any inquiries, please contact us.\n");
        receipt.append("========================================\n");
        
        return receipt.toString();
    }

    public boolean sendReceipt(int bookingId) {
        Receipt receipt = receiptDAO.getReceiptByBookingId(bookingId);
        if (receipt == null) {
            return false; // Receipt doesn't exist
        }

        // Simulate sending receipt
        receipt.setSent(true);
        return receiptDAO.updateReceipt(receipt);
    }

    public Receipt getReceiptByBookingId(int bookingId) {
        return receiptDAO.getReceiptByBookingId(bookingId);
    }

    public List<Receipt> getAllReceipts() {
        return receiptDAO.getAllReceipts();
    }

    public int generateReceiptByPaymentId(int paymentId) {
        Payment payment = paymentService.getPaymentById(paymentId);
        if (payment == null || !"Approved".equals(payment.getStatus())) {
            return -1; // Invalid payment
        }

        // Check if receipt already exists for this booking
        Receipt existingReceipt = receiptDAO.getReceiptByBookingId(payment.getBookingId());
        if (existingReceipt != null) {
            return existingReceipt.getReceiptId();
        }

        // Get booking and related information
        Booking booking = bookingService.getBookingById(payment.getBookingId());
        Customer customer = customerService.getCustomerById(payment.getCustomerId());
        Package packageInfo = packageService.getPackageById(payment.getPackageId());

        // Generate comprehensive receipt content
        String content = generateReceiptContent(booking, payment, customer, packageInfo);

        Receipt receipt = new Receipt(payment.getBookingId(), content);
        return receiptDAO.addReceipt(receipt);
    }
}