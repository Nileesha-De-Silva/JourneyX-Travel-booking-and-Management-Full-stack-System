<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.travel.model.SystemAdmin" %>

<%
    SystemAdmin admin = (SystemAdmin) request.getAttribute("admin");
    if (admin == null) {
        response.sendRedirect(request.getContextPath() + "/tour-login");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>System Admin Dashboard</title>
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/System-Admin/dashboard.css">

</head>
<body>
<%@ include file="../common/header-system-admin.jsp" %>

<div class="dashboard-container">
    <div class="dashboard-header">
        <h1>Welcome, <%= admin.getName() %>!</h1>
        <p>System Administration Dashboard - Manage all aspects of the travel platform</p>
    </div>



    <h3>System Overview</h3>
    <div class="quick-actions">
        <div class="quick-action">
            <a href="<%= request.getContextPath() %>/tour-system-admin-overview?action=bookings">
                <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQqGIZZrldkKPdGB18Zlfh70I8MJLuEHSbn4Q&s" alt="View Bookings" class="action-image">
                <div class="action-content">
                    <div class="action-icon">
                        <svg viewBox="0 0 24 24">
                            <path d="M19 3h-1V1h-2v2H8V1H6v2H5c-1.11 0-1.99.9-1.99 2L3 19c0 1.1.89 2 1.99 2H18c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm0 16H5V8h14v11zM7 10h5v5H7z"/>
                        </svg>
                    </div>
                    <span class="action-title">View Bookings</span>
                    <p class="action-description">Check all booking information and statistics</p>
                </div>
            </a>
        </div>
        <div class="quick-action">
            <a href="<%= request.getContextPath() %>/tour-system-admin-overview?action=feedback">
                <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS2cnH40ypSOtzB8lkmwhlcNEB7MITPOkhUxA&s" alt="View Feedback" class="action-image">
                <div class="action-content">
                    <div class="action-icon">
                        <svg viewBox="0 0 24 24">
                            <path d="M20 2H4c-1.1 0-1.99.9-1.99 2L2 22l4-4h14c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2zm-2 12H6v-2h12v2zm0-3H6V9h12v2zm0-3H6V6h12v2z"/>
                        </svg>
                    </div>
                    <span class="action-title">View Feedback</span>
                    <p class="action-description">Review customer feedback and ratings</p>
                </div>
            </a>
        </div>
    </div>

    <h3>User Management</h3>
    <div class="quick-actions">
        <div class="quick-action">
            <a href="<%= request.getContextPath() %>/tour-system-admin-users?action=customers">
                <img src="https://www.questionpro.com/blog/wp-content/uploads/2023/10/Customer-Management.jpg" alt="Manage Customers" class="action-image">
                <div class="action-content">
                    <div class="action-icon">
                        <svg viewBox="0 0 24 24">
                            <path d="M16 11c1.66 0 2.99-1.34 2.99-3S17.66 5 16 5c-1.66 0-3 1.34-3 3s1.34 3 3 3zm-8 0c1.66 0 2.99-1.34 2.99-3S9.66 5 8 5C6.34 5 5 6.34 5 8s1.34 3 3 3zm0 2c-2.33 0-7 1.17-7 3.5V19h14v-2.5c0-2.33-4.67-3.5-7-3.5zm8 0c-.29 0-.62.02-.97.05 1.16.84 1.97 1.97 1.97 3.45V19h6v-2.5c0-2.33-4.67-3.5-7-3.5z"/>
                        </svg>
                    </div>
                    <span class="action-title">Manage Customers</span>
                    <p class="action-description">Add, edit, or remove customer accounts</p>
                </div>
            </a>
        </div>
        <div class="quick-action">
            <a href="<%= request.getContextPath() %>/tour-system-admin-users?action=package-managers">
                <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR4UEE4zXM0pwbWYxZsBcxllDB0XtAJ76EoTg&s" alt="Manage Package Managers" class="action-image">
                <div class="action-content">
                    <div class="action-icon">
                        <svg viewBox="0 0 24 24">
                            <path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"/>
                        </svg>
                    </div>
                    <span class="action-title">Manage Package Managers</span>
                    <p class="action-description">Manage package manager accounts</p>
                </div>
            </a>
        </div>
        <div class="quick-action">
            <a href="<%= request.getContextPath() %>/tour-system-admin-users?action=booking-managers">
                <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSgNtGmkWB9msg-Ia2eYshRqJYGhLtFpepYfg&s" alt="Manage Booking Managers" class="action-image">
                <div class="action-content">
                    <div class="action-icon">
                        <svg viewBox="0 0 24 24">
                            <path d="M19 3h-4.18C14.4 1.84 13.3 1 12 1c-1.3 0-2.4.84-2.82 2H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm-7 0c.55 0 1 .45 1 1s-.45 1-1 1-1-.45-1-1 .45-1 1-1zm2 14H7v-2h7v2zm3-4H7v-2h10v2zm0-4H7V7h10v2z"/>
                        </svg>
                    </div>
                    <span class="action-title">Manage Booking Managers</span>
                    <p class="action-description">Manage booking manager accounts</p>
                </div>
            </a>
        </div>
        <div class="quick-action">
            <a href="<%= request.getContextPath() %>/tour-system-admin-users?action=payment-managers">
                <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSVXl8mRa7YB0p25wPdhncp1_ABN9-U_n8X6g&s" alt="Manage Payment Managers" class="action-image">
                <div class="action-content">
                    <div class="action-icon">
                        <svg viewBox="0 0 24 24">
                            <path d="M20 4H4c-1.11 0-1.99.89-1.99 2L2 18c0 1.11.89 2 1.99 2H18c1.1 0 2-.89 2-2V8h2V6c0-1.1-.9-2-2-2zm-5 14H4v-6h11v6zm0-7H4V6h11v5zm5 7h-2v-4h2v4zm0-5h-2V9h2v4z"/>
                        </svg>
                    </div>
                    <span class="action-title">Manage Payment Managers</span>
                    <p class="action-description">Manage payment manager accounts</p>
                </div>
            </a>
        </div>
        <div class="quick-action">
            <a href="<%= request.getContextPath() %>/tour-system-admin-users?action=support-officers">
                <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTd0k0okc2lx5fYXAcj3uBCCc_cmySIA4GbmA&s" alt="Manage Support Officers" class="action-image">
                <div class="action-content">
                    <div class="action-icon">
                        <svg viewBox="0 0 24 24">
                            <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z"/>
                        </svg>
                    </div>
                    <span class="action-title">Manage Support Officers</span>
                    <p class="action-description">Manage customer support officer accounts</p>
                </div>
            </a>
        </div>
        <div class="quick-action">
            <a href="<%= request.getContextPath() %>/tour-system-admin-users?action=system-admins">
                <img src="https://softengine.com/wp-content/uploads/2023/08/unnamed-2023-08-08T043332.629-1024x422.png" alt="Manage System Admins" class="action-image">
                <div class="action-content">
                    <div class="action-icon">
                        <svg viewBox="0 0 24 24">
                            <path d="M12 1L3 5v6c0 5.55 3.84 10.74 9 12 5.16-1.26 9-6.45 9-12V5l-9-4zm0 10.99h7c-.53 4.12-3.28 7.79-7 8.94V12H5V6.3l7-3.11v8.8z"/>
                        </svg>
                    </div>
                    <span class="action-title">Manage System Admins</span>
                    <p class="action-description">Manage system administrator accounts</p>
                </div>
            </a>
        </div>
    </div>

    <h3>System Configuration</h3>
    <div class="quick-actions">
        <div class="quick-action">
            <a href="<%= request.getContextPath() %>/tour-system-admin-configuration?action=system-messages">
                <img src="https://picsum.photos/seed/system-messages/600/400.jpg" alt="Edit System Messages" class="action-image">
                <div class="action-content">
                    <div class="action-icon">
                        <svg viewBox="0 0 24 24">
                            <path d="M20 2H4c-1.1 0-1.99.9-1.99 2L2 22l4-4h14c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2zm-2 12H6v-2h12v2zm0-3H6V9h12v2zm0-3H6V6h12v2z"/>
                        </svg>
                    </div>
                    <span class="action-title">Edit System Messages</span>
                    <p class="action-description">Update system notifications and messages</p>
                </div>
            </a>
        </div>
        <div class="quick-action">
            <a href="<%= request.getContextPath() %>/tour-system-admin-configuration?action=access-control">
                <img src="https://picsum.photos/seed/access-control/600/400.jpg" alt="Control System Access" class="action-image">
                <div class="action-content">
                    <div class="action-icon">
                        <svg viewBox="0 0 24 24">
                            <path d="M18 8h-1V6c0-2.76-2.24-5-5-5S7 3.24 7 6v2H6c-1.1 0-2 .9-2 2v10c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2V10c0-1.1-.9-2-2-2zm-6 9c-1.1 0-2-.9-2-2s.9-2 2-2 2 .9 2 2-.9 2-2 2zm3.1-9H8.9V6c0-1.71 1.39-3.1 3.1-3.1 1.71 0 3.1 1.39 3.1 3.1v2z"/>
                        </svg>
                    </div>
                    <span class="action-title">Control System Access</span>
                    <p class="action-description">Manage system access permissions</p>
                </div>
            </a>
        </div>
        <div class="quick-action">
            <a href="<%= request.getContextPath() %>/tour-system-admin-configuration?action=role-assignment">
                <img src="https://picsum.photos/seed/role-assignment/600/400.jpg" alt="Assign Roles" class="action-image">
                <div class="action-content">
                    <div class="action-icon">
                        <svg viewBox="0 0 24 24">
                            <path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"/>
                        </svg>
                    </div>
                    <span class="action-title">Assign Roles</span>
                    <p class="action-description">Assign roles and permissions to users</p>
                </div>
            </a>
        </div>
    </div>
</div>

<%@ include file="../common/footer.jsp" %>
</body>
</html>