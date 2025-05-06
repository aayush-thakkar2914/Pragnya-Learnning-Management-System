package com.lms.controllers;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.lms.dao.CourseDAO;
import com.lms.models.Course;
import com.lms.models.User;

@WebServlet("/viewInstructorCourses")
public class ViewInstructorCoursesServlet extends HttpServlet {
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		HttpSession session = request.getSession(false);
		if (session == null || session.getAttribute("user") == null) {
			response.sendRedirect("login.jsp");
			return;
		}
		User user = (User) session.getAttribute("user");
		if (!"INSTRUCTOR".equals(user.getRole())) {
			response.sendRedirect("instructor_dashboard.jsp");
			return;
		}

		CourseDAO courseDAO = new CourseDAO();
		List<Course> instructorCourses = courseDAO.getCoursesByInstructor(user.getUserId());

		// Pass any success parameter from the request to the JSP
		String uploadSuccess = request.getParameter("uploadSuccess");
		if (uploadSuccess != null) {
			request.setAttribute("uploadSuccess", "true");
		}

		request.setAttribute("instructorCourses", instructorCourses);
		request.getRequestDispatcher("instructorCourses.jsp").forward(request, response);
	}
}