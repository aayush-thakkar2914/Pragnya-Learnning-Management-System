package com.lms.utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseConnection {
	private static final String URL = "jdbc:oracle:thin:@//localhost:1521/XE";
//	private static final String URL = "jdbc:oracle:thin:@localhost:1521:XE"; // Change as per your DB
	private static final String USERNAME = "lms";
	private static final String PASSWORD = "root";

	private static Connection conn = null;

	private DatabaseConnection() {
	}

	// Load Driver and Establish Connection
	public static Connection getConnection() {
	    try {
	        if (conn == null || conn.isClosed()) {  // 🔥 Check if closed
	            Class.forName("oracle.jdbc.driver.OracleDriver");
	            conn = DriverManager.getConnection(URL, USERNAME, PASSWORD);
//	            System.out.println("✅ Database Connected Successfully!");
	        }
	    } catch (ClassNotFoundException | SQLException e) {
	        e.printStackTrace();
	        System.out.println("❌ Database Connection Failed!");
	    }
	    return conn;
	}

	// Close Connection
	public static void closeConnection(Connection conn) {
		try {
			if (conn != null) {
				conn.close();
				System.out.println("✅ Database Connection Closed.");
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
}
