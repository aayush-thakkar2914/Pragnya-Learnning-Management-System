package com.lms.dao;

import com.lms.models.User; 
import com.lms.utils.DatabaseConnection;

import java.sql.*;

public class UserDAO {



    

    public boolean registerUser(User user) {
        String query = "INSERT INTO users (name, email, password, role, created_at) VALUES (?, ?, ?, ?, SYSDATE)";
        try (	Connection conn = DatabaseConnection.getConnection();
        		PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, user.getName());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, user.getPassword());
            stmt.setString(4, user.getRole());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public User getUserByEmail(String email) {
        String query = "SELECT * FROM users WHERE email = ?";
        try (	Connection conn = DatabaseConnection.getConnection(); // Added to check the DB Connection
        		PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return new User(
                    rs.getInt("user_id"),
                    rs.getString("name"),
                    rs.getString("email"),
                    rs.getString("password"),
                    rs.getString("role"),
                    rs.getTimestamp("created_at")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
 // Check if email exists
    public boolean isEmailExists(String email) {
        boolean exists = false;
        String sql = "SELECT COUNT(*) FROM users WHERE email = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, email);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                exists = rs.getInt(1) > 0;  // If count > 0, email exists
            }

            rs.close();
        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("❌ Error checking email existence!");
        }

        System.out.println("Checking email: " + email + " Exists: " + exists);
        return exists;
    }

 // Save reset token
//    public boolean saveResetToken(String email, String token) {
//        String sql = "UPDATE users SET reset_token = ? WHERE email = ?";
//        
//        try (Connection conn = DatabaseConnection.getConnection();
//             PreparedStatement stmt = conn.prepareStatement(sql)) {
//            
//            stmt.setString(1, token);
//            stmt.setString(2, email);
//
//            int rowsUpdated = stmt.executeUpdate();
//            return rowsUpdated > 0; // ✅ Return true if at least one row is updated
//            
//        } catch (SQLException e) {
//            e.printStackTrace();
//            return false; // ✅ Return false if there was an error
//        }
//    }
    public boolean saveResetToken(String email, String token) {
        String sql = "UPDATE users SET reset_token = ? WHERE email = ?";
        boolean isUpdated = false;

        try (Connection conn = DatabaseConnection.getConnection(); // 🔥 Fresh connection
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, token);
            pstmt.setString(2, email);
            int rowsAffected = pstmt.executeUpdate();

            isUpdated = rowsAffected > 0;  // ✅ Check if update was successful
        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("❌ Error saving reset token!");
        }

        return isUpdated;
    }



    // Get user by reset token
    public String getUserByToken(String token) {
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement("SELECT email FROM users WHERE reset_token = ?")) {
            stmt.setString(1, token);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getString("email");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    // Update password
    public void updatePassword(String email, String hashedPassword) {
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement("UPDATE users SET password = ?, reset_token = NULL WHERE email = ?")) {
            stmt.setString(1, hashedPassword);
            stmt.setString(2, email);
            stmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}