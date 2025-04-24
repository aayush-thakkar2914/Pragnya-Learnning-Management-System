<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page
	import="java.util.List, com.lms.dao.CourseMaterialDAO, com.lms.models.CourseMaterial, com.lms.models.User"%>
<%
// Check if the user is logged in as a student
User user = (User) session.getAttribute("user");
if (user == null || !"STUDENT".equals(user.getRole())) {
    response.sendRedirect("login.jsp");
    return;
}

// Get course_id from request
int courseId = -1;
try {
    courseId = Integer.parseInt(request.getParameter("course_id"));
    
} catch (Exception e) {
    response.sendRedirect("courses.jsp"); // Redirect if invalid course_id
    return;
}

// Fetch course materials for the selected course
CourseMaterialDAO materialDAO = new CourseMaterialDAO();
List<CourseMaterial> materials = materialDAO.getMaterialsByCourse(courseId, user.getUserId());
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Course Materials</title>
<script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100">
	<!-- Navbar -->
	<nav class="bg-blue-600 p-4 flex justify-between items-center">
		<h1 class="text-white text-2xl font-bold">LMS - Course Materials</h1>
		<a href="student_dashboard.jsp"
			class="bg-gray-500 hover:bg-gray-600 text-white px-4 py-2 rounded">Back
			to Dashboard</a>
	</nav>

	<div class="max-w-4xl mx-auto mt-8 p-6 bg-white shadow-lg rounded-lg">
		<h2 class="text-2xl font-semibold text-gray-800 mb-4">📚 Course
			Materials</h2>

		<% if (materials != null && !materials.isEmpty()) { %>
		<div class="overflow-x-auto mt-4">
			<table class="w-full border-collapse border border-gray-300">
				<thead class="bg-blue-500 text-white">
					<tr>
						<th class="border border-gray-300 px-4 py-2 text-left">📂
							File Name</th>
						<th class="border border-gray-300 px-4 py-2 text-center">⬇
							Download</th>
						<th class="border border-gray-300 px-4 py-2 text-center">✅
							Completed</th>
					</tr>
				</thead>
				<tbody>
					<% for (CourseMaterial material : materials) { %>
					<tr class="bg-gray-100 hover:bg-gray-200">
						<td class="border border-gray-300 px-4 py-2"><%= material.getFileName() %></td>
						<td class="border border-gray-300 px-4 py-2 text-center"><a
							href="<%= material.getFilePath() %>" download
							class="bg-green-500 hover:bg-green-600 text-white px-4 py-2 rounded">Download</a>
						</td>
						<td class="border border-gray-300 px-4 py-2 text-center">
							<form action="updateProgress" method="post">
								<input type="hidden" name="userId"
									value="<%= user.getUserId() %>"> <input type="hidden"
									name="materialId" value="<%= material.getMaterialId() %>">

								<input type="hidden" name="completed" class="completedInput"
									value="<%= material.isCompleted() %>"> <input
									type="checkbox" class="progress-checkbox"
									<%= material.isCompleted() ? "checked" : "" %>
									onchange="updateProgress(this)">
							</form>
						</td>
					</tr>
					<% } %>
				</tbody>
			</table>
		</div>
		<% } else { %>
		<p class="text-gray-600 text-center mt-4">No course materials
			available.</p>
		<% } %>
	</div>

	<!-- JavaScript to handle progress update -->
	<script>
    function updateProgress(checkbox) {
        let form = checkbox.closest("form");
        let completedInput = form.querySelector(".completedInput");
        completedInput.value = checkbox.checked ? "true" : "false";
        form.submit();
    }
    </script>
</body>
</html>
