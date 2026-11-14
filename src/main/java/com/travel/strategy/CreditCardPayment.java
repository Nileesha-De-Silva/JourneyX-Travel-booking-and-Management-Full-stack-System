package com.travel.strategy;

public class CreditCardPayment implements PaymentStrategy {

    @Override
    public boolean processPayment(double amount, String cardNumber, String expiryDate, String cvv) {
        System.out.println("Processing credit card payment of $" + amount);
        System.out.println("Card: " + cardNumber);

        if (cardNumber == null || cardNumber.length() != 16) {
            System.out.println("Invalid credit card number");
            return false;
        }

        if (cvv == null || cvv.length() != 3) {
            System.out.println("Invalid CVV");
            return false;
        }

        // Simulate payment processing
        System.out.println("Credit card payment processed successfully");
        return true;
    }

    @Override
    public String getPaymentMethod() {
        return "Credit Card";
    }

    @Override
    public String getPaymentDetails() {
        return "Credit Card Payment - Secure SSL encrypted transaction";
    }

}