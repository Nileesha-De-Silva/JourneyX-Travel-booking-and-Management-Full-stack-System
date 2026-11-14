<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.travel.model.PaymentManager" %>
<%@ page import="com.travel.service.PaymentService" %>
<%@ page import="com.travel.service.ReceiptService" %>
<%@ page import="com.travel.model.Payment" %>
<%@ page import="java.util.List" %>
<%
    PaymentManager manager = (PaymentManager) session.getAttribute("user");
    PaymentService paymentService = new PaymentService();
    ReceiptService receiptService = new ReceiptService();

    List<Payment> pendingPayments = paymentService.getPendingPayments();
    List<Payment> approvedPayments = paymentService.getPaymentsByStatus("Approved");
    List<Payment> rejectedPayments = paymentService.getPaymentsByStatus("Rejected");
    
    // Calculate receipt statistics
    int totalReceipts = 0;
    int sentReceipts = 0;
    int pendingReceipts = 0;
    
    // Debug: Get all receipts
    java.util.List<com.travel.model.Receipt> allReceipts = receiptService.getAllReceipts();
    System.out.println("Total receipts in system: " + allReceipts.size());
    
    // Debug: Show receipt content for first receipt if exists
    if (!allReceipts.isEmpty()) {
        com.travel.model.Receipt firstReceipt = allReceipts.get(0);
        System.out.println("Sample Receipt Content:");
        System.out.println("========================");
        System.out.println(firstReceipt.getContent());
        System.out.println("========================");
    }
    
    for (Payment payment : approvedPayments) {
        com.travel.model.Receipt receipt = receiptService.getReceiptByBookingId(payment.getBookingId());
        if (receipt != null) {
            totalReceipts++;
            if (receipt.isSent()) {
                sentReceipts++;
            } else {
                pendingReceipts++;
            }
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment Manager Dashboard</title>
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/Payment-Manager/dashboard.css">

</head>
<body>
<jsp:include page="/views/common/header-paymentmanager.jsp"/>

<div class="dashboard-container">
    <div class="dashboard-header">
        <h1>Payment Manager Dashboard</h1>
        <p>Welcome, <%= manager.getName() %>! Manage all payment operations efficiently.</p>
    </div>

    <h3>Payment Statistics</h3>
    <div class="stats-container">
        <div class="stat-card pending">
            <div class="stat-icon">
                <svg viewBox="0 0 24 24">
                    <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 15h-2v-6h2v6zm0-8h-2V7h2v2z"/>
                </svg>
            </div>
            <div class="stat-value"><%= pendingPayments.size() %></div>
            <div class="stat-label">Pending Payments</div>
        </div>
        <div class="stat-card approved">
            <div class="stat-icon">
                <svg viewBox="0 0 24 24">
                    <path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/>
                </svg>
            </div>
            <div class="stat-value"><%= approvedPayments.size() %></div>
            <div class="stat-label">Approved Payments</div>
        </div>
        <div class="stat-card rejected">
            <div class="stat-icon">
                <svg viewBox="0 0 24 24">
                    <path d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z"/>
                </svg>
            </div>
            <div class="stat-value"><%= rejectedPayments.size() %></div>
            <div class="stat-label">Rejected Payments</div>
        </div>
        <div class="stat-card revenue">
            <div class="stat-icon">
                <svg viewBox="0 0 24 24">
                    <path d="M11.8 10.9c-2.27-.59-3-1.2-3-2.15 0-1.09 1.01-1.85 2.7-1.85 1.78 0 2.44.85 2.5 2.1h2.21c-.07-1.72-1.12-3.3-3.21-3.81V3h-3v2.16c-1.94.42-3.5 1.68-3.5 3.61 0 2.31 1.91 3.46 4.7 4.13 2.5.6 3 1.48 3 2.41 0 1.28-1.15 2.05-2.81 2.05-1.86 0-2.88-1.05-3-2.37h-2.21c.1 1.86 1.37 3.55 3.52 4.01V21h3v-2.15c1.95-.37 3.5-1.5 3.5-3.55 0-2.84-2.43-3.81-4.7-4.4z"/>
                </svg>
            </div>
            <div class="stat-value">$<%= paymentService.getTotalRevenue() %></div>
            <div class="stat-label">Total Revenue</div>
        </div>
        <div class="stat-card receipts">
            <div class="stat-icon">
                <svg viewBox="0 0 24 24">
                    <path d="M14,2H6A2,2 0 0,0 4,4V20A2,2 0 0,0 6,22H18A2,2 0 0,0 20,20V8L14,2M18,20H6V4H13V9H18V20Z"/>
                </svg>
            </div>
            <div class="stat-value"><%= totalReceipts %></div>
            <div class="stat-label">Total Receipts</div>
        </div>
        <div class="stat-card sent-receipts">
            <div class="stat-icon">
                <svg viewBox="0 0 24 24">
                    <path d="M2,3H22A2,2 0 0,1 24,5V19A2,2 0 0,1 22,21H2A2,2 0 0,1 0,19V5A2,2 0 0,1 2,3M2,5V19H22V5H2M4,7H20V9H4V7M4,11H20V13H4V11M4,15H20V17H4V15Z"/>
                </svg>
            </div>
            <div class="stat-value"><%= sentReceipts %></div>
            <div class="stat-label">Sent Receipts</div>
        </div>
        <div class="stat-card pending-receipts">
            <div class="stat-icon">
                <svg viewBox="0 0 24 24">
                    <path d="M12,2A10,10 0 0,0 2,12A10,10 0 0,0 12,22A10,10 0 0,0 22,12A10,10 0 0,0 12,2M12,4A8,8 0 0,1 20,12A8,8 0 0,1 12,20A8,8 0 0,1 4,12A8,8 0 0,1 12,4M12,6A6,6 0 0,0 6,12A6,6 0 0,0 12,18A6,6 0 0,0 18,12A6,6 0 0,0 12,6M12,8A4,4 0 0,1 16,12A4,4 0 0,1 12,16A4,4 0 0,1 8,12A4,4 0 0,1 12,8Z"/>
                </svg>
            </div>
            <div class="stat-value"><%= pendingReceipts %></div>
            <div class="stat-label">Pending Receipts</div>
        </div>
    </div>

    <h3>Quick Actions</h3>
    <div class="quick-actions">
        <div class="quick-action">
            <a href="<%= request.getContextPath() %>/tour-payment-manager-payments?status=All">
                <img src="https://thumbs.dreamstime.com/b/divided-payments-european-union-currency-near-calculator-felt-tip-pen-paper-background-digits-table-41784858.jpg" alt="View All Payments" class="action-image">
                <div class="action-content">
                    <div class="action-icon">
                        <svg viewBox="0 0 24 24">
                            <path d="M19 3h-4.18C14.4 1.84 13.3 1 12 1c-1.3 0-2.4.84-2.82 2H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm-7 0c.55 0 1 .45 1 1s-.45 1-1 1-1-.45-1-1 .45-1 1-1zm2 14H7v-2h7v2zm3-4H7v-2h10v2zm0-4H7V7h10v2z"/>
                        </svg>
                    </div>
                    <span class="action-title">View All Payments</span>
                    <p class="action-description">Review and manage all customer payments</p>
                </div>
            </a>
        </div>
        <div class="quick-action">
            <a href="<%= request.getContextPath() %>/tour-payment-manager-payments?status=Pending">
                <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTQTKr-lnBRRkqM5xiuBxjc039FFXu3pxxv8Q&s" alt="Pending Payments" class="action-image">
                <div class="action-content">
                    <div class="action-icon">
                        <svg viewBox="0 0 24 24">
                            <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 15h-2v-6h2v6zm0-8h-2V7h2v2z"/>
                        </svg>
                    </div>
                    <span class="action-title">Pending Payments</span>
                    <p class="action-description">Review payments awaiting approval</p>
                </div>
            </a>
        </div>
        <div class="quick-action">
            <a href="<%= request.getContextPath() %>/tour-payment-manager-payments?status=Approved">
                <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRQwzLydglDBXd-SSEiDkPXIxQC_dT589pSVGFSF_BV-m0JyAb1KW6_FKVpLEpoan66pmQ&usqp=CAU" alt="Approved Payments" class="action-image">
                <div class="action-content">
                    <div class="action-icon">
                        <svg viewBox="0 0 24 24">
                            <path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/>
                        </svg>
                    </div>
                    <span class="action-title">Approved Payments</span>
                    <p class="action-description">View all approved payments</p>
                </div>
            </a>
        </div>
        <div class="quick-action">
            <a href="<%= request.getContextPath() %>/tour-payment-manager-payments?status=Approved">
                <img src="https://www.shutterstock.com/image-photo/financial-report-banking-management-e-260nw-2537984823.jpg" alt="Receipt Management" class="action-image">
                <div class="action-content">
                    <div class="action-icon">
                        <svg viewBox="0 0 24 24">
                            <path d="M14,2H6A2,2 0 0,0 4,4V20A2,2 0 0,0 6,22H18A2,2 0 0,0 20,20V8L14,2M18,20H6V4H13V9H18V20Z"/>
                        </svg>
                    </div>
                    <span class="action-title">Receipt Management</span>
                    <p class="action-description">Create and send receipts for approved payments</p>
                </div>
            </a>
        </div>
    </div>

    <!-- Debug Section -->
    <div class="debug-section" style="background: #f8f9fa; padding: 20px; margin: 20px 0; border-radius: 8px; border: 1px solid #dee2e6;">
        <h3>Debug: Receipt Information</h3>
        <p><strong>Total Receipts in System:</strong> <%= allReceipts.size() %></p>
        <% if (!allReceipts.isEmpty()) { %>
        <table style="width: 100%; border-collapse: collapse; margin-top: 10px;">
            <tr style="background: #e9ecef;">
                <th style="padding: 8px; border: 1px solid #dee2e6;">Receipt ID</th>
                <th style="padding: 8px; border: 1px solid #dee2e6;">Booking ID</th>
                <th style="padding: 8px; border: 1px solid #dee2e6;">Generated Date</th>
                <th style="padding: 8px; border: 1px solid #dee2e6;">Sent</th>
            </tr>
            <% for (com.travel.model.Receipt receipt : allReceipts) { %>
            <tr>
                <td style="padding: 8px; border: 1px solid #dee2e6;"><%= receipt.getReceiptId() %></td>
                <td style="padding: 8px; border: 1px solid #dee2e6;"><%= receipt.getBookingId() %></td>
                <td style="padding: 8px; border: 1px solid #dee2e6;"><%= receipt.getGeneratedDate() %></td>
                <td style="padding: 8px; border: 1px solid #dee2e6;"><%= receipt.isSent() ? "Yes" : "No" %></td>
            </tr>
            <% } %>
        </table>
        <% } else { %>
        <p style="color: #6c757d; font-style: italic;">No receipts found in the system.</p>
        <% } %>
        
        <!-- Sample Receipt Preview -->
        <% if (!allReceipts.isEmpty()) { %>
        <div style="margin-top: 20px;">
            <h4>Sample Receipt Preview:</h4>
            <div style="background: #f8f9fa; padding: 15px; border-radius: 5px; border: 1px solid #dee2e6; max-height: 300px; overflow-y: auto;">
                <pre style="margin: 0; font-family: 'Courier New', monospace; font-size: 12px; white-space: pre-wrap;"><%= allReceipts.get(0).getContent() %></pre>
            </div>
        </div>
        <% } %>
    </div>

    <div class="recent-payments">
        <h3>Recent Pending Payments</h3>
        <div class="table-responsive">
            <table>
                <tr>
                    <th>Payment ID</th>
                    <th>Customer ID</th>
                    <th>Amount</th>
                    <th>Actions</th>
                </tr>
                <% for (int i = 0; i < Math.min(pendingPayments.size(), 5); i++) {
                    Payment payment = pendingPayments.get(i); %>
                <tr>
                    <td><%= payment.getPaymentId() %></td>
                    <td><%= payment.getCustomerId() %></td>
                    <td>$<%= payment.getAmount() %></td>
                    <td>
                        <form action="<%= request.getContextPath() %>/tour-payment-manager-payments" method="post" style="display:inline;">
                            <input type="hidden" name="action" value="approve">
                            <input type="hidden" name="paymentId" value="<%= payment.getPaymentId() %>">
                            <input type="submit" value="Approve" class="btn-approve">
                        </form>
                        <form action="<%= request.getContextPath() %>/tour-payment-manager-payments" method="post" style="display:inline;">
                            <input type="hidden" name="action" value="reject">
                            <input type="hidden" name="paymentId" value="<%= payment.getPaymentId() %>">
                            <input type="submit" value="Reject" class="btn-reject">
                        </form>
                    </td>
                </tr>
                <% } %>
            </table>
        </div>

        <% if (pendingPayments.size() > 5) { %>
        <a href="<%= request.getContextPath() %>/tour-payment-manager-payments?status=Pending" class="view-all-link">View All Pending Payments</a>
        <% } %>
    </div>
</div>

<jsp:include page="/views/common/footer.jsp"/>
</body>
</html>