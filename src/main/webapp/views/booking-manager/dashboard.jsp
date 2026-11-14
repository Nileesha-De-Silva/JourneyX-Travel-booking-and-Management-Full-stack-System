<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.travel.model.BookingManager" %>
<%@ page import="com.travel.service.BookingService" %>
<%@ page import="com.travel.service.ReceiptService" %>
<%@ page import="com.travel.model.Booking" %>
<%@ page import="java.util.List" %>

<%
    // Check if booking manager is logged in
    BookingManager manager = (BookingManager) session.getAttribute("user");
    if (manager == null) {
        response.sendRedirect(request.getContextPath() + "/tour-login");
        return;
    }

    // Get booking statistics
    BookingService bookingService = new BookingService();
    ReceiptService receiptService = new ReceiptService();
    int totalBookings = bookingService.getTotalBookings();
    int pendingBookings = bookingService.getPendingBookingsCount();
    int confirmedBookings = bookingService.getConfirmedBookingsCount();
    int cancelledBookings = bookingService.getCancelledBookingsCount();
    
    // Calculate receipt statistics
    int totalReceipts = 0;
    int sentReceipts = 0;
    int pendingReceipts = 0;
    
    // Debug: Get all receipts
    java.util.List<com.travel.model.Receipt> allReceipts = receiptService.getAllReceipts();
    System.out.println("Total receipts in system: " + allReceipts.size());
    
    // Debug: Show receipt content for first receipt if exists
    if (!allReceipts.isEmpty()) {
        com.travel.model.Receipt firstReceipt = allReceipts.get(0);
        System.out.println("Sample Receipt Content:");
        System.out.println("========================");
        System.out.println(firstReceipt.getContent());
        System.out.println("========================");
    }
    
    for (com.travel.model.Receipt receipt : allReceipts) {
        totalReceipts++;
        if (receipt.isSent()) {
            sentReceipts++;
        } else {
            pendingReceipts++;
        }
    }

    // Get recent bookings from request attribute set by servlet
    List<Booking> recentBookings = (List<Booking>) request.getAttribute("recentBookings");
    if (recentBookings == null) {
        recentBookings = bookingService.getAllBookings();
    }

    // Get pending bookings specifically
    List<Booking> pendingBookingsList = bookingService.getBookingsByStatus("Pending");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Booking Manager Dashboard</title>
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/Payment-Manager/dashboard.css">

</head>
<body>
<jsp:include page="/views/common/header-bookingmanager.jsp"/>

