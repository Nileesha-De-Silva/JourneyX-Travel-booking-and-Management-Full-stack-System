<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.travel.model.Booking" %>
<%@ page import="com.travel.model.Package" %>
<%@ page import="com.travel.dao.PackageDAO" %>
<%
    Booking booking = (Booking) request.getAttribute("booking");
    String errorMessage = (String) request.getAttribute("errorMessage");
    String successMessage = (String) request.getAttribute("successMessage");
    String selectedPaymentType = request.getParameter("paymentType");
    if (selectedPaymentType == null) selectedPaymentType = "";

    Package tourPackage = null;
    if (booking != null) {
        PackageDAO packageDAO = new PackageDAO();
        tourPackage = packageDAO.getPackageById(booking.getPackageId());
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Make Payment - Customer</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/main.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/Customer/make-payment.css">
</head>
<body>
<jsp:include page="/views/common/header-customer.jsp"/>

<div class="payment-container">
    <div class="payment-header">
        <h2>💳 Make Payment</h2>
    </div>

    <% if (errorMessage != null) { %>
    <div class="alert alert-error"><%= errorMessage %></div>
    <% } %>
    <% if (successMessage != null) { %>
    <div class="alert alert-success"><%= successMessage %></div>
    <% } %>

    <% if (booking != null && tourPackage != null) { %>
    <!-- Booking Summary Card -->
    <div class="card booking-summary">
        <h3>Booking Details</h3>
        <table>
            <tr><td>Booking ID</td><td><%= booking.getBookingId() %></td></tr>
            <tr><td>Package</td><td><%= tourPackage.getPackageName() %></td></tr>
            <tr><td>Travelers</td><td><%= booking.getNumTravelers() %></td></tr>
            <tr><td>Total Amount</td><td>$<%= booking.getTotalPrice() %></td></tr>
        </table>
    </div>

    <!-- Payment Type Card -->
    <div class="card payment-selection">
        <h3>Select Payment Type</h3>
        <form action="<%= request.getContextPath() %>/customer/payments/make" method="get">
            <input type="hidden" name="bookingId" value="<%= booking.getBookingId() %>">
            <select name="paymentType" onchange="this.form.submit()">
                <option value="">-- Choose Payment Type --</option>
                <option value="creditcard" <%= "creditcard".equals(selectedPaymentType) ? "selected" : "" %>>Credit Card</option>
                <option value="debitcard" <%= "debitcard".equals(selectedPaymentType) ? "selected" : "" %>>Debit Card</option>
                <option value="paypal" <%= "paypal".equals(selectedPaymentType) ? "selected" : "" %>>PayPal</option>
            </select>
        </form>
    </div>

    <% if (!selectedPaymentType.isEmpty()) { %>
    <div class="card payment-form">
        <h3>Payment Information</h3>
        <form action="<%= request.getContextPath() %>/customer/payments/make" method="post">
            <input type="hidden" name="bookingId" value="<%= booking.getBookingId() %>">
            <input type="hidden" name="paymentType" value="<%= selectedPaymentType %>">

            <table>
                <tr>
                    <td>Payment Method</td>
                    <td>
                        <select name="method" required>
                            <option value="">-- Select Payment Method --</option>
                            <% if ("creditcard".equals(selectedPaymentType)) { %>
                            <option value="Credit Card">Credit Card</option>
                            <% } else if ("debitcard".equals(selectedPaymentType)) { %>
                            <option value="Debit Card">Debit Card</option>
                            <% } else if ("paypal".equals(selectedPaymentType)) { %>
                            <option value="PayPal">PayPal</option>
                            <% } %>
                        </select>
                    </td>
                </tr>

                <% if ("creditcard".equals(selectedPaymentType) || "debitcard".equals(selectedPaymentType)) { %>
                <tr><td>Card Number</td><td><input type="text" name="cardNumber" placeholder="XXXX-XXXX-XXXX-XXXX" maxlength="19" required></td></tr>
                <tr><td>Expiry Date</td><td><input type="text" name="expiryDate" placeholder="MM/YY" maxlength="5" required></td></tr>
                <tr><td>CVV</td><td><input type="text" name="cvv" placeholder="XXX" maxlength="3" required></td></tr>
                <% } %>

                <% if ("paypal".equals(selectedPaymentType)) { %>
                <tr><td>PayPal Email</td><td><input type="email" name="paypalEmail" placeholder="your-email@example.com" required></td></tr>
                <% } %>

                <tr>
                    <td colspan="2" class="text-center">
                        <input type="submit" value="Submit Payment">
                        <input type="reset" value="Reset">
                    </td>
                </tr>
            </table>
        </form>
    </div>
    <% } %>

    <div class="center-links">
        <a href="<%= request.getContextPath() %>/tour-customer-dashboard" class="secondary-btn">Back to Dashboard</a>
    </div>

    <% } else { %>
    <div class="card">
        <p>No booking found. Please select a valid booking.</p>
        <a href="<%= request.getContextPath() %>/customer/bookings/history">View Your Bookings</a>
    </div>
    <% } %>
</div>

<jsp:include page="/views/common/footer.jsp"/>
</body>
</html>
