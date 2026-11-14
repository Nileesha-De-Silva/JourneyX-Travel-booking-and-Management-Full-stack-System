package com.travel.controller.admin;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import com.travel.model.SystemAdmin;
import com.travel.service.FeedbackService;
import com.travel.model.Feedback;
import java.util.List;

public class SystemOverviewServlet extends HttpServlet {
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

        String action = request.getParameter("action");

        if (action == null) {
            action = "bookings";
        }

        switch (action) {
            case "bookings":
                request.getRequestDispatcher("/views/system-admin/overview/bookings.jsp").forward(request, response);
                break;
            case "revenue":
                request.getRequestDispatcher("/views/system-admin/overview/revenue.jsp").forward(request, response);
                break;
            case "feedback":
                FeedbackService feedbackService = new FeedbackService();
                List<Feedback> feedbacks = feedbackService.getAllFeedbacks();
                request.setAttribute("feedbacks", feedbacks);
                request.getRequestDispatcher("/views/system-admin/overview/feedback.jsp").forward(request, response);
                break;
            case "pending-actions":
                request.getRequestDispatcher("/views/system-admin/overview/pending-actions.jsp").forward(request, response);
                break;
            default:
                request.getRequestDispatcher("/views/system-admin/overview/bookings.jsp").forward(request, response);
                break;
        }
    }
}