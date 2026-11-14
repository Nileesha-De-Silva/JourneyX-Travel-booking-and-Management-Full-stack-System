<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.travel.model.Customer" %>
<%@ page import="com.travel.model.Package" %>
<%
    Customer customer = (Customer) session.getAttribute("user");
    if (customer == null) {
        response.sendRedirect(request.getContextPath() + "/tour-login");
        return;
    }

    Package tourPackage = (Package) request.getAttribute("package");
    if (tourPackage == null) {
        response.sendRedirect(request.getContextPath() + "/tour-customer-packages/list?error=Package+not+found");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Book a Package - Customer</title>
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/Customer/booking-create.css">
</head>
<body>
<jsp:include page="/views/common/header-customer.jsp"/>

<div class="booking-container">
    <h2 class="page-title">Book a Package</h2>

    <% if (request.getAttribute("errorMessage") != null) { %>
    <div class="error"><%= request.getAttribute("errorMessage") %></div>
    <% } %>

    <div class="card">
        <h3 class="section-title">Package Details</h3>
        <table class="info-table">
            <tr><td>Package Name:</td><td><%= tourPackage.getPackageName() %></td></tr>
            <tr><td>Price:</td><td>$<%= tourPackage.getPrice() %></td></tr>
            <tr><td>Duration:</td><td><%= tourPackage.getDuration() %></td></tr>
        </table>
    </div>

    <div class="card">
        <h3 class="section-title">Booking Information</h3>
        <form action="<%= request.getContextPath() %>/customer/bookings/create" method="post">
            <input type="hidden" name="packageId" value="<%= tourPackage.getPackageId() %>">

            <div class="form-group">
                <label>Preferred Booking Date:</label>
                <input type="date" name="bookingDate" required
                       min="<%= tourPackage.getStartDate() %>"
                       max="<%= tourPackage.getEndDate() %>">
                <small>Must be between package start and end dates</small>
            </div>

            <div class="form-group">
                <label>Number of Travelers:</label>
                <input type="number" name="numTravelers" min="1" max="20" value="1" required>
                <small>Maximum 20 travelers per booking</small>
            </div>

            <div class="form-actions">
                <input type="submit" value="Book Now" class="btn-primary">
                <input type="reset" value="Reset" class="btn-secondary">
            </div>
        </form>
    </div>

    <div class="back-link">
        <a href="<%= request.getContextPath() %>/tour-customer-packages/list">← Back to Packages</a>
    </div>
</div>

<jsp:include page="/views/common/footer.jsp"/>
</body>
</html>
