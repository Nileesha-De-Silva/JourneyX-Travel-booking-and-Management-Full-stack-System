<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.travel.model.PackageManager" %>
<%@ page import="com.travel.model.Package" %>
<%
  PackageManager manager = (PackageManager) session.getAttribute("user");
  if (manager == null) {
    response.sendRedirect(request.getContextPath() + "/tour-login");
    return;
  }

  Package pkg = (Package) request.getAttribute("package");
%>
<%@ include file="../../common/header-packagemanager.jsp" %>

<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/Package-Manager/add-package.css">

<div class="container">
  <h2 class="title">Edit Package</h2>

  <form action="<%= request.getContextPath() %>/tour-package-manager-packages" method="post" class="package-form" enctype="multipart/form-data">
    <input type="hidden" name="action" value="update">
    <input type="hidden" name="packageId" value="<%= pkg.getPackageId() %>">

    <div class="form-group">
      <label>Package Name:</label>
      <input type="text" name="packageName" value="<%= pkg.getPackageName() %>" required>
    </div>

    <div class="form-group">
      <label>Price:</label>
      <input type="number" name="price" step="0.01" value="<%= pkg.getPrice() %>" required>
    </div>

    <div class="form-group">
      <label>Start Date:</label>
      <input type="date" name="startDate" value="<%= pkg.getStartDate() %>" required>
    </div>

    <div class="form-group">
      <label>End Date:</label>
      <input type="date" name="endDate" value="<%= pkg.getEndDate() %>" required>
    </div>

    <div class="form-group">
      <label>Duration:</label>
      <input type="text" name="duration" value="<%= pkg.getDuration() %>" required>
    </div>

    <div class="form-group">
      <label>Destinations:</label>
      <textarea name="destinations" rows="3" required><%= pkg.getDestinations() %></textarea>
    </div>

    <div class="form-group">
      <label>Description:</label>
      <textarea name="description" rows="5" required><%= pkg.getDescription() %></textarea>
    </div>

    <div class="form-group">
      <label>Package Images:</label>
      <input type="file" name="packageImages" multiple accept="image/*">
      <p class="help-text">Select new images to replace existing ones</p>

      <div class="current-images">
        <h4>Current Images:</h4>
        <% if (pkg.getImages() != null && !pkg.getImages().isEmpty()) { %>
        <div class="image-preview">
          <% for (String image : pkg.getImages()) { %>
          <div class="image-item">
            <img src="<%= request.getContextPath() %>/<%= image %>" alt="Package Image">
          </div>
          <% } %>
        </div>
        <p><a href="<%= request.getContextPath() %>/tour-package-manager-packages?action=viewImages&id=<%= pkg.getPackageId() %>" class="btn-view">View All Images</a></p>
        <% } else { %>
        <p>No images uploaded yet.</p>
        <% } %>
      </div>
    </div>

    <div class="form-buttons">
      <button type="submit" class="btn submit">Update Package</button>
      <button type="reset" class="btn reset">Reset</button>
    </div>
  </form>

  <p class="back-link"><a href="<%= request.getContextPath() %>/tour-package-manager-packages?action=list">← Back to Package List</a></p>
</div>

<%@ include file="../../common/footer.jsp" %>