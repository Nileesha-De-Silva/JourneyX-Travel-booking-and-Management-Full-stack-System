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

    Package pkg = (Package) request.getAttribute("package");
%>
<%@ include file="../../common/header-packagemanager.jsp" %>

<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/Package-Manager/list.css">
<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/main.css">
<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/Package-Manager/view-images.css">
<div class="container">
    <h2 class="title">Images for Package: <%= pkg.getPackageName() %></h2>

    <div class="image-gallery">
        <% if (pkg.getImages() != null && !pkg.getImages().isEmpty()) {
            for (String image : pkg.getImages()) { %>
        <div class="image-item">
            <img src="<%= request.getContextPath() %>/<%= image %>" alt="Package Image">
        </div>
        <% }
        } else { %>
        <p>No images found for this package.</p>
        <% } %>
    </div>

    <div class="action-buttons">
        <a href="<%= request.getContextPath() %>/tour-package-manager-packages?action=edit&id=<%= pkg.getPackageId() %>" class="btn-edit">Edit Package</a>
        <a href="<%= request.getContextPath() %>/tour-package-manager-packages?action=list" class="btn-back">Back to Package List</a>
    </div>
</div>

<%@ include file="../../common/footer.jsp" %>