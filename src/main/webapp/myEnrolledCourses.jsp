<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.Map, com.lms.models.Course, com.lms.dao.MaterialProgressDAO, com.lms.models.User, com.lms.dao.FeedbackDAO, com.lms.models.Feedback" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"STUDENT".equals(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<Course> enrolledCourses = (List<Course>) request.getAttribute("enrolledCourses");
    Map<Course, Integer> courseProgressMap = (Map<Course, Integer>) request.getAttribute("courseProgressMap");
    MaterialProgressDAO materialProgressDAO = new MaterialProgressDAO();
    FeedbackDAO feedbackDAO = new FeedbackDAO();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Enrolled Courses</title>
    <link rel="icon" href="images/favicon.png" type="image/png">
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        window.addEventListener("pageshow", function(event) {
            if (event.persisted) {
                location.reload();
            }
        });

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

    <jsp:include page="navbar.jsp"/>

    <div class="max-w-3xl mx-auto bg-white p-6 rounded shadow mt-12">
        <h2 class="text-2xl font-bold">My Enrolled Courses</h2>

        <%
            if (enrolledCourses == null || enrolledCourses.isEmpty()) {
        %>
            <p class="text-red-500 mt-4">You have not enrolled in any courses yet.</p>
        <%
            } else {
                for (Course course : enrolledCourses) {
                    int progress = courseProgressMap != null && courseProgressMap.get(course) != null
                        ? courseProgressMap.get(course)
                        : materialProgressDAO.getProgressPercentage(user.getUserId(), course.getCourseId());

                    Feedback feedback = feedbackDAO.getFeedbackByStudentAndCourse(user.getUserId(), course.getCourseId());
        %>

        <div class="p-4 border rounded mt-4 course-progress" data-course-id="<%= course.getCourseId() %>">
            <h3 class="text-lg font-semibold"><%= course.getTitle() %></h3>
            <p class="text-gray-700"><%= course.getDescription() %></p>

            <p class="text-gray-600" id="progress-text-<%= course.getCourseId() %>">
                Progress: <%= progress %>%
            </p>
            <div class="w-full bg-gray-200 rounded-full h-4 mt-2">
                <div class="bg-blue-500 h-4 rounded-full"
                     id="progress-bar-<%= course.getCourseId() %>"
                     style="width: <%= progress %>%;">
                </div>
            </div>

            <a href="viewMaterials.jsp?course_id=<%= course.getCourseId() %>"
               class="text-blue-600 font-bold mt-2 inline-block">View Course Materials</a>

            <% if (feedback != null) { %>
                <p class="text-green-600 font-bold mt-2">Your Rating: <%= feedback.getRating() %>/5</p>
                <p class="text-gray-700">Feedback: <%= feedback.getCourseFeedback() %></p>
            <% } else if (progress >= 50) { %>
                <form action="give_feedback.jsp" method="get">
                    <input type="hidden" name="courseId" value="<%= course.getCourseId() %>" />
                    <button type="submit" class="mt-2 bg-blue-500 text-white px-4 py-2 rounded">
                        Give Feedback
                    </button>
                </form>
            <% } else { %>
                <button class="bg-gray-400 text-white px-4 py-2 rounded mt-2" disabled>Feedback Locked</button>
                <p class="text-red-500 text-sm mt-2">Complete at least 50% of the course to give feedback.</p>
            <% } %>
        </div>

        <%      } // end for loop
            } // end else
        %>
    </div>

</body>
</html>
