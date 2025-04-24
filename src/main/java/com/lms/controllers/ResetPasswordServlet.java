package com.lms.controllers;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.mindrot.jbcrypt.BCrypt;

import com.lms.dao.UserDAO;
import com.lms.utils.PasswordHasher;

@WebServlet("/ResetPassword")
public class ResetPasswordServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ResetPasswordServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String token = request.getParameter("token");
        String newPassword = request.getParameter("new_password");

        UserDAO userDAO = new UserDAO();
        String email = userDAO.getUserByToken(token);
        

        if (email != null) {
        	PasswordHasher passwordHasher = new PasswordHasher();
            String hashedPassword = passwordHasher.hashPassword(newPassword);
            userDAO.updatePassword(email, hashedPassword);
            response.sendRedirect("login.jsp?success=Password updated. Login now.");
        } else {
            response.sendRedirect("reset_password.jsp?error=Invalid token.");
        }
    }

}
