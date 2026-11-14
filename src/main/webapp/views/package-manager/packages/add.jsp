<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.travel.model.PackageManager" %>
<%
    PackageManager manager = (PackageManager) session.getAttribute("user");
    if (manager == null) {
        response.sendRedirect(request.getContextPath() + "/tour-login");
        return;
    }
%>
<%@ include file="../../common/header-packagemanager.jsp" %>
<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/Package-Manager/add-package.css">

<div class="container">
    <h2 class="title">Add New Package</h2>

    <% if (request.getParameter("error") != null) { %>
    <div class="alert error">Failed to add package. Please try again.</div>
    <% } %>

    <form action="<%= request.getContextPath() %>/tour-package-manager-packages" method="post" class="package-form" enctype="multipart/form-data">
        <input type="hidden" name="action" value="add">

        <div class="form-group">
            <label>Package Name:</label>
            <input type="text" name="packageName" placeholder="Enter package name" required>
        </div>

        <div class="form-group">
            <label>Price:</label>
            <input type="number" name="price" placeholder="Enter price" step="0.01" required>
        </div>

        <div class="form-group">
            <label>Start Date:</label>
            <input type="date" name="startDate" required>
        </div>

        <div class="form-group">
            <label>End Date:</label>
            <input type="date" name="endDate" required>
        </div>

        <div class="form-group">
            <label>Duration:</label>
            <input type="text" name="duration" placeholder="e.g., 5 days 4 nights" required>
        </div>

        <div class="form-group">
            <label>Destinations:</label>
            <textarea name="destinations" rows="3" placeholder="Enter destinations" required></textarea>
        </div>

        <div class="form-group">
            <label>Description:</label>
            <textarea name="description" rows="5" placeholder="Write package description" required></textarea>
        </div>

        <div class="form-group">
            <label>Package Images:</label>
            <input type="file" name="packageImages" multiple accept="image/*">
            <p class="help-text">You can select multiple images</p>
        </div>

        <div class="form-buttons">
            <button type="submit" class="btn submit">Add Package</button>
            <button type="reset" class="btn reset">Reset</button>
        </div>
    </form>

    <p class="back-link"><a href="<%= request.getContextPath() %>/tour-package-manager-packages?action=list">← Back to Package List</a></p>
</div>

<%@ include file="../../common/footer.jsp" %>