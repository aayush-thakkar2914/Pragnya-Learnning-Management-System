<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page pageEncoding="UTF-8" %>
<%@ page import="com.lms.models.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"INSTRUCTOR".equals(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Add Course</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 p-6">
    <div class="max-w-lg mx-auto bg-white p-6 rounded shadow">
        <h2 class="text-2xl font-bold">Add New Course</h2>
        <form action="uploadCourse" method="post" class="mt-4">
            <label class="block font-semibold">Course Title</label>
            <input type="text" name="title" class="w-full p-2 border rounded mt-1" required>

            <label class="block font-semibold mt-4">Description</label>
            <textarea name="description" class="w-full p-2 border rounded mt-1" required></textarea>

            <button type="submit" class="bg-blue-500 text-white px-4 py-2 rounded mt-4">Upload Course</button>
        </form>
    </div>
</body>
</html>
