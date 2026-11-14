package com.travel.strategy;

public class PayPalPayment implements PaymentStrategy {

    @Override
    public boolean processPayment(double amount, String email, String password, String unused) {
        System.out.println("Processing PayPal payment of $" + amount);
        System.out.println("PayPal Email: " + email);

        if (email == null || !email.contains("@")) {
            System.out.println("Invalid PayPal email");
            return false;
        }

        if (password == null || password.length() < 6) {
            System.out.println("Invalid PayPal credentials");
            return false;
        }

        System.out.println("PayPal payment processed successfully");
        return true;
    }

    @Override
    public String getPaymentMethod() {
        return "PayPal";
    }

    @Override
    public String getPaymentDetails() {
        return "PayPal Payment - Secure online payment system";
    }
}