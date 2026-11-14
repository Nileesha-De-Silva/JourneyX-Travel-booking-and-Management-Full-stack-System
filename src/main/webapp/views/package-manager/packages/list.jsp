<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.travel.model.PackageManager" %>
<%@ page import="com.travel.model.Package" %>
<%@ page import="java.util.List" %>
<%
  PackageManager manager = (PackageManager) session.getAttribute("user");
  if (manager == null) {
    response.sendRedirect(request.getContextPath() + "/tour-login");
    return;
  }
  List<Package> packages = (List<Package>) request.getAttribute("packages");
%>
<%@ include file="../../common/header-packagemanager.jsp" %>
<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/Package-Manager/list.css">
<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/main.css">
<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/Package-Manager/view-images.css">

<h2>Package List</h2>

<% if (request.getParameter("success") != null) { %>
<% if ("1".equals(request.getParameter("success"))) { %>
<div class="success">Package added successfully!</div>
<% } else if ("2".equals(request.getParameter("success"))) { %>
<div class="success">Package updated successfully!</div>
<% } else if ("3".equals(request.getParameter("success"))) { %>
<div class="success">Package deleted successfully!</div>
<% } %>
<% } %>

<% if (request.getParameter("error") != null) { %>
<div class="error">Operation failed. Please try again.</div>
<% } %>

<p><a href="<%= request.getContextPath() %>/tour-package-manager-packages?action=add" class="btn-add">Add New Package</a></p>

<div class="package-cards">
  <% if (packages != null && !packages.isEmpty()) {
    for (Package pkg : packages) { %>
  <div class="package-card">
    <div class="package-header">
      <h3><%= pkg.getPackageName() %></h3>
      <span class="price">$<%= pkg.getPrice() %></span>
    </div>

    <% if (pkg.getImages() != null && !pkg.getImages().isEmpty()) { %>
    <div class="package-image">
      <img src="<%= request.getContextPath() %>/<%= pkg.getImages().get(0) %>" alt="Package Image">
    </div>
    <% } %>

    <div class="package-details">
      <p><strong>Duration:</strong> <%= pkg.getDuration() %></p>
      <p><strong>Start:</strong> <%= pkg.getStartDate() %> | <strong>End:</strong> <%= pkg.getEndDate() %></p>
      <p><strong>Destinations:</strong> <%= pkg.getDestinations() %></p>
    </div>
    <div class="package-actions">
      <a href="<%= request.getContextPath() %>/tour-package-manager-packages?action=edit&id=<%= pkg.getPackageId() %>" class="btn-edit">Edit</a>
      <a href="<%= request.getContextPath() %>/tour-package-manager-packages?action=remove&id=<%= pkg.getPackageId() %>" class="btn-remove">Remove</a>
      <% if (pkg.getImages() != null && !pkg.getImages().isEmpty()) { %>
      <a href="<%= request.getContextPath() %>/tour-package-manager-packages?action=viewImages&id=<%= pkg.getPackageId() %>" class="btn-view">View Photos</a>
      <% } %>
    </div>
  </div>
  <% } } else { %>
  <p>No packages found.</p>
  <% } %>
</div>

<%@ include file="../../common/footer.jsp" %>