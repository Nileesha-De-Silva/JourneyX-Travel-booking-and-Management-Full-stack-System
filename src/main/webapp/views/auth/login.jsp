<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login - JOURNEY X</title>
    <% out.println("<!-- Context Path: " + request.getContextPath() + " -->"); %>
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/main.css">
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/auth/login.css">
</head>
<body>
<div class="login-container">
    <header class="login-header">
        <h1>JOURNEY X</h1>
    </header>

    <div class="card login-card">
        <div class="card-body">
            <h2 class="card-title">Login</h2>

            <%-- Display error message if login failed --%>
            <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="alert alert-danger"><%= request.getAttribute("errorMessage") %></div>
            <% } %>

            <%-- Display success message if registration was successful --%>
            <% if (request.getParameter("registered") != null) { %>
            <div class="alert alert-success">Registration successful! Please login with your Details.</div>
            <% } %>

            <form action="<%= request.getContextPath() %>/tour-login" method="post">
                <div class="form-group">
                    <label for="email" class="form-label">Email:</label>
                    <input type="email" class="form-control" id="email" name="email" value="<%= request.getAttribute("email") != null ? request.getAttribute("email") : "" %>" required>
                </div>
                <div class="form-group">
                    <label for="password" class="form-label">Password:</label>
                    <input type="password" class="form-control" id="password" name="password" required>
                </div>
                <div class="form-group">
                    <label for="userType" class="form-label">User Type:</label>
                    <select class="form-control" id="userType" name="userType" required>
                        <option value="">-- Select User Type --</option>
                        <option value="customer" <%= request.getAttribute("userType") != null && "customer".equals(request.getAttribute("userType")) ? "selected" : "" %>>Customer</option>
                        <option value="packageManager" <%= request.getAttribute("userType") != null && "packageManager".equals(request.getAttribute("userType")) ? "selected" : "" %>>Package Manager</option>
                        <option value="bookingManager" <%= request.getAttribute("userType") != null && "bookingManager".equals(request.getAttribute("userType")) ? "selected" : "" %>>Booking Manager</option>
                        <option value="paymentManager" <%= request.getAttribute("userType") != null && "paymentManager".equals(request.getAttribute("userType")) ? "selected" : "" %>>Payment Manager</option>
                        <option value="supportOfficer" <%= request.getAttribute("userType") != null && "supportOfficer".equals(request.getAttribute("userType")) ? "selected" : "" %>>Customer Support Officer</option>
                        <option value="systemAdmin" <%= request.getAttribute("userType") != null && "systemAdmin".equals(request.getAttribute("userType")) ? "selected" : "" %>>System Administrator</option>
                    </select>
                </div>
                <div class="form-group">
                    <button type="submit" class="btn btn-primary btn-login">Login</button>
                    <button type="reset" class="btn btn-secondary">Reset</button>
                </div>
            </form>

            <p class="register-link">Don't have an account? <a href="<%= request.getContextPath() %>/tour-register">Register here</a></p>
        </div>
    </div>
</div>

<footer>
    <div class="container">
        <p> 2025 Tour Package Booking System. All rights reserved.</p>
    </div>
</footer>
</body>
</html>