<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.travel.model.BookingManager" %>
<%@ page import="com.travel.model.Booking" %>
<%@ page import="com.travel.service.BookingService" %>
<%@ page import="com.travel.service.ReceiptService" %>
<%@ page import="com.travel.model.Receipt" %>
<%@ page import="java.util.List" %>

<%
    BookingManager manager = (BookingManager) session.getAttribute("user");
    if (manager == null) {
        response.sendRedirect(request.getContextPath() + "/tour-login");
        return;
    }

    BookingService bookingService = new BookingService();
    ReceiptService receiptService = new ReceiptService();
    List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");
    String statusFilter = (String) request.getAttribute("statusFilter");

    if (bookings == null) {
        bookings = bookingService.getAllBookings();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>All Bookings - Booking Manager</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Booking-Manager/list.css">
    <style>
        .btn-receipt {
            background-color: #17a2b8;
            color: white;
            padding: 6px 12px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            margin-right: 5px;
            text-decoration: none;
            display: inline-block;
        }
        .btn-receipt:hover {
            background-color: #138496;
        }
        .btn-send-receipt {
            background-color: #28a745;
            color: white;
            padding: 6px 12px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            margin-right: 5px;
            text-decoration: none;
            display: inline-block;
        }
        .btn-send-receipt:hover {
            background-color: #218838;
        }
        .btn-view-receipt {
            background-color: #6f42c1;
            color: white;
            padding: 6px 12px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            margin-right: 5px;
            text-decoration: none;
            display: inline-block;
        }
        .btn-view-receipt:hover {
            background-color: #5a32a3;
            color: white;
            text-decoration: none;
        }
        .receipt-sent, .receipt-status {
            color: #28a745;
            font-weight: bold;
            font-size: 12px;
        }
        .booking-card-actions {
            display: flex;
            flex-wrap: wrap;
            gap: 5px;
        }
        .receipt-actions {
            display: flex;
            flex-wrap: wrap;
            gap: 5px;
            margin-top: 5px;
            padding-top: 5px;
            border-top: 1px solid #eee;
        }
    </style>
</head>
<body>

<jsp:include page="/views/common/header-bookingmanager.jsp"/>

<h2>All Bookings</h2>

<% if (request.getParameter("success") != null) { %>
<div class="success"><%= request.getParameter("success") %></div>
<% } %>
<% if (request.getParameter("error") != null) { %>
<div class="error"><%= request.getParameter("error") %></div>
<% } %>

<div class="filter-options">
    <a href="<%= request.getContextPath() %>/booking-manager/dashboard">Back to Dashboard</a> |
    <a href="<%= request.getContextPath() %>/booking-manager/list?action=list">All</a> |
    <a href="<%= request.getContextPath() %>/booking-manager/list?action=view-pending">Pending</a> |
    <a href="<%= request.getContextPath() %>/booking-manager/list?action=view-confirmed">Confirmed</a> |
    <a href="<%= request.getContextPath() %>/booking-manager/list?action=view-cancelled">Cancelled</a>
</div>

<h3>Booking List</h3>

<% if (bookings != null && !bookings.isEmpty()) { %>
<div class="booking-card-container">
    <% for (Booking booking : bookings) { %>
    <div class="booking-card">
        <div class="booking-card-header">
            <h4>Booking ID: <%= booking.getBookingId() %></h4>
            <span class="status <%= booking.getConfirmationStatus().toLowerCase() %>">
                <%= booking.getConfirmationStatus() %>
            </span>
        </div>

        <div class="booking-card-body">
            <p><strong>Customer ID:</strong> <%= booking.getCustomerId() %></p>
            <p><strong>Package ID:</strong> <%= booking.getPackageId() %></p>
            <p><strong>Booking Date:</strong> <%= booking.getBookingDate() %></p>
            <p><strong>Travelers:</strong> <%= booking.getNumTravelers() %></p>
            <p><strong>Total Price:</strong> $<%= booking.getTotalPrice() %></p>
        </div>

        <div class="booking-card-actions">
            <% if ("Pending".equals(booking.getConfirmationStatus())) { %>
            <form action="<%= request.getContextPath() %>/booking-manager/list" method="post">
                <input type="hidden" name="action" value="confirm">
                <input type="hidden" name="id" value="<%= booking.getBookingId() %>">
                <button type="submit" class="btn btn-confirm">Confirm</button>
            </form>
            <% } %>

            <% if ("Confirmed".equals(booking.getConfirmationStatus())) { 
                Receipt receipt = receiptService.getReceiptByBookingId(booking.getBookingId());
            %>
            <!-- Receipt Actions for Confirmed Bookings -->
            <div class="receipt-actions">
                <% if (receipt == null) { %>
                <form action="<%= request.getContextPath() %>/booking-manager/list" method="post">
                    <input type="hidden" name="action" value="create-receipt">
                    <input type="hidden" name="id" value="<%= booking.getBookingId() %>">
                    <button type="submit" class="btn btn-receipt">Create Receipt</button>
                </form>
                <% } else { %>
                <span class="receipt-status">✓ Receipt Created</span>
                <a href="<%= request.getContextPath() %>/customer/receipt/<%= booking.getBookingId() %>" class="btn btn-view-receipt" target="_blank">View Receipt</a>
                <% if (!receipt.isSent()) { %>
                <form action="<%= request.getContextPath() %>/booking-manager/list" method="post">
                    <input type="hidden" name="action" value="send-receipt">
                    <input type="hidden" name="id" value="<%= booking.getBookingId() %>">
                    <button type="submit" class="btn btn-send-receipt">Send Receipt</button>
                </form>
                <% } else { %>
                <span class="receipt-sent">✓ Receipt Sent</span>
                <% } %>
                <% } %>
            </div>
            <% } %>

            <% if (!"Cancelled".equals(booking.getConfirmationStatus())) { %>
            <form action="<%= request.getContextPath() %>/booking-manager/list" method="post">
                <input type="hidden" name="action" value="cancel">
                <input type="hidden" name="id" value="<%= booking.getBookingId() %>">
                <button type="submit" class="btn btn-cancel"
                        onclick="return confirm('Are you sure you want to cancel this booking?')">Cancel</button>
            </form>
            <% } %>

            <% if ("Confirmed".equals(booking.getConfirmationStatus()) || "Cancelled".equals(booking.getConfirmationStatus())) { %>
            <form action="<%= request.getContextPath() %>/booking-manager/list" method="post">
                <input type="hidden" name="action" value="delete">
                <input type="hidden" name="id" value="<%= booking.getBookingId() %>">
                <button type="submit" class="btn btn-delete"
                        onclick="return confirm('Are you sure you want to delete this booking?')">Delete</button>
            </form>
            <% } %>
        </div>
    </div>
    <% } %>
</div>

<p class="total-bookings">Total Bookings: <%= bookings.size() %></p>

<% } else { %>
<p class="no-bookings">No bookings found.</p>
<% } %>

<div class="quick-actions">
    <h3>Quick Actions</h3>
    <table>
        <tr>
            <td>
                <a href="<%= request.getContextPath() %>/booking-manager/list?action=view-pending">View Pending Bookings</a>
                <p>Review and confirm bookings awaiting approval</p>
            </td>
        </tr>
        <tr>
            <td>
                <a href="<%= request.getContextPath() %>/booking-manager/list?action=view-confirmed">View Confirmed Bookings</a>
                <p>View all confirmed bookings</p>
            </td>
        </tr>
        <tr>
            <td>
                <a href="<%= request.getContextPath() %>/booking-manager/list?action=view-cancelled">View Cancelled Bookings</a>
                <p>View all cancelled bookings</p>
            </td>
        </tr>
    </table>
</div>

<jsp:include page="/views/common/footer.jsp"/>

</body>
</html>