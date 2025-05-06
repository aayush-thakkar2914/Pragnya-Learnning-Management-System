package com.lms.controllers;

import java.io.IOException;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.lms.dao.EnrollmentDAO;
import com.lms.dao.MaterialProgressDAO;
import com.lms.models.Course;
import com.lms.models.User;

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
        MaterialProgressDAO progressDAO = new MaterialProgressDAO();
        List<Course> enrolledCourses = enrollmentDAO.getEnrolledCourseDetails(user.getUserId());
        Map<Course, Integer> courseProgressMap = new LinkedHashMap<>();


        System.out.println("Enrolled Courses Found: " + enrolledCourses.size());  // Debugging
        for (Course course : enrolledCourses) {
            int progress = progressDAO.getProgressPercentage(user.getUserId(), course.getCourseId());
            courseProgressMap.put(course, progress);
        }
        
        request.setAttribute("courseProgressMap", courseProgressMap);
        request.setAttribute("enrolledCourses", enrolledCourses);
        request.getRequestDispatcher("myEnrolledCourses.jsp").forward(request, response);
    }
}
