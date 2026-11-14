// File: src/main/java/com/travel/model/Receipt.java
package com.travel.model;

import java.util.Date;

public class Receipt {
    private int receiptId;
    private int bookingId;
    private Date generatedDate;
    private String content;
    private boolean sent;

    public Receipt() {
    }

    public Receipt(int bookingId, String content) {
        this.bookingId = bookingId;
        this.content = content;
        this.generatedDate = new Date();
        this.sent = false;
    }

    // Getters and Setters
    public int getReceiptId() { return receiptId; }
    public void setReceiptId(int receiptId) { this.receiptId = receiptId; }
    public int getBookingId() { return bookingId; }
    public void setBookingId(int bookingId) { this.bookingId = bookingId; }
    public Date getGeneratedDate() { return generatedDate; }
    public void setGeneratedDate(Date generatedDate) { this.generatedDate = generatedDate; }
    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
    public boolean isSent() { return sent; }
    public void setSent(boolean sent) { this.sent = sent; }
}