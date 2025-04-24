package com.lms.controllers;

import com.lms.dao.EnrollmentDAO;
import com.lms.models.Course;
import com.lms.models.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/myEnrolledCourses")
public class MyEnrolledCoursesServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        System.out.println("Logged-in Student ID: " + user.getUserId());  // Debugging
        System.out.println("Role: " + user.getRole());

        if (!"STUDENT".equals(user.getRole())) {
            response.sendRedirect("dashboard.jsp");
            return;
        }

        EnrollmentDAO enrollmentDAO = new EnrollmentDAO();
        List<Course> enrolledCourses = enrollmentDAO.getEnrolledCourseDetails(user.getUserId());

        System.out.println("Enrolled Courses Found: " + enrolledCourses.size());  // Debugging

        request.setAttribute("enrolledCourses", enrolledCourses);
        request.getRequestDispatcher("myEnrolledCourses.jsp").forward(request, response);
    }
}
