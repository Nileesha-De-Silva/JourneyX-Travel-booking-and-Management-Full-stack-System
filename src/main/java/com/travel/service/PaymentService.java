package com.travel.service;

import com.travel.dao.PaymentDAO;
import com.travel.model.Payment;
import com.travel.strategy.*;
import java.util.List;

public class PaymentService {
    private PaymentDAO paymentDAO;
    private PaymentContext paymentContext;

    public PaymentService() {
        paymentDAO = new PaymentDAO();
        paymentContext = new PaymentContext();
    }

    public boolean processPayment(Payment payment, String paymentType) {
        switch (paymentType.toLowerCase()) {
            case "creditcard":
                paymentContext.setPaymentStrategy(new CreditCardPayment());
                break;
            case "debitcard":
                paymentContext.setPaymentStrategy(new DebitCardPayment());
                break;
            case "paypal":
                paymentContext.setPaymentStrategy(new PayPalPayment());
                break;
            default:
                System.out.println("Unknown payment type: " + paymentType);
                return false;
        }

        boolean success = false;

        if ("paypal".equalsIgnoreCase(paymentType)) {
            success = paymentContext.executePayment(
                    payment.getAmount(),
                    "customer@example.com",
                    "paypal_password",
                    null
            );
        } else {
            success = paymentContext.executePayment(
                    payment.getAmount(),
                    payment.getCardNumber(),
                    payment.getExpiryDate(),
                    payment.getCvv()
            );
        }

        if (success) {
            payment.setStatus("Pending");
            payment.setPaymentType(paymentContext.getCurrentPaymentMethod());
        } else {
            payment.setStatus("Failed");
        }

        // Save to database
        return paymentDAO.addPayment(payment);
    }

    public void demonstrateStrategyPattern() {
        System.out.println("=== DEMONSTRATING STRATEGY PATTERN ===");

        PaymentContext context = new PaymentContext();

        System.out.println("1. Testing Credit Card Payment:");
        context.setPaymentStrategy(new CreditCardPayment());
        context.executePayment(100.0, "1234567812345678", "12/25", "123");

        System.out.println("2. Testing Debit Card Payment:");
        context.setPaymentStrategy(new DebitCardPayment());
        context.executePayment(150.0, "8765432187654321", "06/24", "456");

        System.out.println("3. Testing PayPal Payment:");
        context.setPaymentStrategy(new PayPalPayment());
        context.executePayment(200.0, "customer@example.com", "securepass", null);

        System.out.println("=== STRATEGY PATTERN DEMONSTRATION COMPLETE ===");
    }

    public Payment getPaymentById(int paymentId) {
        return paymentDAO.getPaymentById(paymentId);
    }

    public boolean updatePayment(Payment payment) {
        return paymentDAO.updatePayment(payment);
    }

    public boolean updateBookingStatus(int bookingId, String status) {
        try {
            com.travel.dao.BookingDAO bookingDAO = new com.travel.dao.BookingDAO();
            return bookingDAO.updateBookingStatus(bookingId, status);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public Payment getPaymentByBookingId(int bookingId) {
        return paymentDAO.getPaymentByBookingId(bookingId);
    }

    public List<Payment> getPaymentsByStatus(String status) {
        return paymentDAO.getPaymentsByStatus(status);
    }

    public boolean failPayment(int paymentId) {
        return paymentDAO.updatePaymentStatus(paymentId, "Failed");
    }

    public List<Payment> getAllPayments() {
        return paymentDAO.getAllPayments();
    }

    public List<Payment> getPaymentsByCustomerId(int customerId) {
        return paymentDAO.getPaymentsByCustomerId(customerId);
    }

    public List<Payment> getPendingPayments() {
        return paymentDAO.getPendingPayments();
    }

    public boolean updatePaymentStatus(int paymentId, String status) {
        String normalizedStatus = status.substring(0, 1).toUpperCase() +
                status.substring(1).toLowerCase();
        return paymentDAO.updatePaymentStatus(paymentId, normalizedStatus);
    }

    public boolean deletePayment(int paymentId) {
        return paymentDAO.deletePayment(paymentId);
    }

    public double getTotalRevenue() {
        return paymentDAO.getTotalRevenue();
    }
}