<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.travel.model.Package" %>
<%@ page import="java.util.List" %>
<%
    List<Package> packages = (List<Package>) request.getAttribute("packages");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Packages - Customer</title>
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/Customer/package-list.css">
</head>
<body>
<jsp:include page="/views/common/header-customer.jsp"/>

<div class="package-container">
    <h2 class="page-title">Available Packages</h2>

    <% if (packages != null && !packages.isEmpty()) { %>
    <div class="package-grid">
        <% for (Package pkg : packages) { %>
        <div class="package-card">
            <div class="package-header">
                <h3 class="package-title"><%= pkg.getPackageName() %></h3>
                <p class="package-price">$<%= pkg.getPrice() %></p>
            </div>

            <div class="package-body">
                <p><strong>Destinations:</strong> <%= pkg.getDestinations() %></p>
                <p><strong>Start Date:</strong> <%= pkg.getStartDate() %></p>
                <p><strong>Duration:</strong> <%= pkg.getDuration() %></p>
            </div>

            <div class="package-footer">
                <a href="<%= request.getContextPath() %>/tour-customer-packages/details?id=<%= pkg.getPackageId() %>" class="btn-details">View Details</a>
            </div>
        </div>
        <% } %>
    </div>
    <% } else { %>
    <p class="no-packages">No packages available at the moment.</p>
    <% } %>
</div>

<jsp:include page="/views/common/footer.jsp"/>
</body>
</html>
