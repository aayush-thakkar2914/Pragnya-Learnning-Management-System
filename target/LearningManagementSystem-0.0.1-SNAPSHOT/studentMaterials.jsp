<%@ page import="java.util.List" %>
<%@ page import="com.lms.models.CourseMaterial" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Course Materials</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100">
    <div class="container mx-auto p-6">
        <h2 class="text-2xl font-bold text-center mb-4">Your Course Materials</h2>

        <table class="w-full bg-white shadow-md rounded-lg overflow-hidden">
            <thead class="bg-gray-200">
                <tr>
                    <th class="p-3 text-left">Material Name</th>
                    <th class="p-3 text-left">Course ID</th>
                    <th class="p-3 text-left">Uploaded At</th>
                    <th class="p-3 text-left">Download</th>
                </tr>
            </thead>
            <tbody>
                <%
                    List<CourseMaterial> materials = (List<CourseMaterial>) request.getAttribute("materials");
                    if (materials != null && !materials.isEmpty()) {
                        for (CourseMaterial material : materials) {
                %>
                <tr class="border-b">
                    <td class="p-3"><%= material.getFileName() %></td>
                    <td class="p-3"><%= material.getCourseId() %></td>
                    <td class="p-3"><%= material.getUploadedAt() %></td>
                    <td class="p-3">
                        <a href="<%= material.getFilePath() %>" class="text-blue-500 underline" target="_blank">Download</a>
                    </td>
                </tr>
                <%
                        }
                    } else {
                %>
                <tr>
                    <td colspan="4" class="p-3 text-center text-gray-600">No materials available.</td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</body>
</html>
