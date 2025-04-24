<%@ page import="java.util.List" %>
<%@ page import="com.lms.models.Course" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>My Courses</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100">
    <div class="max-w-4xl mx-auto p-6 bg-white shadow-lg rounded-lg mt-10">
        <h2 class="text-2xl font-bold mb-4">My Uploaded Courses</h2>
        
        <%
            List<Course> instructorCourses = (List<Course>) request.getAttribute("instructorCourses");
            if (instructorCourses != null && !instructorCourses.isEmpty()) {
                for (Course course : instructorCourses) {
        %>
            <div class="p-4 mb-4 border rounded-lg shadow-sm bg-gray-50">
                <h3 class="text-xl font-semibold"><%= course.getTitle() %></h3>
                <p class="text-gray-600"><%= course.getDescription() %></p>
                <a href="courseDetails.jsp?courseId=<%= course.getCourseId() %>" class="text-blue-500">View Details</a>
            </div>
            <!-- Upload Material Form -->
        <form action="uploadMaterial" method="post" enctype="multipart/form-data">
            <input type="hidden" name="courseId" value="<%= course.getCourseId() %>">
            <input type="file" name="file" required>
            <button type="submit" class="bg-blue-500 text-white px-3 py-1 rounded">Upload</button>
        </form>

        <!-- Delete Course -->
        <form action="deleteCourse" method="post">
            <input type="hidden" name="courseId" value="<%= course.getCourseId() %>">
            <button type="submit" class="bg-red-500 text-white px-3 py-1 rounded">Delete</button>
        </form>
        <%
                }
            } else {
        %>
            <p class="text-gray-500">You have not uploaded any courses yet.</p>
        <%
            }
        %>
        
        <a href="instructor_dashboard.jsp" class="block text-center text-white bg-blue-500 px-4 py-2 rounded-lg mt-6">Back to Dashboard</a>
    </div>
</body>
</html>
