<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.travel.model.ReportIssue" %>
<%@ page import="java.util.List" %>
<%@ include file="../../common/header-support-officer.jsp" %>
<head>
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/Support-Officer/issue-list.css">
</head>

<div class="issues-container">
    <h2>All Reported Issues</h2>

    <% if (request.getParameter("success") != null) { %>
    <div class="success-message"><%= request.getParameter("success") %></div>
    <% } %>
    <% if (request.getParameter("error") != null) { %>
    <div class="error-message"><%= request.getParameter("error") %></div>
    <% } %>

    <div class="issues-grid">
        <%
            List<ReportIssue> issues = (List<ReportIssue>) request.getAttribute("issues");
            if (issues != null && !issues.isEmpty()) {
                for (ReportIssue issue : issues) {
        %>
        <div class="issue-card">
            <div class="issue-header">
                <h3>Report #<%= issue.getReportId() %></h3>
                <span class="customer-id">Customer ID: <%= issue.getCustomerId() %></span>
            </div>
            <div class="issue-body">
                <p><strong>Issue Details:</strong>
                    <%= issue.getIssueDetails().length() > 120
                            ? issue.getIssueDetails().substring(0, 120) + "..."
                            : issue.getIssueDetails() %>
                </p>
                <p><strong>Reported On:</strong> <%= issue.getReportDate() %></p>
            </div>
            <div class="issue-actions">
                <a href="<%= request.getContextPath() %>/tour-support-officer-panel?action=reply-issue&id=<%= issue.getReportId() %>" class="btn-reply">Reply</a>
                <a href="<%= request.getContextPath() %>/tour-support-officer-panel?action=update-status&id=<%= issue.getReportId() %>" class="btn-update">Update Status</a>
            </div>
        </div>
        <%
            }
        } else {
        %>
        <p class="no-data">No issues found.</p>
        <%
            }
        %>
    </div>

    <div class="back-link">
        <a href="<%= request.getContextPath() %>/tour-support-dashboard" class="btn-back">← Back to Dashboard</a>
    </div>
</div>

<%@ include file="../../common/footer.jsp" %>
