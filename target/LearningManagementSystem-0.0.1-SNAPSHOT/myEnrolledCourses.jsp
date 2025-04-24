<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.lms.models.Course, com.lms.dao.MaterialProgressDAO, com.lms.models.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"STUDENT".equals(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<Course> enrolledCourses = (List<Course>) request.getAttribute("enrolledCourses");
    MaterialProgressDAO materialProgressDAO = new MaterialProgressDAO();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Enrolled Courses</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 p-6">
    <div class="max-w-3xl mx-auto bg-white p-6 rounded shadow">
        <h2 class="text-2xl font-bold">My Enrolled Courses</h2>
        <%
            if (enrolledCourses == null || enrolledCourses.isEmpty()) {
                out.println("<p class='text-red-500 mt-4'>You have not enrolled in any courses yet.</p>");
            } else {
                for (Course course : enrolledCourses) {
                    int progress = materialProgressDAO.getProgressPercentage(user.getUserId(), course.getCourseId());
        %>
        <div class="p-4 border rounded mt-4">
            <h3 class="text-lg font-semibold"><%= course.getTitle() %></h3>
            <p class="text-gray-700"><%= course.getDescription() %></p>
            
            <!-- Progress Display -->
            <p class="text-gray-600">Progress: <%= progress %>%</p>
            <div class="w-full bg-gray-200 rounded-full h-4 mt-2">
                <div class="bg-blue-500 h-4 rounded-full" style="width: <%= progress %>%;"></div>
            </div>

            <a href="viewMaterials.jsp?course_id=<%= course.getCourseId() %>"
                class="text-blue-600 font-bold mt-2 inline-block"> View Course Materials </a>
        </div>
        <%
                }
            }
        %>
        <a href="student_dashboard.jsp" class="block mt-6 text-blue-500">Back to Dashboard</a>
    </div>
</body>
</html>
