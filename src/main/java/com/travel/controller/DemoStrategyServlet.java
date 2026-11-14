package com.travel.controller;

import com.travel.strategy.*;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class DemoStrategyServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        demonstratePaymentStrategies();
    }

    private void demonstratePaymentStrategies() {
        System.out.println("=== STRATEGY PATTERN DEMONSTRATION ===");

        PaymentContext context = new PaymentContext();

        System.out.println("--- Credit Card Payment Strategy ---");
        context.setPaymentStrategy(new CreditCardPayment());
        context.executePayment(100.0, "4111111111111111", "12/25", "123");

        System.out.println("--- Debit Card Payment Strategy ---");
        context.setPaymentStrategy(new DebitCardPayment());
        context.executePayment(150.0, "5555666677778888", "06/24", "456");

        System.out.println("--- PayPal Payment Strategy ---");
        context.setPaymentStrategy(new PayPalPayment());
        context.executePayment(200.0, "customer@example.com", "password123", null);

        System.out.println("--- Dynamic Strategy Switching ---");
        System.out.println("Switching from Credit Card to PayPal at runtime...");
        context.setPaymentStrategy(new CreditCardPayment());
        context.executePayment(50.0, "4111111111111111", "12/25", "123");

        context.setPaymentStrategy(new PayPalPayment());
        context.executePayment(75.0, "customer@example.com", "password123", null);

        System.out.println("=== STRATEGY PATTERN DEMONSTRATION COMPLETE ===");
    }
}