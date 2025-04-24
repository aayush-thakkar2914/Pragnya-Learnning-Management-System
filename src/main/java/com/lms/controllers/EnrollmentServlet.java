package com.lms.controllers;

import com.lms.dao.EnrollmentDAO;
import com.lms.models.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/enrollCourse")
public class EnrollmentServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        // Check if user is logged in
        if (session == null || session.getAttribute("user") == null) {
            session.setAttribute("error", "Please login first");
            response.sendRedirect("login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");

        // Ensure only students can enroll
        if (!"STUDENT".equals(user.getRole())) {
            session.setAttribute("error", "Only students can enroll in courses");
            response.sendRedirect("instructor_dashboard.jsp");
            return;
        }

        // Validate course_id parameter
        String courseIdParam = request.getParameter("course_id");
        if (courseIdParam == null || courseIdParam.trim().isEmpty()) {
            session.setAttribute("error", "Invalid course selection");
            response.sendRedirect("courses.jsp");
            return;
        }

        int courseId;
        try {
            courseId = Integer.parseInt(courseIdParam);
        } catch (NumberFormatException e) {
            session.setAttribute("error", "Invalid course ID");
            response.sendRedirect("courses.jsp");
            return;
        }

        EnrollmentDAO enrollmentDAO = new EnrollmentDAO();

        // Check if the student is already enrolled
        if (enrollmentDAO.isStudentEnrolled(user.getUserId(), courseId)) {
            session.setAttribute("error", "You are already enrolled in this course");
            response.sendRedirect("courses.jsp");
            return;
        }

        // Enroll student
        boolean success = enrollmentDAO.enrollStudent(user.getUserId(), courseId);
        
        if (success) {
            session.setAttribute("message", "Successfully enrolled in the course");
        } else {
            session.setAttribute("error", "Enrollment failed. Try again later.");
        }
        response.sendRedirect("courses.jsp");
    }
}
