<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.travel.model.Receipt" %>
<%@ page import="com.travel.service.ReceiptService" %>

<%
    int bookingId = Integer.parseInt(request.getParameter("bookingId"));
    ReceiptService receiptService = new ReceiptService();
    Receipt receipt = receiptService.getReceiptByBookingId(bookingId);

    if (receipt == null) {
        response.sendRedirect(request.getContextPath() + "/booking-manager/list?error=Receipt not found");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Booking Receipt</title>
    <style>
        .receipt-container {
            max-width: 600px;
            margin: 50px auto;
            padding: 20px;
            border: 1px solid #ddd;
            font-family: monospace;
            white-space: pre-line;
        }
        .receipt-header {
            text-align: center;
            margin-bottom: 20px;
        }
        .receipt-actions {
            margin-top: 20px;
            text-align: center;
        }
    </style>
</head>
<body>
<jsp:include page="/views/common/header-bookingmanager.jsp"/>

<div class="receipt-container">
    <div class="receipt-header">
        <h2>Booking Receipt</h2>
        <p>Booking ID: <%= bookingId %></p>
    </div>

    <div class="receipt-content">
        <%= receipt.getContent() %>
    </div>

    <div class="receipt-actions">
        <% if (!receipt.isSent()) { %>
        <form action="<%= request.getContextPath() %>/booking-manager/list" method="post">
            <input type="hidden" name="action" value="send-receipt">
            <input type="hidden" name="id" value="<%= bookingId %>">
            <input type="submit" value="Send Receipt to Customer" class="btn-receipt">
        </form>
        <% } else { %>
        <p>Receipt sent to customer on <%= receipt.getGeneratedDate() %></p>
        <% } %>

        <a href="<%= request.getContextPath() %>/booking-manager/list?action=view-confirmed">Back to Bookings</a>
    </div>
</div>

<jsp:include page="/views/common/footer.jsp"/>
</body>
</html>