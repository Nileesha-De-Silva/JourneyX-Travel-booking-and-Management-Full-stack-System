<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Register - Tour Package Booking System</title>
    <% out.println("<!-- Context Path: " + request.getContextPath() + " -->"); %>
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/main.css">
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/auth/register.css">
</head>
<body>
<div class="minimal-container">
    <header>
        <h1>JOURNEY X</h1>
        <h2>Customer Registration</h2>
    </header>

    <div class="register-form">
        <% if (request.getAttribute("errorMessage") != null) { %>
        <div class="message error"><%= request.getAttribute("errorMessage") %></div>
        <% } %>

        <form action="<%= request.getContextPath() %>/tour-register" method="post">
            <div class="form-row">
                <div class="form-group">
                    <label for="firstName">First Name</label>
                    <input type="text" id="firstName" name="firstName" required>
                </div>
                <div class="form-group">
                    <label for="lastName">Last Name</label>
                    <input type="text" id="lastName" name="lastName" required>
                </div>
            </div>

            <div class="form-group">
                <label for="customerName">Customer Name</label>
                <input type="text" id="customerName" name="customerName" required>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="nicNumber">NIC Number</label>
                    <input type="text" id="nicNumber" name="nicNumber" required>
                </div>
                <div class="form-group">
                    <label for="gender">Gender</label>
                    <select id="gender" name="gender" required>
                        <option value="">-- Select Gender --</option>
                        <option value="Male">Male</option>
                        <option value="Female">Female</option>
                        <option value="Other">Other</option>
                    </select>
                </div>
            </div>

            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" required>
            </div>

            <div class="form-group">
                <label for="address">Address</label>
                <input type="text" id="address" name="address" required>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="email">Email</label>
                    <input type="email" id="email" name="email" required>
                </div>
                <div class="form-group">
                    <label for="phoneNumber">Phone Number</label>
                    <input type="text" id="phoneNumber" name="phoneNumber" maxlength="10" required>
                </div>
            </div>

            <div class="form-actions">
                <button type="submit" class="btn btn-primary">Register</button>
            </div>
        </form>

        <p class="login-prompt">Already have an account? <a href="<%= request.getContextPath() %>/tour-login">Login here</a></p>
    </div>
</div>

<footer>
    <div class="container">
        <p> 2023 Tour Package Booking System. All rights reserved.</p>
    </div>
</footer>
</body>
</html>