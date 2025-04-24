package com.lms.utils;

import java.sql.Connection;

public class TestConnection {
    public static void main(String[] args) {
        try {
            Connection conn = DatabaseConnection.getConnection();
            if (conn != null) {
                System.out.println("✅ Connection successful!");
            } else {
                System.out.println("❌ Failed to connect!");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
