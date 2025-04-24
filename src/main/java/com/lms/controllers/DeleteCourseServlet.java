package com.lms.controllers;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.lms.dao.CourseDAO;

@WebServlet("/deleteCourse")
public class DeleteCourseServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int courseId = Integer.parseInt(request.getParameter("courseId"));

        CourseDAO courseDAO = new CourseDAO();
        boolean deleted = courseDAO.deleteCourse(courseId);

        if (deleted) {
            response.sendRedirect("viewInstructorCourses");
        } else {
            response.getWriter().println("Error deleting course.");
        }
    }
}
