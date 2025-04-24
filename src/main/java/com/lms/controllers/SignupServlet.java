package com.lms.controllers;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.mindrot.jbcrypt.BCrypt;

import com.lms.dao.UserDAO;
import com.lms.models.User;
import com.lms.utils.PasswordHasher;

@WebServlet("/signup")
public class SignupServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String role = request.getParameter("role");
        
        PasswordHasher passwordHasher = new PasswordHasher();

        
        String hashedPassword = passwordHasher.hashPassword(password) ;// Remove this line so the new user password creation will be unhashed
        // Validate input
        if (name == null || email == null || password == null || role == null ||
                name.isEmpty() || email.isEmpty() || password.isEmpty() || role.isEmpty()) {
            response.sendRedirect("signup.jsp?error=All fields are required");
            return;
        }

        User user = new User(name, email, hashedPassword, role); // change hashedPassword to password
        UserDAO userDAO = new UserDAO();

        if (userDAO.registerUser(user)) {
            response.sendRedirect("login.jsp?success=Account created successfully");
        } else {
            response.sendRedirect("signup.jsp?error=Failed to register. Try again.");
        }
    }
}
