<%@ page import="java.util.List" %>
<%@ page import="com.lms.controllers.ViewEnrolledStudentsServlet.EnrolledStudentInfo" %>
<%@ page import="com.lms.models.Course" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Enrolled Students</title>
    <link rel="icon" href="images/favicon.png" type="image/png"> 
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100">
    <!-- Include Navbar -->
    <jsp:include page="navbar.jsp" />

    <!-- Main Content -->
    <div class="w-full px-4 sm:px-6 md:px-12 py-6 md:py-12 flex justify-center">
        <div class="w-full max-w-4xl mx-auto min-h-[20rem] flex flex-col items-center justify-center p-4 sm:p-6 bg-white shadow-lg rounded-lg mt-4 sm:mt-10">
            <% 
            Course course = (Course) request.getAttribute("course");
            if (course != null) {
            %>
            <div class="w-full mb-6">
                <div class="flex justify-between items-center mb-4">
                    <h2 class="text-xl sm:text-2xl font-bold">Enrolled Students: <%= course.getTitle() %></h2>
                    <a href="viewInstructorCourses" class="text-blue-500 hover:underline">← Back to Courses</a>
                </div>
                <p class="text-gray-600 text-sm sm:text-base mb-4"><%= course.getDescription() %></p>
            </div>
            
            <%
            List<EnrolledStudentInfo> enrolledStudents = (List<EnrolledStudentInfo>) request.getAttribute("enrolledStudents");
            if (enrolledStudents != null && !enrolledStudents.isEmpty()) {
            %>
                <div class="w-full overflow-x-auto">
                    <table class="min-w-full bg-white border border-gray-200">
                        <thead class="bg-gray-100">
                            <tr>
                                <th class="py-3 px-4 text-left border-b">Student ID</th>
                                <th class="py-3 px-4 text-left border-b">Username</th>
                                <th class="py-3 px-4 text-left border-b">Email</th>
                                <th class="py-3 px-4 text-left border-b">Enrollment Date</th>
                                <th class="py-3 px-4 text-left border-b">Progress</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% 
                            SimpleDateFormat dateFormat = new SimpleDateFormat("dd MMM yyyy");
                            for (EnrolledStudentInfo student : enrolledStudents) {
                            %>
                            <tr class="hover:bg-gray-50">
                                <td class="py-3 px-4 border-b"><%= student.getId() %></td>
                                <td class="py-3 px-4 border-b"><%= student.getUsername() %></td>
                                <td class="py-3 px-4 border-b"><%= student.getEmail() %></td>
                                <td class="py-3 px-4 border-b"><%= dateFormat.format(student.getEnrollmentDate()) %></td>
                                <td class="py-3 px-4 border-b">
                                    <div class="w-full bg-gray-200 rounded-full h-4">
                                        <div class="bg-blue-600 h-4 rounded-full text-xs font-medium text-white text-center p-0.5 leading-none" 
                                             style="width: <%= student.getProgressPercentage() %>%">
                                            <%= student.getProgressPercentage() %>%
                                        </div>
                                    </div>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            <% } else { %>
                <p class="text-gray-500">No students are enrolled in this course yet.</p>
            <% } %>
            <% } else { %>
                <p class="text-red-500">Course not found.</p>
                <a href="instructorCourses" class="text-blue-500 hover:underline mt-4">Back to Courses</a>
            <% } %>
        </div>
    </div>

    <!-- Include Footer -->
    <jsp:include page="footer.jsp" />
</body>
</html>