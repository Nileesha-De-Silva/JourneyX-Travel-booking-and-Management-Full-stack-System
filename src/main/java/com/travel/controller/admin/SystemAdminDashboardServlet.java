package com.travel.controller.admin;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import com.travel.model.SystemAdmin;
import com.travel.service.BookingService;
import com.travel.service.CustomerService;
import com.travel.service.PackageService;
import com.travel.service.PaymentService;

public class SystemAdminDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null ||
                !"systemAdmin".equals(session.getAttribute("userType"))) {
            response.sendRedirect(request.getContextPath() + "/tour-login");
            return;
        }

        SystemAdmin admin = (SystemAdmin) session.getAttribute("user");
        request.setAttribute("admin", admin);
        
        // Calculate system statistics
        BookingService bookingService = new BookingService();
        CustomerService customerService = new CustomerService();
        PackageService packageService = new PackageService();
        PaymentService paymentService = new PaymentService();
        
        // Booking statistics
        int totalBookings = bookingService.getTotalBookings();
        int pendingBookings = bookingService.getPendingBookingsCount();
        int confirmedBookings = bookingService.getConfirmedBookingsCount();
        int cancelledBookings = bookingService.getCancelledBookingsCount();
        int totalTravelers = bookingService.getTotalTravelers();
        int confirmedTravelers = bookingService.getConfirmedTravelers();
        
        // Customer statistics
        int totalCustomers = customerService.getAllCustomers().size();
        
        // Package statistics
        int totalPackages = packageService.getAllPackages().size();
        
        // Payment statistics
        double totalRevenue = paymentService.getTotalRevenue();
        
        // Set statistics as request attributes
        request.setAttribute("totalBookings", totalBookings);
        request.setAttribute("pendingBookings", pendingBookings);
        request.setAttribute("confirmedBookings", confirmedBookings);
        request.setAttribute("cancelledBookings", cancelledBookings);
        request.setAttribute("totalTravelers", totalTravelers);
        request.setAttribute("confirmedTravelers", confirmedTravelers);
        request.setAttribute("totalCustomers", totalCustomers);
        request.setAttribute("totalPackages", totalPackages);
        request.setAttribute("totalRevenue", totalRevenue);
        
        request.getRequestDispatcher("/views/system-admin/dashboard.jsp").forward(request, response);
    }
}