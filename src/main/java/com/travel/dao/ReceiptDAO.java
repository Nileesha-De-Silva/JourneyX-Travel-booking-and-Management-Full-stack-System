// File: src/main/java/com/travel/dao/ReceiptDAO.java
package com.travel.dao;

import com.travel.model.Receipt;
import java.util.ArrayList;
import java.util.List;

public class ReceiptDAO {
    private static List<Receipt> receipts = new ArrayList<>();
    private static int nextId = 1;

    public int addReceipt(Receipt receipt) {
        receipt.setReceiptId(nextId++);
        receipts.add(receipt);
        return receipt.getReceiptId();
    }

    public Receipt getReceiptByBookingId(int bookingId) {
        for (Receipt receipt : receipts) {
            if (receipt.getBookingId() == bookingId) {
                return receipt;
            }
        }
        return null;
    }

    public boolean updateReceipt(Receipt receipt) {
        for (int i = 0; i < receipts.size(); i++) {
            if (receipts.get(i).getReceiptId() == receipt.getReceiptId()) {
                receipts.set(i, receipt);
                return true;
            }
        }
        return false;
    }

    public List<Receipt> getAllReceipts() {
        return new ArrayList<>(receipts);
    }
}