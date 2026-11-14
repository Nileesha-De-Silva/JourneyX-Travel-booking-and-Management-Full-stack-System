<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.travel.model.Package" %>
<%
    Package pkg = (Package) request.getAttribute("package");
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Package Details - Customer</title>
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/Customer/package-details.css">
</head>
<body>
<jsp:include page="/views/common/header-customer.jsp"/>

<div class="details-container">
    <h2 class="page-title">Package Details</h2>

    <% if (error != null) { %>
    <div class="error"><%= error %></div>
    <% } %>

    <% if (pkg != null) { %>
    <div class="details-card">
        <div class="details-header">
            <h3 class="package-title"><%= pkg.getPackageName() %></h3>
            <p class="price">$<%= pkg.getPrice() %></p>
        </div>

        <div class="details-body">
            <div class="info-grid">
                <div><strong>Duration:</strong> <%= pkg.getDuration() %></div>
                <div><strong>Start Date:</strong> <%= pkg.getStartDate() %></div>
                <div><strong>End Date:</strong> <%= pkg.getEndDate() %></div>
                <div><strong>Destinations:</strong> <%= pkg.getDestinations() %></div>
            </div>
            <div class="description">
                <h4>Description</h4>
                <p><%= pkg.getDescription() != null ? pkg.getDescription() : "No description available" %></p>
            </div>
        </div>

        <div class="details-footer">
            <a href="<%= request.getContextPath() %>/customer/bookings/create?packageId=<%= pkg.getPackageId() %>" class="btn-primary">Book Now</a>
            <a href="<%= request.getContextPath() %>/tour-customer-packages/list" class="btn-secondary">Back to Packages</a>
        </div>
    </div>
    <% } else { %>
    <p class="no-package">Package not found.</p>
    <p><a href="<%= request.getContextPath() %>/tour-customer-packages/list" class="btn-secondary">Back to Packages</a></p>
    <% } %>
</div>

<jsp:include page="/views/common/footer.jsp"/>
</body>
</html>
