package com.lms.controllers;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.lms.dao.CourseDAO;
import com.lms.models.User;

@WebServlet("/toggleCourseStatus")
public class ToggleCourseStatusServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check if user is logged in and is an instructor
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
        
        // Get parameters
        int courseId = Integer.parseInt(request.getParameter("courseId"));
        boolean isActive = Boolean.parseBoolean(request.getParameter("active"));
        
        // If trying to set to active, first check if course has materials
        CourseDAO courseDAO = new CourseDAO();
        boolean success = false;
        
        if (isActive) {
            // Only mark as active if it has materials
            if (courseDAO.hasMaterials(courseId)) {
                success = courseDAO.toggleCourseActiveStatus(courseId, isActive);
            } else {
                // Redirect with error message if no materials
                response.sendRedirect("viewInstructorCourses?error=Cannot mark course as active - no materials uploaded");
                return;
            }
        } else {
            // Always allow marking as inactive
            success = courseDAO.toggleCourseActiveStatus(courseId, isActive);
        }
        
        if (success) {
            response.sendRedirect("viewInstructorCourses?statusSuccess=true");
        } else {
            response.sendRedirect("viewInstructorCourses?error=Failed to update course status");
        }
    }
}