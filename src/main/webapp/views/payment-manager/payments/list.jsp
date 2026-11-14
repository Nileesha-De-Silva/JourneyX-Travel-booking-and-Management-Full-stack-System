<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.travel.model.Payment" %>
<%@ page import="com.travel.model.Receipt" %>
<%@ page import="com.travel.service.ReceiptService" %>
<%@ page import="java.util.List" %>
<%
    List<Payment> payments = (List<Payment>) request.getAttribute("payments");
    String statusFilter = (String) request.getAttribute("statusFilter");
    ReceiptService receiptService = new ReceiptService();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Payment Management</title>
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/Payment-Manager/list.css">
</head>
<body>
<jsp:include page="/views/common/header-paymentmanager.jsp"/>

<div class="container">
    <div class="header-section">
        <h2>Payment Management</h2>
        <% if (request.getParameter("success") != null) { %>
        <div class="alert success"><%= request.getParameter("success") %></div>
        <% } %>
        <% if (request.getParameter("error") != null) { %>
        <div class="alert error"><%= request.getParameter("error") %></div>
        <% } %>
    </div>

    <div class="filter-section">
        <h3>Filter Payments</h3>
        <div class="filter-links">
            <a href="<%= request.getContextPath() %>/tour-payment-manager-payments?status=All"
               class="<%= "All".equals(statusFilter) ? "active" : "" %>">All</a>
            <a href="<%= request.getContextPath() %>/tour-payment-manager-payments?status=Pending"
               class="<%= "Pending".equals(statusFilter) ? "active" : "" %>">Pending</a>
            <a href="<%= request.getContextPath() %>/tour-payment-manager-payments?status=Approved"
               class="<%= "Approved".equals(statusFilter) ? "active" : "" %>">Approved</a>
            <a href="<%= request.getContextPath() %>/tour-payment-manager-payments?status=Rejected"
               class="<%= "Rejected".equals(statusFilter) ? "active" : "" %>">Rejected</a>
        </div>
    </div>

    <h3>Payments</h3>
    <div class="payment-cards-container">
        <% if (payments != null && !payments.isEmpty()) {
            for (Payment payment : payments) { %>
        <div class="payment-card">
            <div class="payment-header">
                <h4>Payment #<%= payment.getPaymentId() %></h4>
                <% if ("Pending".equalsIgnoreCase(payment.getStatus())) { %>
                <span class="status status-pending"><%= payment.getStatus() %></span>
                <% } else if ("Approved".equalsIgnoreCase(payment.getStatus())) { %>
                <span class="status status-approved"><%= payment.getStatus() %></span>
                <% } else if ("Rejected".equalsIgnoreCase(payment.getStatus())) { %>
                <span class="status status-rejected"><%= payment.getStatus() %></span>
                <% } %>
            </div>

            <div class="payment-body">
                <p><strong>Customer ID:</strong> <%= payment.getCustomerId() %></p>
                <p><strong>Booking ID:</strong> <%= payment.getBookingId() %></p>
                <p><strong>Amount:</strong> $<%= payment.getAmount() %></p>
                <p><strong>Method:</strong> <%= payment.getMethod() %></p>
                <p><strong>Date:</strong> <%= payment.getPaymentDate() %></p>
            </div>

            <div class="payment-actions">
                <%System.out.println("Payment Status : " +  payment.getStatus());%>
                <% if ("Pending".equalsIgnoreCase(payment.getStatus())) { %>
                <%System.out.println("Pending...");%>
                <form action="<%= request.getContextPath() %>/tour-payment-manager-payments" method="post">
                    <input type="hidden" name="action" value="approve">
                    <input type="hidden" name="paymentId" value="<%= payment.getPaymentId() %>">
                    <button type="submit" class="btn btn-approve">Approve</button>
                </form>
                <form action="<%= request.getContextPath() %>/tour-payment-manager-payments" method="post">
                    <input type="hidden" name="action" value="reject">
                    <input type="hidden" name="paymentId" value="<%= payment.getPaymentId() %>">
                    <button type="submit" class="btn btn-reject">Reject</button>
                </form>
                <form action="<%= request.getContextPath() %>/tour-payment-manager-payments" method="post">
                    <input type="hidden" name="action" value="cancel">
                    <input type="hidden" name="paymentId" value="<%= payment.getPaymentId() %>">
                    <button type="submit" class="btn btn-cancel"
                            onclick="return confirm('Are you sure you want to cancel this booking?')">
                        Cancel
                    </button>
                </form>
                <%}%>

                <% if ("Approved".equals(payment.getStatus())) { 
                    Receipt receipt = receiptService.getReceiptByBookingId(payment.getBookingId());
                    System.out.println("Payment ID: " + payment.getPaymentId() + ", Booking ID: " + payment.getBookingId() + ", Receipt: " + (receipt != null ? "Found" : "Not Found"));
                %>
                <!-- Receipt Actions for Approved Payments -->
                <div class="receipt-actions">
                    <% if (receipt == null) { %>
                    <form action="<%= request.getContextPath() %>/tour-payment-manager-payments" method="post">
                        <input type="hidden" name="action" value="create-receipt">
                        <input type="hidden" name="paymentId" value="<%= payment.getPaymentId() %>">
                        <button type="submit" class="btn btn-receipt">Create Receipt</button>
                    </form>
                    <% } else { %>
                    <span class="receipt-status">✓ Receipt Created</span>
                    <a href="<%= request.getContextPath() %>/customer/receipt/<%= payment.getBookingId() %>" class="btn btn-view-receipt" target="_blank">View Receipt</a>
                    <% if (!receipt.isSent()) { %>
                    <form action="<%= request.getContextPath() %>/tour-payment-manager-payments" method="post">
                        <input type="hidden" name="action" value="send-receipt">
                        <input type="hidden" name="paymentId" value="<%= payment.getPaymentId() %>">
                        <button type="submit" class="btn btn-send-receipt">Send Receipt</button>
                    </form>
                    <% } else { %>
                    <span class="receipt-sent">✓ Receipt Sent</span>
                    <% } %>
                    <% } %>
                </div>
                <% } %>

                <% if ("Approved".equals(payment.getStatus()) || "Rejected".equals(payment.getStatus()) || "Completed".equals(payment.getStatus()) || "Failed".equals(payment.getStatus())) { %>
                <form action="<%= request.getContextPath() %>/tour-payment-manager-payments" method="post">
                    <input type="hidden" name="action" value="delete">
                    <input type="hidden" name="paymentId" value="<%= payment.getPaymentId() %>">
                    <button type="submit" class="btn btn-delete"
                            onclick="return confirm('Are you sure you want to delete this payment record?')">
                        Delete
                    </button>
                </form>
                <% } %>
            </div>
        </div>
        <% }
        } else { %>
        <p>No payments found.</p>
        <% } %>
    </div>

    <div class="back-link">
        <a href="<%= request.getContextPath() %>/tour-payment-manager-dashboard" class="btn-back">
            ← Back to Dashboard
        </a>
    </div>
</div>

<jsp:include page="/views/common/footer.jsp"/>
</body>
</html>
