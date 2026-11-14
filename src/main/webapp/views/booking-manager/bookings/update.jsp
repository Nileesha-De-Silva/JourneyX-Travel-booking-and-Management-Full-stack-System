<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.travel.model.BookingManager" %>
<%@ page import="com.travel.model.Booking" %>
<%@ page import="com.travel.service.BookingService" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    BookingManager manager = (BookingManager) session.getAttribute("user");
    if (manager == null) {
        response.sendRedirect(request.getContextPath() + "/tour-login");
        return;
    }

    Booking booking = (Booking) request.getAttribute("booking");
    if (booking == null) {
        response.sendRedirect(request.getContextPath() + "/tour-booking-manager-bookings?action=list&error=Booking not found");
        return;
    }

    BookingService bookingService = new BookingService();
    boolean canModify = bookingService.canModifyBooking(booking.getBookingId());

    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    String formattedDate = sdf.format(booking.getBookingDate());
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Update Booking - Booking Manager</title>
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/main.css">
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/Booking-Manager/update.css" id="pageStyle">
</head>
<body>
<div class="container">
    <jsp:include page="/views/common/header-bookingmanager.jsp"/>

    <div class="page-header">
        <h2>Update Booking Details</h2>
        <p class="back-link"><a href="<%= request.getContextPath() %>/tour-booking-manager-bookings?action=list"><i class="icon-arrow-left"></i> Back to Bookings List</a></p>
    </div>

    <%-- Display error message if exists --%>
    <% if (request.getParameter("error") != null) { %>
    <div class="alert alert-danger"><%= request.getParameter("error") %></div>
    <% } %>

    <div class="content-wrapper">
        <% if (canModify) { %>
        <div class="booking-card">
            <div class="card-header">
                <h3>Booking Information</h3>
                <span class="booking-id">ID: <%= booking.getBookingId() %></span>
            </div>
            <div class="card-body">
                <form action="<%= request.getContextPath() %>/tour-booking-manager-bookings" method="post">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="bookingId" value="<%= booking.getBookingId() %>">

                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">Customer ID</label>
                            <div class="form-value"><%= booking.getCustomerId() %></div>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Package ID</label>
                            <div class="form-value"><%= booking.getPackageId() %></div>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">Current Status</label>
                            <div class="status status-<%= booking.getConfirmationStatus().toLowerCase() %>">
                                <%= booking.getConfirmationStatus() %>
                            </div>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="bookingDate" class="form-label">Booking Date</label>
                            <input type="date" id="bookingDate" name="bookingDate" class="form-control" value="<%= formattedDate %>" required>
                        </div>
                        <div class="form-group">
                            <label for="numTravelers" class="form-label">Number of Travelers</label>
                            <input type="number" id="numTravelers" name="numTravelers" class="form-control" value="<%= booking.getNumTravelers() %>" min="1" max="20" required>
                        </div>
                    </div>

                    <div class="form-actions">
                        <button type="submit" class="btn btn-primary">Update Booking</button>
                        <button type="reset" class="btn btn-secondary">Reset</button>
                    </div>
                </form>
            </div>
        </div>

        <div class="actions-card">
            <div class="card-header">
                <h3>Additional Actions</h3>
            </div>
            <div class="card-body">
                <div class="action-buttons">
                    <% if ("Pending".equals(booking.getConfirmationStatus())) { %>
                    <form action="<%= request.getContextPath() %>/tour-booking-manager-bookings" method="post" class="inline-form">
                        <input type="hidden" name="action" value="confirm">
                        <input type="hidden" name="bookingId" value="<%= booking.getBookingId() %>">
                        <button type="submit" class="btn btn-success" onclick="return confirm('Are you sure you want to confirm this booking?');">Confirm Booking</button>
                    </form>
                    <% } %>

                    <% if (!"Cancelled".equals(booking.getConfirmationStatus())) { %>
                    <form action="<%= request.getContextPath() %>/tour-booking-manager-bookings" method="post" class="inline-form">
                        <input type="hidden" name="action" value="cancel">
                        <input type="hidden" name="bookingId" value="<%= booking.getBookingId() %>">
                        <button type="submit" class="btn btn-danger" onclick="return confirm('Are you sure you want to cancel this booking?');">Cancel Booking</button>
                    </form>
                    <% } %>
                </div>
            </div>
        </div>

        <% } else { %>
        <div class="alert alert-warning">
            <h3>Booking Cannot Be Modified</h3>
            <p>This booking cannot be modified because it has already been confirmed or cancelled.</p>
            <p>Only pending bookings can be modified.</p>
        </div>

        <div class="booking-card">
            <div class="card-header">
                <h3>Booking Details</h3>
                <span class="booking-id">ID: <%= booking.getBookingId() %></span>
            </div>
            <div class="card-body">
                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label">Customer ID</label>
                        <div class="form-value"><%= booking.getCustomerId() %></div>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Package ID</label>
                        <div class="form-value"><%= booking.getPackageId() %></div>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label">Booking Date</label>
                        <div class="form-value"><%= booking.getBookingDate() %></div>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Number of Travelers</label>
                        <div class="form-value"><%= booking.getNumTravelers() %></div>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label">Status</label>
                        <div class="status status-<%= booking.getConfirmationStatus().toLowerCase() %>">
                            <%= booking.getConfirmationStatus() %>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <% } %>
    </div>

    <jsp:include page="/views/common/footer.jsp"/>
</div>
</body>
</html>