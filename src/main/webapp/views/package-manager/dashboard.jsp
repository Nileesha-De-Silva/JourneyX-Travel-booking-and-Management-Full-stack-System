<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.travel.model.PackageManager" %>
<%@ page import="com.travel.service.PackageService" %>
<%@ page import="java.util.List" %>
<%@ page import="com.travel.model.Package" %>

<%
    PackageManager manager = (PackageManager) session.getAttribute("user");
    if (manager == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }

    PackageService packageService = new PackageService();
    List<Package> packages = packageService.getAllPackages();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Package Manager Dashboard</title>
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/main.css">
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/Payment-Manager/dashboard.css">
</head>
<body>

<%@ include file="../common/header-packagemanager.jsp" %>

<div class="dashboard-container">
    <div class="dashboard-header">
        <h1>Welcome, <%= manager.getName() %>!</h1>
        <p>Package Management Dashboard - Create and manage tour packages</p>
    </div>

    <% if (request.getParameter("success") != null) { %>
    <div class="success">Package <%= request.getParameter("success").equals("1") ? "added" : "updated" %> successfully!</div>
    <% } %>

    <% if (request.getParameter("error") != null) { %>
    <div class="error">Operation failed. Please try again.</div>
    <% } %>

    <h3>Quick Actions</h3>
    <div class="quick-actions">
        <div class="quick-action">
            <a href="<%= request.getContextPath() %>/tour-package-manager-packages?action=add">
                <img src="https://www.shutterstock.com/image-photo/einvoice-digital-billing-concept-businessman-260nw-2584259335.jpg" alt="Add New Package" class="action-image">
                <div class="action-content">
                    <div class="action-icon">
                        <svg viewBox="0 0 24 24">
                            <path d="M19 13h-6v6h-2v-6H5v-2h6V5h2v6h6v2z"/>
                        </svg>
                    </div>
                    <span class="action-title">Add New Package</span>
                    <p class="action-description">Create a new tour package with destinations, pricing, and details</p>
                </div>
            </a>
        </div>
        <div class="quick-action">
            <a href="<%= request.getContextPath() %>/tour-package-manager-packages?action=view">
                <img src="https://marketplace.canva.com/EAGdevvOLr0/1/0/1131w/canva-blue-and-white-modern-tours-and-travels-agency-promotion-flyer-JGUUj6T38II.jpg" alt="View All Packages" class="action-image">
                <div class="action-content">
                    <div class="action-icon">
                        <svg viewBox="0 0 24 24">
                            <path d="M4 6H2v14c0 1.1.9 2 2 2h14v-2H4V6zm16-4H8c-1.1 0-2 .9-2 2v12c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2zm-1 9h-4v4h-2v-4H9V9h4V5h2v4h4v2z"/>
                        </svg>
                    </div>
                    <span class="action-title">View All Packages</span>
                    <p class="action-description">Browse and manage all existing tour packages</p>
                </div>
            </a>
        </div>
        <div class="quick-action">
            <a href="<%= request.getContextPath() %>/tour-package-manager-packages?action=edit">
                <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTENwEAwi4MLl7hbTmisOnukm4O-urvQJQeMA&s" alt="Edit Package" class="action-image">
                <div class="action-content">
                    <div class="action-icon">
                        <svg viewBox="0 0 24 24">
                            <path d="M3 17.25V21h3.75L17.81 9.94l-3.75-3.75L3 17.25zM20.71 7.04c.39-.39.39-1.02 0-1.41l-2.34-2.34c-.39-.39-1.02-.39-1.41 0l-1.83 1.83 3.75 3.75 1.83-1.83z"/>
                        </svg>
                    </div>
                    <span class="action-title">Edit Package</span>
                    <p class="action-description">Modify details of existing tour packages</p>
                </div>
            </a>
        </div>
        <div class="quick-action">
            <a href="<%= request.getContextPath() %>/tour-package-manager-packages?action=delete">
                <img src="https://media-cdn.tripadvisor.com/media/attractions-splice-spp-674x446/15/1f/da/4e.jpg" alt="Remove Package" class="action-image">
                <div class="action-content">
                    <div class="action-icon">
                        <svg viewBox="0 0 24 24">
                            <path d="M6 19c0 1.1.9 2 2 2h8c1.1 0 2-.9 2-2V7H6v12zM19 4h-3.5l-1-1h-5l-1 1H5v2h14V4z"/>
                        </svg>
                    </div>
                    <span class="action-title">Remove Package</span>
                    <p class="action-description">Remove outdated or inactive packages from the system</p>
                </div>
            </a>
        </div>
    </div>

    <h3>Package Statistics</h3>
    <table>
        <tr>
            <th>Metric</th>
            <th>Value</th>
        </tr>
        <tr>
            <td>Total Packages</td>
            <td><%= packages != null ? packages.size() : 0 %></td>
        </tr>
        <tr>
            <td>Active Packages</td>
            <td><%= packages != null ? packages.size() : 0 %></td>
        </tr>
        <tr>
            <td>Most Popular Package</td>
            <td><%= packages != null && !packages.isEmpty() ? packages.get(0).getPackageName() : "None" %></td>
        </tr>
    </table>

    <h3>Recent Packages</h3>
    <table>
        <tr>
            <th>Package ID</th>
            <th>Package Name</th>
            <th>Price</th>
            <th>Duration</th>
            <th>Actions</th>
        </tr>
        <% if (packages != null && !packages.isEmpty()) {
            int maxPackages = Math.min(packages.size(), 5);
            for (int i = 0; i < maxPackages; i++) {
                Package pkg = packages.get(i); %>
        <tr>
            <td><%= pkg.getPackageId() %></td>
            <td><%= pkg.getPackageName() %></td>
            <td>$<%= pkg.getPrice() %></td>
            <td><%= pkg.getDuration() %></td>
            <td>
                <a href="<%= request.getContextPath() %>/tour-package-manager-packages?action=edit&id=<%= pkg.getPackageId() %>">Edit</a> |
                <a href="<%= request.getContextPath() %>/tour-package-manager-packages?action=remove&id=<%= pkg.getPackageId() %>">Remove</a>
            </td>
        </tr>
        <% }
        } else { %>
        <tr>
            <td colspan="5">No packages found</td>
        </tr>
        <% } %>
    </table>

    <% if (packages != null && packages.size() > 5) { %>
    <p><a href="<%= request.getContextPath() %>/tour-package-manager-packages?action=list">View All Packages</a></p>
    <% } %>
</div>

<%@ include file="../common/footer.jsp" %>
</body>
</html>