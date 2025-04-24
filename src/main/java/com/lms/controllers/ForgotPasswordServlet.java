package com.lms.controllers;

import java.io.IOException;
import java.security.SecureRandom;
import java.util.Base64;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.lms.dao.UserDAO;
import com.lms.utils.EmailUtil;

@WebServlet("/ForgotPasswordServlet")
public class ForgotPasswordServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public ForgotPasswordServlet() {
        super();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        UserDAO userDAO = new UserDAO();

        try {
            // Validate email exists in DB
        	if (!userDAO.isEmailExists(email)) {
        	    response.sendRedirect("forgot_password.jsp?error=User%20does%20not%20exist.");
        	    return; // Stops further execution
        	}


            // Generate reset token
            String token = generateToken();
            
            // Save token in the database
            boolean tokenSaved = userDAO.saveResetToken(email, token); // ✅ Now returns true/false
            if (!tokenSaved) {
                response.sendRedirect("forgot_password.jsp?error=Failed%20to%20save%20reset%20token.");
                return;
            }

            // Encode token for URL safety
            String encodedToken = URLEncoder.encode(token, StandardCharsets.UTF_8.toString());

            // Generate password reset link
            String resetLink = "http://localhost:8080/LearningManagementSystem/reset_password.jsp?token=" + encodedToken;
            String message = "Click the link to reset your password: " + resetLink;

            // Send email
            boolean emailSent = EmailUtil.sendEmail(email, "Password Reset Request", message);
            if (!emailSent) {
                response.sendRedirect("forgot_password.jsp?error=Failed%20to%20send%20email.");
                return;
            }

            // Redirect with success message
            response.sendRedirect("forgot_password.jsp?success=Check%20your%20email%20for%20reset%20link.");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("forgot_password.jsp?error=Something%20went%20wrong.");
        }
    }

    private String generateToken() {
        SecureRandom random = new SecureRandom();
        byte[] bytes = new byte[24];
        random.nextBytes(bytes);
        return Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
    }
}
