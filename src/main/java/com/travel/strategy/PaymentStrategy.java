package com.travel.strategy;

public interface PaymentStrategy {
    boolean processPayment(double amount, String cardNumber, String expiryDate, String cvv);
    String getPaymentMethod();
    String getPaymentDetails();
}