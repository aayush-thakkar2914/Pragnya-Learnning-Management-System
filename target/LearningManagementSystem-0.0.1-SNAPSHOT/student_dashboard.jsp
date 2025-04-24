<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*, java.util.*"%>

<%@ page import="com.lms.dao.UserDAO, com.lms.models.User"%>

<%
    // Session Management
    HttpSession sessionObj = request.getSession(false);
    if (sessionObj == null || sessionObj.getAttribute("user") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Retrieve User Info
    User user = (User) sessionObj.getAttribute("user");
    String username = String.valueOf(user.getUserId());
    String email = user.getEmail();

    // Database connection
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    List<String> courses = new ArrayList<>();

    try {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XEPDB1", "lms", "root");

        String sql = "SELECT course_name FROM enrolled_courses WHERE user_id = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, user.getUserId());
        rs = pstmt.executeQuery();

        while (rs.next()) {
            courses.add(rs.getString("course_name"));
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) rs.close();
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Dashboard - Pragnya</title>
<script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100">
	<nav class="bg-blue-600 p-4 shadow-md text-white flex justify-between">
		<h1 class="text-2xl font-bold">
			Welcome,
			<%= username %>!
		</h1>
		<a href="LogoutServlet"
			class="bg-red-500 px-4 py-2 rounded-lg hover:bg-red-600">Logout</a>
	</nav>

	<div class="container mx-auto mt-6 p-6 bg-white shadow-lg rounded-lg">
		<h2 class="text-xl font-semibold mb-4">Your Enrolled Courses</h2>
		<div class="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
			<% if (courses.isEmpty()) { %>
			<p class="text-gray-700">You have not enrolled in any courses
				yet.</p>
			<% } else { 
                for (String course : courses) { %>
			<div
				class="bg-gray-50 p-4 rounded-lg shadow flex flex-col md:flex-row items-center">
				<img alt="Course Image"
					class="w-32 h-32 object-cover mb-4 md:mb-0 md:mr-4"
					src="images/course-placeholder.jpg" width="200" height="200" />
				<div class="flex-1 text-center md:text-left">
					<h3 class="text-xl font-semibold mb-2"><%= course %></h3>
					<button
						class="bg-blue-500 text-white px-4 py-2 rounded-lg hover:bg-blue-600">
						View Course</button>
				</div>
			</div>
			<%  } 
            } %>
		</div>
	</div>
</body>
</html>
