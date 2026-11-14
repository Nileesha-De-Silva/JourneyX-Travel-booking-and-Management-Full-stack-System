// File: src/main/java/com/travel/controller/customer/ReceiptServlet.java
package com.travel.controller.customer;

import com.travel.model.Customer;
import com.travel.model.Booking;
import com.travel.model.Receipt;
import com.travel.service.BookingService;
import com.travel.service.ReceiptService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

public class ReceiptServlet extends HttpServlet {
    private ReceiptService receiptService;
    private BookingService bookingService;

    @Override
    public void init() {
        receiptService = new ReceiptService();
        bookingService = new BookingService();
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
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        // Extract booking ID from path
        String[] pathParts = pathInfo.split("/");
        if (pathParts.length < 2) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        try {
            int bookingId = Integer.parseInt(pathParts[1]);
            Customer customer = (Customer) session.getAttribute("user");
            int customerId = customer.getCustomerId();

            // Verify this booking belongs to the current customer
            Booking booking = bookingService.getBookingById(bookingId);
            if (booking == null || booking.getCustomerId() != customerId) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "You don't have permission to view this receipt");
                return;
            }

            // Get receipt for this booking
            Receipt receipt = receiptService.getReceiptByBookingId(bookingId);
            if (receipt == null) {
                request.setAttribute("errorMessage", "No receipt found for this booking");
                request.getRequestDispatcher("/views/common/error.jsp").forward(request, response);
                return;
            }

            request.setAttribute("receipt", receipt);
            request.setAttribute("booking", booking);
            request.getRequestDispatcher("/views/customer/receipt.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid booking ID");
        }
    }
}