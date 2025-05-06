package com.lms.controllers;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.lms.dao.UserDAO;
import com.lms.utils.PasswordHasher;

@WebServlet("/ResetPassword")
public class ResetPasswordServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
       
    public ResetPasswordServlet() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.getWriter().append("Served at: ").append(request.getContextPath());
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String token = request.getParameter("token");
        String newPassword = request.getParameter("new_password");
        String confirmPassword = request.getParameter("confirm_password");
        
        // Validate input
        if (token == null || token.trim().isEmpty()) {
            response.sendRedirect("forgot_password.jsp?error=Invalid token. Please request a new password reset.");
            return;
        }
        
        if (newPassword == null || newPassword.trim().isEmpty()) {
            response.sendRedirect("reset_password.jsp?token=" + token + "&error=Password cannot be empty.");
            return;
        }
        
        // Server-side password match validation
        if (confirmPassword == null || !newPassword.equals(confirmPassword)) {
            response.sendRedirect("reset_password.jsp?token=" + token + "&error=Passwords do not match.");
            return;
        }

        UserDAO userDAO = new UserDAO();
        String email = userDAO.getUserByToken(token);
        
        if (email != null) {
            // Create a password hasher and hash the password
            PasswordHasher passwordHasher = new PasswordHasher();
            String hashedPassword = passwordHasher.hashPassword(newPassword);
            
            // Update password
            boolean updated = userDAO.updatePassword(email, hashedPassword);
            
            if (updated) {
                // Password updated successfully
                System.out.println("✅ Password updated successfully for email: " + email);
                response.sendRedirect("login.jsp?success=Password updated successfully. Please login with your new password.");
            } else {
                System.out.println("❌ Failed to update password for email: " + email);
                response.sendRedirect("reset_password.jsp?token=" + token + "&error=Failed to update password. Please try again.");
            }
        } else {
            System.out.println("❌ Invalid or expired token: " + token);
            response.sendRedirect("forgot_password.jsp?error=Invalid or expired token. Please request a new password reset.");
        }
    }
}