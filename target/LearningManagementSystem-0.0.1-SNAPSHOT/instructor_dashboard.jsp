<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page pageEncoding="UTF-8" %>
<%@ page import="com.lms.models.User" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%
    HttpSession userSession = request.getSession(false);
    if (userSession == null || userSession.getAttribute("user") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    User user = (User) userSession.getAttribute("user");
    if (!"INSTRUCTOR".equals(user.getRole())) {
        response.sendRedirect("student_dashboard.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Instructor Dashboard</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100">
    <nav class="bg-blue-600 text-white p-4 flex justify-between">
        <h1 class="text-xl font-bold">LMS - Instructor Dashboard</h1>
        <a href="logout" class="bg-red-500 px-4 py-2 rounded">Logout</a>
    </nav>

    <div class="max-w-5xl mx-auto mt-8">
        <h2 class="text-2xl font-bold text-gray-700">Welcome, <%= user.getName() %>!</h2>

        <div class="grid grid-cols-2 gap-4 mt-6">
            <a href="add_course.jsp" class="bg-blue-500 text-white p-4 rounded-lg shadow hover:bg-blue-600">
                Add New Course
            </a>
            <a href="viewInstructorCourses" class="bg-green-500 text-white p-4 rounded-lg shadow hover:bg-green-600">
                View & Manage Courses
            </a>
        </div>
    </div>
</body>
</html>
