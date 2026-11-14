package com.travel.dao;

import com.travel.model.ReportIssue;
import com.travel.util.DatabaseConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ReportIssueDAO {
    public boolean addReportIssue(ReportIssue reportIssue) {
        String sql = "INSERT INTO ReportIssue (ReportId, CustomerId, IssueDetails, ReportDate) VALUES (?, ?, ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, reportIssue.getReportId());
            pstmt.setInt(2, reportIssue.getCustomerId());
            pstmt.setString(3, reportIssue.getIssueDetails());
            pstmt.setDate(4, new java.sql.Date(reportIssue.getReportDate().getTime()));
            pstmt.executeUpdate();
            return true;
        } catch (SQLException e) {
            System.err.println("SQL Error in addReportIssue: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public ReportIssue getReportIssueById(int reportId) {
        String sql = "SELECT * FROM ReportIssue WHERE ReportId = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, reportId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    ReportIssue issue = new ReportIssue();
                    issue.setReportId(rs.getInt("ReportId"));
                    issue.setCustomerId(rs.getInt("CustomerId"));
                    issue.setIssueDetails(rs.getString("IssueDetails"));
                    issue.setReportDate(rs.getDate("ReportDate"));
                    return issue;
                }
            }
        } catch (SQLException e) {
            System.err.println("SQL Error in getReportIssueById: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateReportIssue(ReportIssue reportIssue) {
        String sql = "UPDATE ReportIssue SET CustomerId = ?, IssueDetails = ?, ReportDate = ? WHERE ReportId = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, reportIssue.getCustomerId());
            pstmt.setString(2, reportIssue.getIssueDetails());
            pstmt.setDate(3, new java.sql.Date(reportIssue.getReportDate().getTime()));
            pstmt.setInt(4, reportIssue.getReportId());
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("SQL Error in updateReportIssue: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public List<ReportIssue> getAllReportIssues() {
        List<ReportIssue> issues = new ArrayList<>();
        String sql = "SELECT * FROM ReportIssue";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                ReportIssue issue = new ReportIssue();
                issue.setReportId(rs.getInt("ReportId"));
                issue.setCustomerId(rs.getInt("CustomerId"));
                issue.setIssueDetails(rs.getString("IssueDetails"));
                issue.setReportDate(rs.getDate("ReportDate"));
                issues.add(issue);
            }
        } catch (SQLException e) {
            System.err.println("SQL Error in getAllReportIssues: " + e.getMessage());
            e.printStackTrace();
        }
        return issues;
    }

    public List<ReportIssue> getReportIssuesByCustomerId(int customerId) {
        List<ReportIssue> issues = new ArrayList<>();
        String sql = "SELECT * FROM ReportIssue WHERE CustomerId = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, customerId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    ReportIssue issue = new ReportIssue();
                    issue.setReportId(rs.getInt("ReportId"));
                    issue.setCustomerId(rs.getInt("CustomerId"));
                    issue.setIssueDetails(rs.getString("IssueDetails"));
                    issue.setReportDate(rs.getDate("ReportDate"));
                    issues.add(issue);
                }
            }
        } catch (SQLException e) {
            System.err.println("SQL Error in getReportIssuesByCustomerId: " + e.getMessage());
            e.printStackTrace();
        }
        return issues;
    }

    public boolean replyToIssue(int reportId, String reply) {
        // First try to update with Reply column
        String sqlWithReply = "UPDATE ReportIssue SET Reply = ? WHERE ReportId = ?";
        System.out.println("Attempting to reply to issue ID: " + reportId + " with reply: " + reply);
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sqlWithReply)) {
            pstmt.setString(1, reply);
            pstmt.setInt(2, reportId);
            int rowsAffected = pstmt.executeUpdate();
            System.out.println("Reply query executed. Rows affected: " + rowsAffected);
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("SQL Error with Reply column: " + e.getMessage());
            System.err.println("SQL State: " + e.getSQLState());
            System.err.println("Error Code: " + e.getErrorCode());
            
            // If Reply column doesn't exist, try alternative approach
            if (e.getErrorCode() == 207 || e.getMessage().contains("Invalid column name")) {
                System.out.println("Reply column doesn't exist, trying alternative approach...");
                return replyToIssueAlternative(reportId, reply);
            }
            
            e.printStackTrace();
            return false;
        }
    }
    
    private boolean replyToIssueAlternative(int reportId, String reply) {
        // Alternative approach: append reply to issue details
        String sql = "UPDATE ReportIssue SET IssueDetails = CONCAT(IssueDetails, '\n\n--- Support Officer Reply ---\n', ?) WHERE ReportId = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, reply);
            pstmt.setInt(2, reportId);
            int rowsAffected = pstmt.executeUpdate();
            System.out.println("Alternative reply query executed. Rows affected: " + rowsAffected);
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("SQL Error in alternative reply: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}