<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.travel.model.Customer" %>
<%@ page import="com.travel.model.Booking" %>
<%@ page import="com.travel.model.Payment" %>

<%
    Customer customer = (Customer) session.getAttribute("user");
    if (customer == null) {
        response.sendRedirect(request.getContextPath() + "/tour-login");
        return;
    }

    String paymentReceiptContent = (String) request.getAttribute("paymentReceiptContent");
    Booking booking = (Booking) request.getAttribute("booking");
    Payment payment = (Payment) request.getAttribute("payment");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Payment Receipt - Customer Portal</title>
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/Customer/receipt.css">
    <style>
        .receipt-container {
            max-width: 800px;
            margin: 40px auto;
            padding: 30px;
            border: 1px solid #ddd;
            background-color: #fff;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            font-family: 'Courier New', monospace;
        }
        .receipt-header {
            text-align: center;
            margin-bottom: 30px;
            border-bottom: 2px solid #eee;
            padding-bottom: 20px;
        }
        .receipt-header h1 {
            margin: 0;
            color: #333;
        }
        .receipt-header p {
            margin: 5px 0;
            color: #666;
        }
        .receipt-content {
            white-space: pre-line;
            line-height: 1.6;
            color: #333;
        }
        .receipt-footer {
            margin-top: 30px;
            text-align: center;
            border-top: 1px dashed #ddd;
            padding-top: 20px;
            color: #666;
            font-size: 14px;
        }
        .receipt-actions {
            margin-top: 30px;
            text-align: center;
        }
        .btn {
            display: inline-block;
            padding: 10px 20px;
            margin: 0 10px;
            background-color: #007bff;
            color: white;
            text-decoration: none;
            border-radius: 4px;
            border: none;
            cursor: pointer;
            font-size: 16px;
        }
        .btn:hover {
            background-color: #0069d9;
        }
        .btn-secondary {
            background-color: #6c757d;
        }
        .btn-secondary:hover {
            background-color: #5a6268;
        }
        .btn-success {
            background-color: #28a745;
        }
        .btn-success:hover {
            background-color: #218838;
        }
        .btn-info {
            background-color: #17a2b8;
        }
        .btn-info:hover {
            background-color: #138496;
        }
        @media print {
            .receipt-actions {
                display: none;
            }
            .receipt-container {
                box-shadow: none;
                border: none;
            }
        }
    </style>
</head>
<body>

<jsp:include page="/views/common/header-customer.jsp"/>

<div class="receipt-container">
    <div class="receipt-header">
        <h1>Payment Receipt</h1>
        <p>Payment ID: <%= payment.getPaymentId() %></p>
        <p>Booking ID: <%= booking.getBookingId() %></p>
        <p>Generated on: <%= new java.util.Date() %></p>
    </div>

    <div class="receipt-content">
        <%= paymentReceiptContent %>
    </div>

    <div class="receipt-footer">
        <p>This is your payment receipt.</p>
        <p>Keep this receipt for your records.</p>
    </div>

    <div class="receipt-actions">
        <button class="btn btn-success" onclick="window.print()">Print Payment Receipt</button>
        <a href="<%= request.getContextPath() %>/customer/receipt/<%= booking.getBookingId() %>" class="btn btn-info">View Booking Receipt</a>
        <a href="<%= request.getContextPath() %>/customer/bookings/history" class="btn btn-secondary">Back to Booking History</a>
    </div>
</div>

<jsp:include page="/views/common/footer.jsp"/>

</body>
</html>