<div class="dashboard-container">
    <div class="dashboard-header">
        <h1>Booking Manager Dashboard</h1>
        <p>Welcome, <%= manager.getName() %>! Manage all booking operations efficiently.</p>
    </div>

    <h3>Booking Statistics</h3>
    <div class="stats-container">
        <div class="stat-card total">
            <div class="stat-icon">
                <svg viewBox="0 0 24 24">
                    <path d="M19 3h-4.18C14.4 1.84 13.3 1 12 1c-1.3 0-2.4.84-2.82 2H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm-7 0c.55 0 1 .45 1 1s-.45 1-1 1-1-.45-1-1 .45-1 1-1zm2 14H7v-2h7v2zm3-4H7v-2h10v2zm0-4H7V7h10v2z"/>
                </svg>
            </div>
            <div class="stat-value"><%= totalBookings %></div>
            <div class="stat-label">Total Bookings</div>
        </div>
        <div class="stat-card pending">
            <div class="stat-icon">
                <svg viewBox="0 0 24 24">
                    <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z"/>
                </svg>
            </div>
            <div class="stat-value"><%= pendingBookings %></div>
            <div class="stat-label">Pending Bookings</div>
        </div>
        <div class="stat-card confirmed">
            <div class="stat-icon">
                <svg viewBox="0 0 24 24">
                    <path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/>
                </svg>
            </div>
            <div class="stat-value"><%= confirmedBookings %></div>
            <div class="stat-label">Confirmed Bookings</div>
        </div>
        <div class="stat-card cancelled">
            <div class="stat-icon">
                <svg viewBox="0 0 24 24">
                    <path d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z"/>
                </svg>
            </div>
            <div class="stat-value"><%= cancelledBookings %></div>
            <div class="stat-label">Cancelled Bookings</div>
        </div>
        <div class="stat-card receipts">
            <div class="stat-icon">
                <svg viewBox="0 0 24 24">
                    <path d="M14,2H6A2,2 0 0,0 4,4V20A2,2 0 0,0 6,22H18A2,2 0 0,0 20,20V8L14,2M18,20H6V4H13V9H18V20Z"/>
                </svg>
            </div>
            <div class="stat-value"><%= totalReceipts %></div>
            <div class="stat-label">Total Receipts</div>
        </div>
        <div class="stat-card sent-receipts">
            <div class="stat-icon">
                <svg viewBox="0 0 24 24">
                    <path d="M2,3H22A2,2 0 0,1 24,5V19A2,2 0 0,1 22,21H2A2,2 0 0,1 0,19V5A2,2 0 0,1 2,3M2,5V19H22V5H2M4,7H20V9H4V7M4,11H20V13H4V11M4,15H20V17H4V15Z"/>
                </svg>
            </div>
            <div class="stat-value"><%= sentReceipts %></div>
            <div class="stat-label">Sent Receipts</div>
        </div>
        <div class="stat-card pending-receipts">
            <div class="stat-icon">
                <svg viewBox="0 0 24 24">
                    <path d="M12,2A10,10 0 0,0 2,12A10,10 0 0,0 12,22A10,10 0 0,0 22,12A10,10 0 0,0 12,2M12,4A8,8 0 0,1 20,12A8,8 0 0,1 12,20A8,8 0 0,1 4,12A8,8 0 0,1 12,4M12,6A6,6 0 0,0 6,12A6,6 0 0,0 12,18A6,6 0 0,0 18,12A6,6 0 0,0 12,6M12,8A4,4 0 0,1 16,12A4,4 0 0,1 12,16A4,4 0 0,1 8,12A4,4 0 0,1 12,8Z"/>
                </svg>
            </div>
            <div class="stat-value"><%= pendingReceipts %></div>
            <div class="stat-label">Pending Receipts</div>
        </div>
    </div>

    <h3>Quick Actions</h3>
    <div class="quick-actions">
        <div class="quick-action">
            <a href="<%= request.getContextPath() %>/booking-manager/list?action=list">
                <img src="https://img.freepik.com/free-photo/air-ticket-flight-booking-concept_53876-132674.jpg" alt="View All Bookings" class="action-image">
                <div class="action-content">
                    <div class="action-icon">
                        <svg viewBox="0 0 24 24">
                            <path d="M19 3h-4.18C14.4 1.84 13.3 1 12 1c-1.3 0-2.4.84-2.82 2H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm-7 0c.55 0 1 .45 1 1s-.45 1-1 1-1-.45-1-1 .45-1 1-1zm2 14H7v-2h7v2zm3-4H7v-2h10v2zm0-4H7V7h10v2z"/>
                        </svg>
                    </div>
                    <span class="action-title">View All Bookings</span>
                    <p class="action-description">View and manage all customer bookings</p>
                </div>
            </a>
        </div>
        <div class="quick-action">
            <a href="<%= request.getContextPath() %>/booking-manager/list?action=view-pending">
                <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRmR41Encp-2dBw-uSCBiY7EUMtOYFdHx-H9A&s" alt="View Pending Bookings" class="action-image">
                <div class="action-content">
                    <div class="action-icon">
                        <svg viewBox="0 0 24 24">
                            <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z"/>
                        </svg>
                    </div>
                    <span class="action-title">View Pending Bookings</span>
                    <p class="action-description">Review and confirm pending bookings</p>
                </div>
            </a>
        </div>
        <div class="quick-action">
            <a href="<%= request.getContextPath() %>/booking-manager/list?action=view-confirmed">
                <img src="https://png.pngtree.com/png-vector/20210804/ourmid/pngtree-confirmed-icon-png-image_3777663.jpg" alt="View Confirmed Bookings" class="action-image">
                <div class="action-content">
                    <div class="action-icon">
                        <svg viewBox="0 0 24 24">
                            <path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/>
                        </svg>
                    </div>
                    <span class="action-title">View Confirmed Bookings</span>
                    <p class="action-description">View all confirmed bookings</p>
                </div>
            </a>
        </div>
        <div class="quick-action">
            <a href="<%= request.getContextPath() %>/booking-manager/list?action=view-cancelled">
                <img src="https://img.freepik.com/free-photo/blocked-unavailable-decline-accesibility-closed_53876-133630.jpg?semt=ais_hybrid&w=740&q=80" alt="View Cancelled Bookings" class="action-image">
                <div class="action-content">
                    <div class="action-icon">
                        <svg viewBox="0 0 24 24">
                            <path d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z"/>
                        </svg>
                    </div>
                    <span class="action-title">View Cancelled Bookings</span>
                    <p class="action-description">View all cancelled bookings</p>
                </div>
            </a>
        </div>
        <div class="quick-action">
            <a href="<%= request.getContextPath() %>/booking-manager/list?action=view-confirmed">
                <img src="https://www.shutterstock.com/image-photo/einvoice-digital-billing-concept-businessman-260nw-2584259335.jpg" alt="Receipt Management" class="action-image">
                <div class="action-content">
                    <div class="action-icon">
                        <svg viewBox="0 0 24 24">
                            <path d="M14,2H6A2,2 0 0,0 4,4V20A2,2 0 0,0 6,22H18A2,2 0 0,0 20,20V8L14,2M18,20H6V4H13V9H18V20Z"/>
                        </svg>
                    </div>
                    <span class="action-title">Receipt Management</span>
                    <p class="action-description">Create and send receipts for confirmed bookings</p>
                </div>
            </a>
        </div>
    </div>

    <!-- Debug Section -->
    <div class="debug-section" style="background: #f8f9fa; padding: 20px; margin: 20px 0; border-radius: 8px; border: 1px solid #dee2e6;">
        <h3>Debug: Receipt Information</h3>
        <p><strong>Total Receipts in System:</strong> <%= allReceipts.size() %></p>
        <% if (!allReceipts.isEmpty()) { %>
        <table style="width: 100%; border-collapse: collapse; margin-top: 10px;">
            <tr style="background: #e9ecef;">
                <th style="padding: 8px; border: 1px solid #dee2e6;">Receipt ID</th>
                <th style="padding: 8px; border: 1px solid #dee2e6;">Booking ID</th>
                <th style="padding: 8px; border: 1px solid #dee2e6;">Generated Date</th>
                <th style="padding: 8px; border: 1px solid #dee2e6;">Sent</th>
            </tr>
            <% for (com.travel.model.Receipt receipt : allReceipts) { %>
            <tr>
                <td style="padding: 8px; border: 1px solid #dee2e6;"><%= receipt.getReceiptId() %></td>
                <td style="padding: 8px; border: 1px solid #dee2e6;"><%= receipt.getBookingId() %></td>
                <td style="padding: 8px; border: 1px solid #dee2e6;"><%= receipt.getGeneratedDate() %></td>
                <td style="padding: 8px; border: 1px solid #dee2e6;"><%= receipt.isSent() ? "Yes" : "No" %></td>
            </tr>
            <% } %>
        </table>
        
        <!-- Sample Receipt Preview -->
        <div style="margin-top: 20px;">
            <h4>Sample Receipt Preview:</h4>
            <div style="background: #f8f9fa; padding: 15px; border-radius: 5px; border: 1px solid #dee2e6; max-height: 300px; overflow-y: auto;">
                <pre style="margin: 0; font-family: 'Courier New', monospace; font-size: 12px; white-space: pre-wrap;"><%= allReceipts.get(0).getContent() %></pre>
            </div>
        </div>
        <% } else { %>
        <p style="color: #6c757d; font-style: italic;">No receipts found in the system.</p>
        <% } %>
    </div>

    <div class="recent-bookings">
        <h3>Recent Pending Bookings</h3>
        <div class="table-responsive">
            <table>
                <tr>
                    <th>Booking ID</th>
                    <th>Customer ID</th>
                    <th>Package ID</th>
                    <th>Booking Date</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
                <%
                    if (pendingBookingsList != null && !pendingBookingsList.isEmpty()) {
                        // Show 5 most recent pending bookings
                        int maxBookings = Math.min(pendingBookingsList.size(), 5);
                        for (int i = 0; i < maxBookings; i++) {
                            Booking booking = pendingBookingsList.get(i);
                %>
                <tr>
                    <td><%= booking.getBookingId() %></td>
                    <td><%= booking.getCustomerId() %></td>
                    <td><%= booking.getPackageId() %></td>
                    <td><%= booking.getBookingDate() %></td>
                    <td>
                        <span class="status status-pending"><%= booking.getConfirmationStatus() %></span>
                    </td>
                    <td>
                        <form action="<%= request.getContextPath() %>/booking-manager/list" method="post" style="display: inline;">
                            <input type="hidden" name="action" value="confirm">
                            <input type="hidden" name="id" value="<%= booking.getBookingId() %>">
                            <input type="submit" value="Confirm" class="btn-confirm">
                        </form>
                        <form action="<%= request.getContextPath() %>/booking-manager/list" method="post" style="display: inline;">
                            <input type="hidden" name="action" value="cancel">
                            <input type="hidden" name="id" value="<%= booking.getBookingId() %>">
                            <input type="submit" value="Cancel" class="btn-cancel">
                        </form>
                    </td>
                </tr>
                <%
                    }
                } else {
                %>
                <tr>
                    <td colspan="6">No pending bookings found</td>
                </tr>
                <%
                    }
                %>
            </table>
        </div>

        <% if (pendingBookingsList != null && pendingBookingsList.size() > 5) { %>
        <a href="<%= request.getContextPath() %>/booking-manager/list?action=view-pending" class="view-all-link">View All Pending Bookings</a>
        <% } %>
    </div>

    <div class="account-info">
        <h3>Account Information</h3>
        <table>
            <tr>
                <td>Employee ID:</td>
                <td><%= manager.getEmployeeId() %></td>
            </tr>
            <tr>
                <td>Name:</td>
                <td><%= manager.getName() %></td>
            </tr>
            <tr>
                <td>Job Title:</td>
                <td><%= manager.getJobTitle() %></td>
            </tr>
            <tr>
                <td>Department:</td>
                <td><%= manager.getDepartment() %></td>
            </tr>
            <tr>
                <td>Email:</td>
                <td><%= manager.getEmail() %></td>
            </tr>
            <tr>
                <td>Contact Number:</td>
                <td><%= manager.getContactNumber() %></td>
            </tr>
        </table>
    </div>
</div>

<jsp:include page="/views/common/footer.jsp"/>
</body>
</html>