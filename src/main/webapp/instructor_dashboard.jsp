<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page pageEncoding="UTF-8"%>
<%@ page import="com.lms.models.User"%>
<%@ page import="javax.servlet.http.HttpSession"%>
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

response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
response.setHeader("Pragma", "no-cache");
response.setHeader("Expires", "0");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Instructor Dashboard - LMS</title>
<script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 flex flex-col min-h-screen">

	<!-- Navbar -->
	<jsp:include page="navbar.jsp" />

	<!-- Main Content -->

	<!-- Hero Section with Background Image -->
	<div class="relative h-screen  w-full">
		<!-- Background Image -->
		<img src="images/bg1.jpg" alt="background image"
			class="absolute inset-0 w-full h-full object-cover">
		<!-- Overlay -->
		<div class="absolute inset-0 "></div>
		<!-- Content -->
		<div
			class="relative h-full w-full flex flex-col items-center justify-center px-6 py-12">
			<!-- Welcome Section -->
			<div
				class="bg-white p-12 rounded-lg shadow-md text-center w-full max-w-3xl max-w-[50rem] mx-auto">
				<h1 class="text-3xl font-bold text-gray-900">
					Welcome,
					<%=user.getName()%>!
				</h1>
				<p class="text-lg text-gray-600">Your learning journey starts
					here.</p>
			</div>

			<!-- Dashboard Actions -->
			<div class="flex gap-6 pt-6 justify-between w-full max-w-[50rem]">
				<a href="add_course.jsp"
					class="bg-blue-500 text-white p-12 rounded-lg shadow-lg text-center font-semibold hover:bg-blue-600 hover:scale-105 transform transition duration-300 w-1/2">
					➕ Add New Course </a> 
					<a href="viewInstructorCourses"
					class="bg-green-500 text-white p-12 rounded-lg shadow-lg text-center font-semibold hover:bg-green-600 hover:scale-105 transform transition duration-300 w-1/2">
					📚 View & Manage Courses </a>
			</div>
		</div>
	</div>


	<!-- Footer -->
	<jsp:include page="footer.jsp" />

</body>
</html>
