package com.travel.strategy;

public class DebitCardPayment implements PaymentStrategy {

    @Override
    public boolean processPayment(double amount, String cardNumber, String expiryDate, String cvv) {
        System.out.println("Processing debit card payment of $" + amount);
        System.out.println("Card: " + cardNumber);

        if (cardNumber == null || cardNumber.length() != 16) {
            System.out.println("Invalid debit card number");
            return false;
        }

        if (cvv == null || cvv.length() != 3) {
            System.out.println("Invalid CVV");
            return false;
        }

        System.out.println("Debit card payment processed successfully");
        return true;
    }

    @Override
    public String getPaymentMethod() {
        return "Debit Card";
    }

    @Override
    public String getPaymentDetails() {
        return "Debit Card Payment - Direct bank account transaction";
    }

}