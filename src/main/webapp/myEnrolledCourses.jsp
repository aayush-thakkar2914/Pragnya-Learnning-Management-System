<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.lms.models.Course, com.lms.dao.MaterialProgressDAO, com.lms.models.User, com.lms.dao.FeedbackDAO, com.lms.models.Feedback" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"STUDENT".equals(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<Course> enrolledCourses = (List<Course>) request.getAttribute("enrolledCourses");
    MaterialProgressDAO materialProgressDAO = new MaterialProgressDAO();
    FeedbackDAO feedbackDAO = new FeedbackDAO();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Enrolled Courses</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        // Force reload when user navigates back from viewMaterials.jsp
        window.addEventListener("pageshow", function(event) {
            if (event.persisted) {
                location.reload();
            }
        });

        // Fetch and update progress dynamically when the page loads
        function updateProgress(courseId, userId) {
            fetch(`getProgressServlet?courseId=${courseId}&userId=${userId}`)
                .then(response => response.json())
                .then(data => {
                    let progressBar = document.getElementById(`progress-bar-${courseId}`);
                    let progressText = document.getElementById(`progress-text-${courseId}`);
                    if (progressBar && progressText) {
                        progressBar.style.width = data.progress + "%";
                        progressText.innerText = "Progress: " + data.progress + "%";
                    }
                })
                .catch(error => console.error("Error fetching progress:", error));
        }

        // Call updateProgress for each enrolled course
        window.onload = function() {
            let courses = document.querySelectorAll(".course-progress");
            courses.forEach(course => {
                let courseId = course.getAttribute("data-course-id");
                let userId = "<%= user.getUserId() %>";
                updateProgress(courseId, userId);
            });
        };
    </script>
</head>
<body class="bg-gray-100">

    <!-- Include Navbar -->
    <jsp:include page="navbar.jsp"/>

    <!-- Main Content -->
    <div class="max-w-3xl mx-auto bg-white p-6 rounded shadow mt-12">
        <h2 class="text-2xl font-bold">My Enrolled Courses</h2>
        <%
            if (enrolledCourses == null || enrolledCourses.isEmpty()) {
                out.println("<p class='text-red-500 mt-4'>You have not enrolled in any courses yet.</p>");
            } else {
                for (Course course : enrolledCourses) {
                    int progress = materialProgressDAO.getProgressPercentage(user.getUserId(), course.getCourseId());
                    Feedback feedback = feedbackDAO.getFeedbackByStudentAndCourse(user.getUserId(), course.getCourseId());
        %>
        <div class="p-4 border rounded mt-4 course-progress" data-course-id="<%= course.getCourseId() %>">
            <h3 class="text-lg font-semibold"><%= course.getTitle() %></h3>
            <p class="text-gray-700"><%= course.getDescription() %></p>

            <!-- Progress Display -->
            <p class="text-gray-600" id="progress-text-<%= course.getCourseId() %>">
                Progress: <%= progress %>%
            </p>
            <div class="w-full bg-gray-200 rounded-full h-4 mt-2">
                <div class="bg-blue-500 h-4 rounded-full"
                    id="progress-bar-<%= course.getCourseId() %>"
                    style="width: <%= progress %>%;"></div>
            </div>

            <a href="viewMaterials.jsp?course_id=<%= course.getCourseId() %>"
                class="text-blue-600 font-bold mt-2 inline-block"> View Course Materials </a>
            <% if (feedback != null) { %>
                <p class="text-green-600 font-bold mt-2">Your Rating: <%= feedback.getRating() %>/5</p>
                <p class="text-gray-700">Feedback: <%= feedback.getCourseFeedback() %></p>
            <% } else { %>
                <a href="give_feedback.jsp?courseId=<%= course.getCourseId() %>" 
                   class="bg-blue-500 text-white px-4 py-2 rounded mt-2 inline-block">
                    Give Feedback
                </a>
            <% } %>
            
        </div>
        <%
                }
            }
        %>
        
        <a href="student_dashboard.jsp" class="block mt-6 text-white bg-blue-500 px-4 py-2 rounded-lg text-center hover:bg-blue-600 transition">
            Back to Dashboard
        </a>
    </div>

    <!-- Include Footer -->
    <jsp:include page="footer.jsp"/>
</body>
</html>
