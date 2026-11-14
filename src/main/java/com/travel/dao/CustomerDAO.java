// File: src/main/java/com/travel/dao/CustomerDAO.java
package com.travel.dao;

import com.travel.model.Customer;
import com.travel.util.DatabaseConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CustomerDAO {

    // Add a new customer to the database
    public boolean addCustomer(Customer customer) {
        String sql = "INSERT INTO Customer (FirstName, LastName, CustomerName, NICNumber, Gender, Password, Address, Emial) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            pstmt.setString(1, customer.getFirstName()); // Fixed index
            pstmt.setString(2, customer.getLastName());  // Fixed index
            pstmt.setString(3, customer.getCustomerName());
            pstmt.setString(4, customer.getNicNumber());
            pstmt.setString(5, customer.getGender());
            pstmt.setString(6, customer.getPassword());
            pstmt.setString(7, customer.getAddress());
            pstmt.setString(8, customer.getEmail()); // Using "Emial" in DB but getEmail() in model

            int rowsAffected = pstmt.executeUpdate();

            // If customer was added successfully, get the generated ID
            if (rowsAffected > 0) {
                ResultSet rs = pstmt.getGeneratedKeys();
                if (rs.next()) {
                    customer.setCustomerId(rs.getInt(1));
                    return true;
                }
            }
            return false;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Add customer phone number
    public boolean addCustomerPhone(int customerId, String phoneNumber) {
        String sql = "INSERT INTO CustomerPhone (CustomerId, PhoneNumber) VALUES (?, ?)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, customerId);
            pstmt.setString(2, phoneNumber);

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Register customer with phone number
    public boolean registerCustomer(Customer customer, String phoneNumber) {
        // First add the customer
        boolean customerAdded = addCustomer(customer);

        // If customer was added successfully, add the phone number
        if (customerAdded) {
            return addCustomerPhone(customer.getCustomerId(), phoneNumber);
        }

        return false;
    }

    // Get customer by ID
    public Customer getCustomerById(int customerId) {
        String sql = "SELECT * FROM Customer WHERE CustomerId = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, customerId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                Customer customer = new Customer();
                customer.setCustomerId(rs.getInt("CustomerId"));
                customer.setFirstName(rs.getString("FirstName"));
                customer.setLastName(rs.getString("LastName"));
                customer.setCustomerName(rs.getString("CustomerName"));
                customer.setNicNumber(rs.getString("NICNumber"));
                customer.setGender(rs.getString("Gender"));
                customer.setPassword(rs.getString("Password"));
                customer.setAddress(rs.getString("Address"));
                customer.setEmail(rs.getString("Emial")); // Fixed column name
                return customer;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Get customer by email
    public Customer getCustomerByEmail(String email) {
        String sql = "SELECT * FROM Customer WHERE Emial = ?"; // Fixed column name

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, email);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                Customer customer = new Customer();
                customer.setCustomerId(rs.getInt("CustomerId"));
                customer.setFirstName(rs.getString("FirstName"));
                customer.setLastName(rs.getString("LastName"));
                customer.setCustomerName(rs.getString("CustomerName"));
                customer.setNicNumber(rs.getString("NICNumber"));
                customer.setGender(rs.getString("Gender"));
                customer.setPassword(rs.getString("Password"));
                customer.setAddress(rs.getString("Address"));
                customer.setEmail(rs.getString("Emial")); // Fixed column name
                return customer;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Update customer information
    public boolean updateCustomer(Customer customer) {
        String sql = "UPDATE Customer SET FirstName = ?, LastName = ?, CustomerName = ?, NICNumber = ?, Gender = ?, Password = ?, Address = ?, Emial = ? WHERE CustomerId = ?"; // Fixed column name

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, customer.getFirstName());
            pstmt.setString(2, customer.getLastName());
            pstmt.setString(3, customer.getCustomerName());
            pstmt.setString(4, customer.getNicNumber());
            pstmt.setString(5, customer.getGender());
            pstmt.setString(6, customer.getPassword());
            pstmt.setString(7, customer.getAddress());
            pstmt.setString(8, customer.getEmail());
            pstmt.setInt(9, customer.getCustomerId());

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Delete a customer and all related records
    public boolean deleteCustomer(int customerId) {
        System.out.println("Attempting to delete customer with ID: " + customerId);

        try (Connection conn = DatabaseConnection.getConnection()) {
            // Disable auto-commit to handle transaction
            conn.setAutoCommit(false);
            
            try {
                // Delete related records first
                deleteCustomerRelatedRecords(conn, customerId);
                
                // Delete the customer
                String sql = "DELETE FROM Customer WHERE CustomerId = ?";
                try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                    pstmt.setInt(1, customerId);
                    int rowsAffected = pstmt.executeUpdate();
                    System.out.println("Delete customer query executed. Rows affected: " + rowsAffected);
                    
                    if (rowsAffected > 0) {
                        conn.commit();
                        return true;
                    } else {
                        conn.rollback();
                        return false;
                    }
                }
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            }
        } catch (SQLException e) {
            System.err.println("Error deleting customer: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    // Delete all records related to a customer
    private void deleteCustomerRelatedRecords(Connection conn, int customerId) throws SQLException {
        // Delete customer phone numbers
        String deletePhoneSql = "DELETE FROM CustomerPhone WHERE CustomerId = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(deletePhoneSql)) {
            pstmt.setInt(1, customerId);
            int phoneRows = pstmt.executeUpdate();
            System.out.println("Deleted " + phoneRows + " phone records for customer " + customerId);
        }
        
        // Delete customer feedback
        String deleteFeedbackSql = "DELETE FROM Feedback WHERE CustomerId = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(deleteFeedbackSql)) {
            pstmt.setInt(1, customerId);
            int feedbackRows = pstmt.executeUpdate();
            System.out.println("Deleted " + feedbackRows + " feedback records for customer " + customerId);
        }
        
        // Delete customer payments
        String deletePaymentSql = "DELETE FROM Payment WHERE CustomerId = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(deletePaymentSql)) {
            pstmt.setInt(1, customerId);
            int paymentRows = pstmt.executeUpdate();
            System.out.println("Deleted " + paymentRows + " payment records for customer " + customerId);
        }
        
        // Delete customer bookings
        String deleteBookingSql = "DELETE FROM Booking WHERE CustomerId = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(deleteBookingSql)) {
            pstmt.setInt(1, customerId);
            int bookingRows = pstmt.executeUpdate();
            System.out.println("Deleted " + bookingRows + " booking records for customer " + customerId);
        }
    }

    // Get all customers
    public List<Customer> getAllCustomers() {
        List<Customer> customers = new ArrayList<>();
        String sql = "SELECT * FROM Customer";

        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Customer customer = new Customer();
                customer.setCustomerId(rs.getInt("CustomerId"));
                customer.setFirstName(rs.getString("FirstName"));
                customer.setLastName(rs.getString("LastName"));
                customer.setCustomerName(rs.getString("CustomerName"));
                customer.setNicNumber(rs.getString("NICNumber"));
                customer.setGender(rs.getString("Gender"));
                customer.setPassword(rs.getString("Password"));
                customer.setAddress(rs.getString("Address"));
                customer.setEmail(rs.getString("Emial")); // Fixed column name
                customers.add(customer);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return customers;
    }

    // Validate customer login
    public Customer validateCustomer(String email, String password) {
        String sql = "SELECT * FROM Customer WHERE Emial = ? AND Password = ?"; // Fixed column name

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, email);
            pstmt.setString(2, password);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                Customer customer = new Customer();
                customer.setCustomerId(rs.getInt("CustomerId"));
                customer.setFirstName(rs.getString("FirstName"));
                customer.setLastName(rs.getString("LastName"));
                customer.setCustomerName(rs.getString("CustomerName"));
                customer.setNicNumber(rs.getString("NICNumber"));
                customer.setGender(rs.getString("Gender"));
                customer.setPassword(rs.getString("Password"));
                customer.setAddress(rs.getString("Address"));
                customer.setEmail(rs.getString("Emial")); // Fixed column name
                return customer;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}