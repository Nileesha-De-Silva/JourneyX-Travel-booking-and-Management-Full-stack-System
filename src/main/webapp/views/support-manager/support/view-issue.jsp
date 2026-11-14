<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.travel.model.ReportIssue" %>
<%@ page import="java.util.List" %>
<%@ include file="../../common/header-support-officer.jsp" %>

<html>
<head>
    <title>My Reported Issues</title>
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/Support-Officer/style.css">
</head>
<body>
<div class="container">
    <h2>My Reported Issues</h2>

    <% if (request.getParameter("success") != null) { %>
    <div class="success">Issue reported successfully!</div>
    <% } %>

    <%
        List<ReportIssue> issues = (List<ReportIssue>) request.getAttribute("issues");
        if (issues != null && !issues.isEmpty()) {
    %>
    <table>
        <tr>
            <th>Report ID</th>
            <th>Issue Details</th>
            <th>Report Date</th>
            <th>Status</th>
        </tr>
        <%
            for (ReportIssue issue : issues) {
        %>
        <tr>
            <td><%= issue.getReportId() %></td>
            <td><%= issue.getIssueDetails() %></td>
            <td><%= issue.getReportDate() %></td>
            <td>
                <% if (issue.getIssueDetails().contains("Status:")) { %>
                <%= issue.getIssueDetails().substring(issue.getIssueDetails().lastIndexOf("Status:") + 7) %>
                <% } else { %>
                Open
                <% } %>
            </td>
        </tr>
        <%
            }
        %>
    </table>
    <%
    } else {
    %>
    <p>No issues reported yet.</p>
    <%
        }
    %>

    <p>
        <a href="<%= request.getContextPath() %>/customer/support/report-issue">Report New Issue</a> |
        <a href="<%= request.getContextPath() %>/customer/dashboard">Back to Dashboard</a>
    </p>
</div>
</body>
</html>
