<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.lms.dao.CourseMaterialDAO, com.lms.models.CourseMaterial, com.lms.models.User"%>
<%
User user = (User) session.getAttribute("user");
if (user == null || !"STUDENT".equals(user.getRole())) {
    response.sendRedirect("login.jsp");
    return;
}

int courseId = -1;
try {
    courseId = Integer.parseInt(request.getParameter("course_id"));
} catch (Exception e) {
    response.sendRedirect("courses.jsp");
    return;
}

CourseMaterialDAO materialDAO = new CourseMaterialDAO();
List<CourseMaterial> materials = materialDAO.getMaterialsByCourse(courseId, user.getUserId());
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Course Materials | Pragnya</title>
    <link rel="icon" href="images/favicon.png" type="image/png"> 
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body class="bg-gray-100 flex flex-col min-h-screen">
    <!-- Navbar -->
    <jsp:include page="navbar.jsp" />

    <!-- Main Content -->
    <div class="flex-grow flex items-center justify-center p-10">
        <div class="bg-white rounded-lg shadow-lg w-3/4 p-8">
            <h2 class="text-2xl font-bold text-center mb-4  decoration-sky-500 ">📚 Course Materials</h2>

            <% if (materials != null && !materials.isEmpty()) { %>
            <div class="overflow-x-auto mt-4">
                <table class="w-full border-collapse border border-gray-300">
                    <thead class="bg-sky-200 text-black">
                        <tr>
                            <th class="border border-gray-300 px-4 py-2 text-left">📂 File Name</th>
                            <th class="border border-gray-300 px-4 py-2 text-center">⬇ Download</th>
                            <th class="border border-gray-300 px-4 py-2 text-center">✅ Completed</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (CourseMaterial material : materials) { %>
                        <tr class="hover:bg-gray-100 hover:shadow-sm">
                            <td class="border border-gray-300 px-4 py-2"><%= material.getFileName() %></td>
                            <td class="border border-gray-300 px-4 py-2 text-center">
                                <a href="<%= material.getFilePath() %>" download 
                                   class="bg-sky-200 text-black px-4 py-2 rounded hover:bg-blue-600 hover:text-white">
                                   Download
                                </a>
                            </td>
                            <td class="border border-gray-300 px-4 py-2 text-center">
                                <input type="checkbox" class="progress-checkbox w-5 h-5" 
                                       data-userid="<%= user.getUserId() %>" 
                                       data-materialid="<%= material.getMaterialId() %>"
                                       <%= material.isCompleted() ? "checked" : "" %> 
                                       onchange="updateProgress(this)">
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>

            <div class="mt-6 text-center">
                <a href="myEnrolledCourses" 
                   class="bg-sky-200 text-black px-6 py-2 rounded hover:bg-blue-600 hover:text-white">
                   Back to Courses
                </a>
            </div>
            <% } else { %>
            <div class="text-gray-600 text-center p-10">
                <p class="mb-6">No course materials available.</p>
                <a href="student_dashboard.jsp" 
                   class="bg-sky-200 text-black px-6 py-2 rounded hover:bg-blue-600 hover:text-white">
                   Back to Dashboard
                </a>
            </div>
            <% } %>
        </div>
    </div>

    <!-- Footer -->
    <jsp:include page="footer.jsp" />

    <script>
        function updateProgress(checkbox) {
            let userId = checkbox.getAttribute("data-userid");
            let materialId = checkbox.getAttribute("data-materialid");
            let completed = checkbox.checked;

            $.ajax({
                url: "updateProgress",
                type: "POST",
                data: { userId: userId, materialId: materialId, completed: completed },
                dataType: "json",
                success: function(response) {
                    if (!response.success) {
                        alert("Failed to update progress.");
                        checkbox.checked = !completed; // Revert checkbox state on failure
                    }
                },
                error: function() {
                    alert("An error occurred while updating progress.");
                    checkbox.checked = !completed; // Revert checkbox state on error
                }
            });
        }
    </script>
</body>
</html>