package com.lms.controllers;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.lms.dao.UserDAO;
import com.lms.models.User;
import com.lms.utils.PasswordHasher;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");


        UserDAO userDAO = new UserDAO();
        User user = userDAO.getUserByEmail(email);
        PasswordHasher passwordHasher = new PasswordHasher();

//        if (user != null && user.getPassword().equals(password)) {
        if (user != null && passwordHasher.checkPassword(password, user.getPassword())) { // <-Added to check the user working or not
            // Create a new session and store user details
            HttpSession session = request.getSession(true); // Ensure new session is created
            session.setAttribute("user", user);
            session.setAttribute("user_id", user.getUserId());
            session.setAttribute("role", user.getRole());

            if ("INSTRUCTOR".equals(user.getRole())) {
                response.sendRedirect("instructor_dashboard.jsp");
            } else {
                response.sendRedirect("student_dashboard.jsp");
            }
        } else {
            response.sendRedirect("login.jsp?error=Invalid credentials");
        }
    }
}
