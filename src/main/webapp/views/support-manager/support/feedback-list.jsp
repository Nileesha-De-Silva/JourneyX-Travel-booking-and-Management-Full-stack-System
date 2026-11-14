<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.travel.model.Feedback" %>
<%@ page import="java.util.List" %>
<%@ page import="com.travel.model.CustomerSupportOfficer" %>
<%
    CustomerSupportOfficer officer = (CustomerSupportOfficer) session.getAttribute("user");
    if (officer == null || !"supportOfficer".equals(session.getAttribute("userType"))) {
        response.sendRedirect(request.getContextPath() + "/tour-login");
        return;
    }
%>
<%@ include file="/views/common/header-support-officer.jsp" %>
<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/Support-Officer/list.css">

<div class="feedback-container">
    <h2>All Customer Feedback</h2>

    <%
        String success = request.getParameter("success");
        String error = request.getParameter("error");
        if (success != null) {
    %>
    <div class="success-message"><%= success %></div>
    <%
        }
        if (error != null) {
    %>
    <div class="error-message"><%= error %></div>
    <%
        }
    %>

    <div class="feedback-grid">
        <%
            List<Feedback> feedbacks = (List<Feedback>) request.getAttribute("feedbacks");
            if (feedbacks != null && !feedbacks.isEmpty()) {
                for (Feedback feedback : feedbacks) {
        %>
        <div class="feedback-card">
            <div class="feedback-info">
                <h3>Feedback #<%= feedback.getFeedbackId() %></h3>
                <p><strong>Customer ID:</strong> <%= feedback.getCustomerId() %></p>
                <p><strong>Description:</strong>
                    <%= feedback.getDescription().length() > 100
                            ? feedback.getDescription().substring(0, 100) + "..."
                            : feedback.getDescription() %>
                </p>
            </div>

            <form action="<%= request.getContextPath() %>/tour-support-officer-panel" method="post">
                <input type="hidden" name="action" value="delete-feedback">
                <input type="hidden" name="id" value="<%= feedback.getFeedbackId() %>">
                <button type="submit" class="btn-delete"
                        onclick="return confirm('Are you sure you want to delete this feedback?');">
                    Delete
                </button>
            </form>
        </div>
        <%
            }
        } else {
        %>
        <p class="no-data">No feedback found.</p>
        <%
            }
        %>
    </div>

    <div class="back-link">
        <a href="<%= request.getContextPath() %>/tour-support-dashboard" class="btn-back">← Back to Dashboard</a>
    </div>
</div>

<%@ include file="/views/common/footer.jsp" %>
