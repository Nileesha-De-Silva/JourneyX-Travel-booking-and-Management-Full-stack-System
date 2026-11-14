package com.travel.strategy;

public class PaymentContext {
    private PaymentStrategy paymentStrategy;
    private int paymentId;
    private double amount;
    private String status;

    public PaymentContext() {
        this.status = "Pending";
    }

    public void setPaymentStrategy(PaymentStrategy paymentStrategy) {
        this.paymentStrategy = paymentStrategy;
    }

    public boolean executePayment(double amount, String param1, String param2, String param3) {
        this.amount = amount;

        if (paymentStrategy == null) {
            System.out.println("No payment strategy selected");
            this.status = "Failed";
            return false;
        }

        System.out.println("Using payment method: " + paymentStrategy.getPaymentMethod());
        System.out.println("Payment details: " + paymentStrategy.getPaymentDetails());

        boolean success = paymentStrategy.processPayment(amount, param1, param2, param3);

        if (success) {
            this.status = "Pending";
            System.out.println("Payment completed successfully!");
        } else {
            this.status = "Failed";
            System.out.println("Payment failed!");
        }

        return success;
    }

    // Getters
    public String getCurrentPaymentMethod() {
        return paymentStrategy != null ? paymentStrategy.getPaymentMethod() : "None";
    }

    public String getStatus() {
        return status;
    }

    public double getAmount() {
        return amount;
    }

    public int getPaymentId() {
        return paymentId;
    }

    public void setPaymentId(int paymentId) {
        this.paymentId = paymentId;
    }
}