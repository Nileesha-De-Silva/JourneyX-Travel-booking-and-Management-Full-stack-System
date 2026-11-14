<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.travel.model.Customer" %>

<%
    Customer customer = (Customer) session.getAttribute("user");
    if (customer == null) {
        response.sendRedirect(request.getContextPath() + "/tour-login");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Report an Issue</title>
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/Customer/report-issue.css">
</head>
<body>

<jsp:include page="../../common/header-customer.jsp" />

<div class="report-container">
    <h2 class="page-title">Report an Issue</h2>

    <% if (request.getAttribute("errorMessage") != null) { %>
    <div class="alert error"><%= request.getAttribute("errorMessage") %></div>
    <% } %>
    <% if (request.getAttribute("successMessage") != null) { %>
    <div class="alert success"><%= request.getAttribute("successMessage") %></div>
    <% } %>

    <div class="report-card">
        <form action="<%= request.getContextPath() %>/tour-customer-report-issue" method="post">
            <input type="hidden" name="action" value="report-issue"/>
            <input type="hidden" name="customerId" value="<%= customer.getCustomerId() %>"/>

            <label for="issueDetails">Issue Details</label>
            <textarea id="issueDetails" name="issueDetails" rows="6" placeholder="Describe the issue..." required></textarea>

            <div class="btn-group">
                <input type="submit" value="Submit Issue" class="btn-primary"/>
                <a href="<%= request.getContextPath() %>/tour-customer-dashboard" class="btn-secondary">Back to Dashboard</a>
            </div>
        </form>
    </div>
</div>

<jsp:include page="../../common/footer.jsp"/>

</body>
</html>
