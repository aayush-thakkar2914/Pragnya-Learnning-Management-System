<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.lms.dao.CourseDAO, com.lms.dao.EnrollmentDAO, com.lms.models.Course, com.lms.models.User"%>

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
<body class="bg-gray-100">

    <!-- Include Navbar -->
    <jsp:include page="navbar.jsp"/>

    <!-- Main Container -->
    <div class="max-w-5xl mx-auto mt-10 p-8 bg-white shadow-lg rounded-lg">
        <h2 class="text-3xl font-bold text-gray-900 border-b-2 pb-2">📚 Available Courses</h2>

        <!-- Display Messages -->
        <% if (message != null) { %>
            <p class="text-green-600 mt-4 bg-green-100 p-2 rounded"><%= message %></p>
        <% } %>
        <% if (error != null) { %>
            <p class="text-red-600 mt-4 bg-red-100 p-2 rounded"><%= error %></p>
        <% } %>

        <!-- Course List -->
        <% if (courses.isEmpty()) { %>
            <p class="text-red-500 mt-6 text-center text-lg">⚠️ No courses available at the moment.</p>
        <% } else { %>
            <div class="flex flex-col space-y-6 mt-6">
                <% for (Course course : courses) { 
                    boolean isEnrolled = enrollmentDAO.isStudentEnrolled(user.getUserId(), course.getCourseId());
                    boolean isActive = course.isActive(); // Assuming isActive() returns true if the course is active
                %>
                <div class="bg-gray-50 p-6 rounded-lg shadow-md hover:shadow-lg transition">
                    <h3 class="text-xl font-semibold text-gray-900"><%= course.getTitle() %></h3>
                    <p class="text-gray-700 mt-2"><%= course.getDescription() %></p>

                    <!-- Course Status -->
                    <p class="font-semibold text-gray-600 mt-2">
                        <%= isActive ? "🟢 Active" : "🔴 Inactive" %>
                    </p>

                    <!-- Rating & Feedback Section -->
                    <p id="rating-<%= course.getCourseId() %>" class="font-semibold text-gray-600 mt-2">⏳ Loading rating...</p>
                    
                    <!-- Enrollment Button -->
                    <div class="flex justify-end mt-3">
                        <% if (isEnrolled) { %>
                            <button class="bg-gray-400 text-white px-5 py-2 rounded cursor-not-allowed opacity-80">✅ Enrolled</button>
                        <% } else if (!isActive) { %>
                            <button class="bg-gray-400 text-white px-5 py-2 rounded cursor-not-allowed opacity-80">❌ Enrollment Closed</button>
                        <% } else { %>
                            <form action="enrollCourse" method="post">
                                <input type="hidden" name="course_id" value="<%= course.getCourseId() %>">
                                <button type="submit" class="bg-blue-500 text-white px-5 py-2 pb-3 rounded hover:bg-blue-600 transition">
                                    🎓 Enroll Now
                                </button>
                            </form>
                        <% } %>
                    </div>
                </div>
                <% } %>
            </div>
        <% } %>
    </div>

    <!-- Include Footer -->
    <jsp:include page="footer.jsp"/>

    <script>
        window.onload = function() {
            <% for (Course course : courses) { %>
                fetchFeedback(<%= course.getCourseId() %>);
            <% } %>
        };

        function fetchFeedback(courseId) {
            fetch("feedback?courseId=" + courseId)
            .then(response => response.json())
            .then(data => {
                document.getElementById("rating-" + courseId).innerText = 
                    "⭐ Average Rating: " + data.averageRating.toFixed(1);
            })
            .catch(error => {
                console.error("Error fetching feedback:", error);
                document.getElementById("rating-" + courseId).innerText = 
                    "❌ Failed to load rating.";
            });
        }
    </script>

</body>
</html>
