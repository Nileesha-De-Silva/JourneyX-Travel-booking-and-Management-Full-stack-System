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
<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/Package-Manager/remove-package.css">

<h2>Remove Package</h2>
<p>Are you sure you want to remove the following package?</p>

<div class="package-card remove-card">
    <div class="package-header">
        <h3><%= pkg.getPackageName() %></h3>
        <span class="price">$<%= pkg.getPrice() %></span>
    </div>
    <div class="package-details">
        <p><strong>Package ID:</strong> <%= pkg.getPackageId() %></p>
        <p><strong>Duration:</strong> <%= pkg.getDuration() %></p>
    </div>
    <div class="package-actions">
        <form action="<%= request.getContextPath() %>/tour-package-manager-packages" method="post" style="display:inline;">
            <input type="hidden" name="action" value="delete">
            <input type="hidden" name="packageId" value="<%= pkg.getPackageId() %>">
            <button type="submit" class="btn-remove">Yes, Remove</button>
        </form>
        <a href="<%= request.getContextPath() %>/tour-package-manager-packages?action=list" class="btn-cancel">Cancel</a>
    </div>
</div>

<%@ include file="../../common/footer.jsp" %>
