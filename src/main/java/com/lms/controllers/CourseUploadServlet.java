package com.lms.controllers;

import com.lms.dao.CourseDAO;
import com.lms.models.Course;
import com.lms.models.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/uploadCourse")
public class CourseUploadServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!"INSTRUCTOR".equals(user.getRole())) {
            response.sendRedirect("student_dashboard.jsp");
            return;
        }

        String title = request.getParameter("title");
        String description = request.getParameter("description");

        CourseDAO courseDAO = new CourseDAO();
        boolean success = courseDAO.addCourse(new Course(0, title, description, user.getUserId(), null));

        if (success) {
            response.sendRedirect("instructor_dashboard.jsp?message=Course added successfully");
        } else {
            response.sendRedirect("add_course.jsp?error=Failed to add course");
        }
    }
}
