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
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Dashboard</title>
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/Customer/dashboard.css">
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/Customer/receipt.css">

</head>
<body>
<jsp:include page="/views/common/header-customer.jsp"/>

<div class="dashboard-container">
    <div class="dashboard-header">
        <h1>Welcome, <%= customer.getCustomerName() %>!</h1>
        <p>Here's what's happening with your travel account today.</p>
    </div>

    <h3>Quick Actions</h3>
    <div class="quick-actions">
        <div class="quick-action">
            <a href="<%= request.getContextPath() %>/tour-customer-packages/list">
                <img src="https://www.shutterstock.com/image-photo/tour-packages-concept-collage-travel-260nw-641820484.jpg" alt="Browse Packages" class="action-image">
                <div class="action-content">
                    <div class="action-icon">
                        <svg viewBox="0 0 24 24">
                            <path d="M14 2H6c-1.1 0-1.99.9-1.99 2L4 20c0 1.1.89 2 1.99 2H18c1.1 0 2-.9 2-2V8l-6-6zm2 16H8v-2h8v2zm0-4H8v-2h8v2zm-3-5V3.5L18.5 9H13z"/>
                        </svg>
                    </div>
                    <span class="action-text">Browse Packages</span>
                </div>
            </a>
        </div>
        <div class="quick-action">
            <a href="<%= request.getContextPath() %>/customer/bookings/create">
                <img src="https://media.istockphoto.com/id/1003402646/photo/travel-booking-hotels-and-flights-reservation-on-internet.jpg?s=612x612&w=0&k=20&c=BBkVfUD_LkN5QP9qPawTUJYHZ3oEMaGuS0gQ_j2L-_Q=" alt="Book a Package" class="action-image">
                <div class="action-content">
                    <div class="action-icon">
                        <svg viewBox="0 0 24 24">
                            <path d="M19 3h-1V1h-2v2H8V1H6v2H5c-1.11 0-1.99.9-1.99 2L3 19c0 1.1.89 2 1.99 2H18c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm0 16H5V8h14v11zM7 10h5v5H7z"/>
                        </svg>
                    </div>
                    <span class="action-text">Book a Package</span>
                </div>
            </a>
        </div>

        <div class="quick-action">
            <a href="<%= request.getContextPath() %>/customer/bookings/history">
                <img src="https://www.shutterstock.com/image-photo/managing-online-invoices-electronic-tax-260nw-2547165509.jpg" alt="View Receipts" class="action-image">
                <div class="action-content">
                    <div class="action-icon">
                        <svg viewBox="0 0 24 24">
                            <path d="M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm-5 14H7v-2h7v2zm3-4H7v-2h10v2zm0-4H7V7h10v2z"/>
                        </svg>
                    </div>
                    <span class="action-text">View Booking & Payment Receipts</span>
                </div>
            </a>
        </div>
        <div class="quick-action">
            <a href="<%= request.getContextPath() %>/customer/bookings/history">
                <img src="https://media.istockphoto.com/id/1092170968/vector/open-book-with-history-doodles-and-lettering.jpg?s=612x612&w=0&k=20&c=SvXn0O25eHC8ARjwlcn83kahxjMGl2ti_DDFGozBKqg=" alt="Booking History" class="action-image">
                <div class="action-content">
                    <div class="action-icon">
                        <svg viewBox="0 0 24 24">
                            <path d="M13 3c-4.97 0-9 4.03-9 9H1l3.89 3.89.07.14L9 12H6c0-3.87 3.13-7 7-7s7 3.13 7 7-3.13 7-7 7c-1.93 0-3.68-.79-4.94-2.06l-1.42 1.42C8.27 19.99 10.51 21 13 21c4.97 0 9-4.03 9-9s-4.03-9-9-9zm-1 5v5l4.28 2.54.72-1.21-3.5-2.08V8H12z"/>
                        </svg>
                    </div>
                    <span class="action-text">Booking History</span>
                </div>
            </a>
        </div>
        <div class="quick-action">
            <a href="<%= request.getContextPath() %>/customer/payments/history">
                <img src="https://media.istockphoto.com/id/1092170968/vector/open-book-with-history-doodles-and-lettering.jpg?s=612x612&w=0&k=20&c=SvXn0O25eHC8ARjwlcn83kahxjMGl2ti_DDFGozBKqg=" alt="Payment History" class="action-image">
                <div class="action-content">
                    <div class="action-icon">
                        <svg viewBox="0 0 24 24">
                            <path d="M20 4H4c-1.11 0-1.99.89-1.99 2L2 18c0 1.11.89 2 1.99 2H18c1.1 0 2-.9 2-2V6c0-1.11-.89-2-2-2zm0 14H4v-6h16v6zm0-10H4V6h16v2zm-10 7h8v2h-8z"/>
                        </svg>
                    </div>
                    <span class="action-text">Payment History</span>
                </div>
            </a>
        </div>
        <div class="quick-action">
            <a href="<%= request.getContextPath() %>/tour-customer-support?action=create">
                <img src="data:image/jpeg;base64,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" alt="Submit Feedback" class="action-image">
                <div class="action-content">
                    <div class="action-icon">
                        <svg viewBox="0 0 24 24">
                            <path d="M20 2H4c-1.1 0-1.99.9-1.99 2L2 22l4-4h14c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2zm-2 12H6v-2h12v2zm0-3H6V9h12v2zm0-3H6V6h12v2z"/>
                        </svg>
                    </div>
                    <span class="action-text">Submit Feedback</span>
                </div>
            </a>
        </div>
        <div class="quick-action">
            <a href="<%= request.getContextPath() %>/tour-customer-report-issue?action=report-issue">
                <img src="https://www.shutterstock.com/image-photo/businessman-holding-his-hands-over-600nw-1950410209.jpg" alt="Submit Complaints" class="action-image">
                <div class="action-content">
                    <div class="action-icon">
                        <svg viewBox="0 0 24 24">
                            <path d="M1 21h22L12 2 1 21zm12-3h-2v-2h2v2zm0-4h-2v-4h2v4z"/>
                        </svg>
                    </div>
                    <span class="action-text">Submit Complaints</span>
                </div>
            </a>
        </div>
    </div>

    <div class="account-section">
        <h3>Account Information</h3>
        <div class="account-info">
            <div class="account-info-item">
                <div class="account-info-label">Customer ID</div>
                <div class="account-info-value"><%= customer.getCustomerId() %></div>
            </div>
            <div class="account-info-item">
                <div class="account-info-label">Email</div>
                <div class="account-info-value"><%= customer.getEmail() %></div>
            </div>
            <div class="account-info-item">
                <div class="account-info-label">Phone</div>
                <div class="account-info-value"><%= customer.getContactNumber() %></div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/views/common/footer.jsp"/>
</body>
</html>