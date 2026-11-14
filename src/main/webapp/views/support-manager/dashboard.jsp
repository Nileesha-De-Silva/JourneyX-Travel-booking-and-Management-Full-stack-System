<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.travel.model.CustomerSupportOfficer" %>
<%
    CustomerSupportOfficer officer = (CustomerSupportOfficer) session.getAttribute("user");
    if (officer == null) {
        response.sendRedirect(request.getContextPath() + "/tour-login");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Support Dashboard</title>
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/Support-Officer/dashboard.css">
</head>
<body>
<jsp:include page="../common/header-support-officer.jsp"/>

<div class="dashboard-container">
    <div class="dashboard-header">
        <h1>Customer Support Dashboard</h1>
        <p>Welcome, <%= officer.getName() %>! Manage customer support operations efficiently.</p>
    </div>

    <h3>Quick Actions</h3>
    <div class="quick-actions">
        <div class="quick-action">
            <a href="<%= request.getContextPath() %>/tour-support-officer-panel?action=feedback-list">
                <img src="https://media.istockphoto.com/id/2155637046/photo/feedback-360-cycle-feedback.jpg?s=612x612&w=0&k=20&c=Ml5vjvSu74eodDGSslzD4U41fQnoFpAcw99Jd-LkH9s=" alt="View All Feedback" class="action-image">
                <div class="action-content">
                    <div class="action-icon">
                        <svg viewBox="0 0 24 24">
                            <path d="M20 2H4c-1.1 0-1.99.9-1.99 2L2 22l4-4h14c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2zm-2 12H6v-2h12v2zm0-3H6V9h12v2zm0-3H6V6h12v2z"/>
                        </svg>
                    </div>
                    <span class="action-title">View All Feedback</span>
                    <p class="action-description">Review customer feedback and ratings</p>
                </div>
            </a>
        </div>
        <div class="quick-action">
            <a href="<%= request.getContextPath() %>/tour-support-officer-panel?action=issue-list">
                <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRIFfo2ovs6KyzfgGaiP4yFe5TpWv0ThY3bfw&s" alt="View All Issues" class="action-image">
                <div class="action-content">
                    <div class="action-icon">
                        <svg viewBox="0 0 24 24">
                            <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 15h-2v-6h2v6zm0-8h-2V7h2v2z"/>
                        </svg>
                    </div>
                    <span class="action-title">View All Issues</span>
                    <p class="action-description">Check reported issues and concerns</p>
                </div>
            </a>
        </div>
        <div class="quick-action">
            <a href="<%= request.getContextPath() %>/tour-support-officer-panel?action=reply-issue">
                <img src="https://www.shutterstock.com/image-photo/reply-feedback-answers-information-questions-260nw-453335287.jpg" alt="Reply to Issues" class="action-image">
                <div class="action-content">
                    <div class="action-icon">
                        <svg viewBox="0 0 24 24">
                            <path d="M20 2H4c-1.1 0-2 .9-2 2v18l4-4h14c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2z"/>
                        </svg>
                    </div>
                    <span class="action-title">Reply to Issues</span>
                    <p class="action-description">Respond to customer issues</p>
                </div>
            </a>
        </div>
    </div>

    <div class="account-info">
        <h3>Account Information</h3>
        <table>
            <tr>
                <td>Employee ID:</td>
                <td><%= officer.getEmployeeId() %></td>
            </tr>
            <tr>
                <td>Name:</td>
                <td><%= officer.getName() %></td>
            </tr>
            <tr>
                <td>Job Title:</td>
                <td><%= officer.getJobTitle() %></td>
            </tr>
            <tr>
                <td>Department:</td>
                <td><%= officer.getDepartment() %></td>
            </tr>
            <tr>
                <td>Email:</td>
                <td><%= officer.getEmail() %></td>
            </tr>
            <tr>
                <td>Contact Number:</td>
                <td><%= officer.getContactNumber() %></td>
            </tr>
        </table>
    </div>
</div>

<jsp:include page="/views/common/footer.jsp"/>
</body>
</html>