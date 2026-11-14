// File: src/main/java/com/travel/controller/managers/ReceiptViewServlet.java
package com.travel.controller.managers;

import com.travel.service.ReceiptService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/booking-manager/receipt")
public class ReceiptViewServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String bookingIdParam = request.getParameter("bookingId");
        if (bookingIdParam == null || bookingIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/booking-manager/list?error=Booking ID is required");
            return;
        }

        int bookingId;
        try {
            bookingId = Integer.parseInt(bookingIdParam);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/booking-manager/list?error=Invalid booking ID");
            return;
        }

        request.setAttribute("bookingId", bookingId);
        request.getRequestDispatcher("/views/booking-manager/receipt.jsp").forward(request, response);
    }
}