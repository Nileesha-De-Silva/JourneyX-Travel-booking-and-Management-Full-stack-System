<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.travel.model.SystemAdmin" %>
<%@ page import="com.travel.model.Customer" %>
<%@ page import="java.util.List" %>
<%
    SystemAdmin admin = (SystemAdmin) request.getAttribute("admin");
    if (admin == null) {
        response.sendRedirect(request.getContextPath() + "/tour-login");
        return;
    }
    List<Customer> customers = (List<Customer>) request.getAttribute("customers");

%>
<%@ include file="../../common/header-system-admin.jsp" %>
<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/System-Admin/user-customer.css">

<h2>Manage Customers</h2>

<h3>Customer Management</h3>
<p>This section allows you to manage customer accounts. You can view, edit, or delete customer information as needed.</p>
<h3>Recent Customers</h3>
<table>
    <tr>
        <th>Customer ID</th>
        <th>Name</th>
        <th>Email</th>
        <th>Address</th>
        <th>Gender</th>
        <th>Contact Number</th>
        <th>Actions</th>
    </tr>

    <% if (customers != null && !customers.isEmpty()) {
        for (Customer c : customers) { %>
    <tr>
        <td><%= c.getCustomerId() %></td>
        <td><%= c.getCustomerName() %></td>
        <td><%= c.getEmail() %></td>
        <td><%= c.getAddress() %></td>
        <td><%= c.getGender() %></td>
        <td><%= c.getContactNumber() %></td>
        <td>
            <form action="<%= request.getContextPath() %>/tour-system-admin-users" method="post">
                <input type="hidden" name="action" value="delete-customer">
                <input type="hidden" name="customerId" value="<%= c.getCustomerId() %>">
                <input type="submit" value="Delete" onclick="return confirm('Are you sure you want to delete this customer?');">
            </form>
        </td>
    </tr>
    <% }
    } else { %>
    <tr>
        <td colspan="7">No customers found</td>
    </tr>
    <% } %>
</table>


<%@ include file="../../common/footer.jsp" %>