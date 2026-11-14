<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.travel.model.Booking" %>
<%@ page import="com.travel.model.Payment" %>
<%@ page import="com.travel.service.ReceiptService" %>
<%@ page import="com.travel.service.PaymentService" %>
<%@ page import="com.travel.model.Receipt" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%
    List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");
    Map<Integer, String> paymentStatusMap = (Map<Integer, String>) request.getAttribute("paymentStatusMap");
    ReceiptService receiptService = new ReceiptService();
    PaymentService paymentService = new PaymentService();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Booking History - Customer</title>
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/Customer/booking-history.css">
</head>
<body>
<jsp:include page="/views/common/header-customer.jsp"/>

<div class="container">
    <h2>My Booking History</h2>

    <% if (request.getParameter("success") != null) { %>
    <div class="success"><%= request.getParameter("success") %></div>
    <% } %>
    <% if (request.getAttribute("successMessage") != null) { %>
    <div class="success"><%= request.getAttribute("successMessage") %></div>
    <% } %>
    <% if (request.getParameter("error") != null) { %>
    <div class="error"><%= request.getParameter("error") %></div>
    <% } %>
    <% if (request.getAttribute("errorMessage") != null) { %>
    <div class="error"><%= request.getAttribute("errorMessage") %></div>
    <% } %>

    <h3>Booking Summary</h3>
    <table>
        <tr>
            <th>Total Bookings</th>
            <th>Confirmed Bookings</th>
            <th>Pending Bookings</th>
            <th>Cancelled Bookings</th>
        </tr>
        <tr>
            <td><%= bookings != null ? bookings.size() : 0 %></td>
            <td>
                <%
                    int confirmedCount = 0;
                    if (bookings != null) {
                        for (Booking booking : bookings) {
                            if ("Confirmed".equals(booking.getConfirmationStatus())) {
                                confirmedCount++;
                            }
                        }
                    }
                %>
                <%= confirmedCount %>
            </td>
            <td>
                <%
                    int pendingCount = 0;
                    if (bookings != null) {
                        for (Booking booking : bookings) {
                            if ("Pending".equals(booking.getConfirmationStatus())) {
                                pendingCount++;
                            }
                        }
                    }
                %>
                <%= pendingCount %>
            </td>
            <td>
                <%
                    int cancelledCount = 0;
                    if (bookings != null) {
                        for (Booking booking : bookings) {
                            if ("Cancelled".equals(booking.getConfirmationStatus())) {
                                cancelledCount++;
                            }
                        }
                    }
                %>
                <%= cancelledCount %>
            </td>
        </tr>
    </table>

    <h3>Booking History</h3>
    <table>
        <tr>
            <th>Booking ID</th>
            <th>Package ID</th>
            <th>Booking Date</th>
            <th>Booking Status</th>
            <th>Payment Status</th>
            <th>Actions</th>
        </tr>
        <% if (bookings != null && !bookings.isEmpty()) { %>
        <% for (Booking booking : bookings) {
            String paymentStatus = paymentStatusMap != null ? paymentStatusMap.get(booking.getBookingId()) : "No Payment";
            Receipt receipt = receiptService.getReceiptByBookingId(booking.getBookingId());
            System.out.println("Customer - Booking ID: " + booking.getBookingId() + ", Status: " + booking.getConfirmationStatus() + ", Receipt: " + (receipt != null ? "Found" : "Not Found"));
        %>
        <tr>
            <td><%= booking.getBookingId() %></td>
            <td><%= booking.getPackageId() %></td>
            <td><%= booking.getBookingDate() %></td>
            <td>
                <% if ("Pending".equals(booking.getConfirmationStatus())) { %>
                <span class="status-pending"><%= booking.getConfirmationStatus() %></span>
                <% } else if ("Confirmed".equals(booking.getConfirmationStatus())) { %>
                <span class="status-confirmed"><%= booking.getConfirmationStatus() %></span>
                <% } else if ("Cancelled".equals(booking.getConfirmationStatus())) { %>
                <span class="status-cancelled"><%= booking.getConfirmationStatus() %></span>
                <% } else { %>
                <%= booking.getConfirmationStatus() %>
                <% } %>
            </td>
            <td>
                <% if ("Pending".equals(paymentStatus)) { %>
                <span class="status-pending"><%= paymentStatus %></span>
                <% } else if ("Approved".equals(paymentStatus)) { %>
                <span class="status-approved"><%= paymentStatus %></span>
                <% } else if ("Rejected".equals(paymentStatus)) { %>
                <span class="status-rejected"><%= paymentStatus %></span>
                <% } else { %>
                <%= paymentStatus %>
                <% } %>
            </td>
            <td>
                <div class="action-buttons">
                    <a href="<%= request.getContextPath() %>/customer/bookings/status" class="btn-view">View Status</a>
                    <% if (!"Cancelled".equals(booking.getConfirmationStatus())) { %>
                    <a href="<%= request.getContextPath() %>/customer/bookings/cancel" class="btn-cancel">Cancel Booking</a>
                    <% } %>
                    <% if ("Confirmed".equals(booking.getConfirmationStatus())) { 
                        Payment payment = paymentService.getPaymentByBookingId(booking.getBookingId());
                    %>
                    <div class="receipt-buttons">
                        <% if (receipt != null) { %>
                        <a href="<%= request.getContextPath() %>/customer/receipt/<%= booking.getBookingId() %>" class="btn-receipt btn-booking-receipt">View Booking Receipt</a>
                        <% } else { %>
                        <span class="no-receipt">Booking Receipt not available</span>
                        <% } %>
                        
                        <% if (payment != null && "Approved".equals(payment.getStatus())) { %>
                        <a href="<%= request.getContextPath() %>/customer/payment-receipt/<%= booking.getBookingId() %>" class="btn-receipt btn-payment-receipt">View Payment Receipt</a>
                        <% } else { %>
                        <span class="no-receipt">Payment Receipt not available</span>
                        <% } %>
                    </div>
                    <% } %>
                </div>
            </td>
        </tr>
        <% }
        } else { %>
        <tr>
            <td colspan="6">No bookings found</td>
        </tr>
        <% } %>
    </table>

    <h3>Quick Actions</h3>
    <table>
        <tr>
            <td>
                <a href="<%= request.getContextPath() %>/customer/bookings/status">Check Booking Status</a>
                <p>View the current status of your bookings</p>
            </td>
        </tr>
        <tr>
            <td>
                <a href="<%= request.getContextPath() %>/customer/packages/list">Browse More Packages</a>
                <p>Book additional travel packages</p>
            </td>
        </tr>
        <tr>
            <td>
                <a href="<%= request.getContextPath() %>/customer/payments/history">View Payment History</a>
                <p>Check your payment records and receipts</p>
            </td>
        </tr>
        <tr>
            <td>
                <a href="<%= request.getContextPath() %>/tour-customer-support?action=create">Contact Support</a>
                <p>Get help with your bookings</p>
            </td>
        </tr>
    </table>

    <div class="status-guide">
        <h4>Status Guide:</h4>
        <ul>
            <li><span class="status-pending">Pending</span> - Your booking/payment is being processed and awaiting approval</li>
            <li><span class="status-approved">Approved</span> / <span class="status-confirmed">Confirmed</span> - Your booking/payment has been approved</li>
            <li><span class="status-rejected">Rejected</span> / <span class="status-cancelled">Cancelled</span> - Your booking/payment was rejected or cancelled</li>
            <li><strong>View Receipt</strong> - Available for confirmed bookings that have a receipt generated</li>
        </ul>
    </div>
</div>

<jsp:include page="/views/common/footer.jsp"/>
</body>
</html>