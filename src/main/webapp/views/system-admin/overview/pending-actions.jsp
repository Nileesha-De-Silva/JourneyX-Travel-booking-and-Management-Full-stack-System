<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.travel.model.SystemAdmin" %>
<%
    SystemAdmin admin = (SystemAdmin) request.getAttribute("admin");
    if (admin == null) {
        response.sendRedirect(request.getContextPath() + "/tour-login");
        return;
    }
%>
<%@ include file="../../common/header-system-admin.jsp" %>
<head>
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/System-Admin/pending-actions.css">
</head>
<h2>View Pending Actions</h2>

<h3>Pending Actions Overview</h3>
<table>
</table>

<h3>Recent Pending Actions</h3>
<table>
    <tr>
        <th>Action ID</th>
        <th>Type</th>
        <th>Details</th>
        <th>Date</th>
        <th>Assigned To</th>
    </tr>
</table>

<%@ include file="../../common/footer.jsp" %>