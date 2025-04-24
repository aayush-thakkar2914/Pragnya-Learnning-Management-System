<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page pageEncoding="UTF-8" %>
<%@ page import="java.util.List, com.lms.dao.CourseDAO, com.lms.dao.EnrollmentDAO, com.lms.models.Course, com.lms.models.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"STUDENT".equals(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }

    CourseDAO courseDAO = new CourseDAO();
    EnrollmentDAO enrollmentDAO = new EnrollmentDAO();
    List<Course> courses = courseDAO.getAllCourses();
    String message = request.getParameter("message");
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Available Courses</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 p-6">
    <div class="max-w-2xl mx-auto bg-white p-6 rounded shadow">
        <h2 class="text-2xl font-bold">Available Courses</h2>
        
        <% if (message != null) { %>
            <p class="text-green-600 mt-2"><%= message %></p>
        <% } %>
        
        <% if (error != null) { %>
            <p class="text-red-600 mt-2"><%= error %></p>
        <% } %>
        
        <%
            if (courses.isEmpty()) {
                out.println("<p class='text-red-500 mt-4'>No courses available.</p>");
            } else {
                for (Course course : courses) {
                    boolean isEnrolled = enrollmentDAO.isStudentEnrolled(user.getUserId(), course.getCourseId());
        %>
            <div class="p-4 border rounded mt-4">
                <h3 class="text-lg font-semibold"><%= course.getTitle() %></h3>
                <p class="text-gray-700"><%= course.getDescription() %></p>

                <!-- Enrollment Form -->
                <% if (isEnrolled) { %>
                    <button class="bg-gray-400 text-white px-4 py-2 rounded mt-2" disabled>Enrolled</button>
                <% } else { %>
                    <form action="enrollCourse" method="post" class="mt-2 inline-block">
                        <input type="hidden" name="course_id" value="<%= course.getCourseId() %>">
                        <button type="submit" class="bg-blue-500 text-white px-4 py-2 rounded">Enroll</button>
                    </form>
                <% } %>
            </div>
        <%
                }
            }
        %>
    </div>
</body>
</html>