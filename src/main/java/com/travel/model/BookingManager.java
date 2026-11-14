package com.travel.model;

public class BookingManager extends Employee {
    // Default constructor
    public BookingManager() {
        super();
    }

    // Parameterized constructor
    public BookingManager(int employeeId, String name, String jobTitle, String department,
                          String contactNumber, String email) {
        super(employeeId, name, jobTitle, department, contactNumber, email, null);
    }
}