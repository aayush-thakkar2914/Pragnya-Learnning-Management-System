<%@ page
	import="java.sql.*, java.util.*, com.lms.models.Course, com.lms.utils.DatabaseConnection"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page language="java"%>

<%
// Get courseId from URL
String courseId = request.getParameter("courseId");
if (courseId == null) {
	response.sendRedirect("instructorCourses.jsp"); // Redirect if no courseId
	return;
}

// Check if delete action is requested
String deleteFile = request.getParameter("deleteFile");
if (deleteFile != null && !deleteFile.isEmpty()) {
    Connection deleteConn = DatabaseConnection.getConnection();
    String deleteQuery = "DELETE FROM course_materials WHERE course_id = ? AND file_name = ?";
    PreparedStatement deleteStmt = deleteConn.prepareStatement(deleteQuery);
    deleteStmt.setInt(1, Integer.parseInt(courseId));
    deleteStmt.setString(2, deleteFile);
    deleteStmt.executeUpdate();
    deleteConn.close();
    
    // Redirect back to the same page to refresh content
    response.sendRedirect("courseDetails.jsp?courseId=" + courseId);
    return;
}

// Database Connection
Connection conn = DatabaseConnection.getConnection();

// Fetch Course Details
String query = "SELECT title, description FROM courses WHERE course_id = ?";
PreparedStatement stmt = conn.prepareStatement(query);
stmt.setInt(1, Integer.parseInt(courseId));
ResultSet rs = stmt.executeQuery();

String courseName = "";
String description = "";
if (rs.next()) {
	courseName = rs.getString("title");
	description = rs.getString("description");
}

// Fetch Average Rating
String ratingQuery = "SELECT AVG(rating) as avg_rating FROM feedback WHERE course_id = ?";
stmt = conn.prepareStatement(ratingQuery);
stmt.setInt(1, Integer.parseInt(courseId));
rs = stmt.executeQuery();

double avgRating = 0.0;
if (rs.next()) {
	avgRating = rs.getDouble("avg_rating");
}

// Fetch Uploaded Materials
List<String> materials = new ArrayList<>();
String materialQuery = "SELECT file_name FROM course_materials WHERE course_id = ?";
stmt = conn.prepareStatement(materialQuery);
stmt.setInt(1, Integer.parseInt(courseId));
rs = stmt.executeQuery();

while (rs.next()) {
	materials.add(rs.getString("file_name"));
}

conn.close();
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Course Details - LMS</title>
<link rel="icon" href="images/favicon.png" type="image/png"> 
<script src="https://cdn.tailwindcss.com"></script>
<style>
    /* New improved file card styles */
    .file-card {
        position: relative;
        display: flex;
        flex-direction: column;
        height: 100%;
    }
    
    .file-icon-container {
        display: flex;
        justify-content: center;
        margin-bottom: 0.75rem;
    }
    
    .file-name-container {
        flex: 1;
        display: flex;
        align-items: center;
        justify-content: center;
        padding: 0 0.5rem;
        margin-bottom: 0.75rem;
    }
    
    .file-name {
        text-align: center;
        font-size: 0.75rem;
        line-height: 1rem;
        max-height: 3rem; /* Limit to ~3 lines */
        overflow: hidden;
        display: -webkit-box;
        -webkit-line-clamp: 3;
        -webkit-box-orient: vertical;
        word-break: break-word;
        hyphens: auto;
    }
    
    .action-container {
        margin-top: auto;
        width: 100%;
    }
    
    /* Tooltip for full filename on hover */
    .tooltip {
        position: relative;
        display: inline-block;
        width: 100%;
    }
    
    .tooltip .tooltip-text {
        visibility: hidden;
        width: 200px;
        background-color: rgba(0, 0, 0, 0.8);
        color: white;
        text-align: center;
        border-radius: 6px;
        padding: 5px;
        position: absolute;
        z-index: 1;
        bottom: 125%;
        left: 50%;
        transform: translateX(-50%);
        opacity: 0;
        transition: opacity 0.3s;
        font-size: 12px;
        word-break: break-all;
    }
    
    .tooltip:hover .tooltip-text {
        visibility: visible;
        opacity: 1;
    }
</style>
</head>
<body class="bg-gray-100 flex flex-col min-h-screen">

	<!-- Navbar -->
	<jsp:include page="navbar.jsp" />

	<!-- Main Content -->
	<!-- Course Header -->
<!-- Course Info Container -->
<div class="bg-white shadow-lg rounded-lg p-6 w-full max-w-[90%] mx-auto mt-9 border border-gray-200 flex flex-row items-center justify-between">
    <div class="flex-1 pr-6"> <!-- Added padding to keep space from rating -->
        <h1 class="text-xl md:text-3xl font-bold text-gray-800 mb-2"><%= courseName %></h1>
        <p class="text-base text-gray-600"><%= description %></p>
    </div>
    
    <!-- Rating on the Right -->
    <div class="flex items-center gap-2 text-xl font-semibold text-yellow-500 whitespace-nowrap">
        <span>⭐</span>
        <span><%= avgRating == 0.0 ? "No ratings yet" : String.format("%.1f", avgRating) %></span>
    </div>
</div>

<!-- Section Title -->
<h2 class="text-2xl font-bold mt-10 mb-6 text-gray-800 border-b-2 border-gray-300 pt-2 pb-2 w-fit mx-auto">
    📂 Uploaded Materials
</h2>

<!-- File Uploads Container -->
<div class="flex justify-center px-6 lg:px-16">
    <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-5 gap-6 w-full max-w-6xl text-center">
        <%
        if (materials.isEmpty()) {
        %>
        <p class="text-gray-500 col-span-5 text-center text-lg">No materials uploaded yet.</p>
        <%
        } else {
        for (String file : materials) {
            String fileExtension = file.substring(file.lastIndexOf(".") + 1).toLowerCase();
            String fileIcon = "images/new-document.png"; // Default icon

            // Set icons based on file type
            if (fileExtension.equals("pdf"))
                fileIcon = "images/pdf-icon.png";
            else if (fileExtension.equals("doc") || fileExtension.equals("docx"))
                fileIcon = "images/word-icon.png";
            else if (fileExtension.equals("ppt") || fileExtension.equals("pptx"))
                fileIcon = "images/ppt-icon.png";
            else if (fileExtension.equals("zip") || fileExtension.equals("rar"))
                fileIcon = "images/zip-icon.png";
            else if (fileExtension.equals("jpg") || fileExtension.equals("jpeg") || fileExtension.equals("png"))
                fileIcon = "uploads/" + file; // Show actual image
                
            // Create a display name - truncate if necessary
            String displayName = file;
            if (displayName.length() > 30) {
                // Try to find a smart truncation point (after a dot or underscore)
                int dotIndex = displayName.lastIndexOf(".");
                int underscoreIndex = displayName.lastIndexOf("_");
                int dashIndex = displayName.lastIndexOf("-");
                
                int breakPoint = Math.max(Math.max(dotIndex, underscoreIndex), dashIndex);
                
                if (breakPoint > 10 && breakPoint < displayName.length() - 5) {
                    // Use the found breaking point if it's in a reasonable position
                    displayName = displayName.substring(0, 10) + "..." + displayName.substring(breakPoint);
                } else {
                    // Just do a simple truncation
                    displayName = displayName.substring(0, 15) + "..." + 
                                 displayName.substring(displayName.length() - 10);
                }
            }
        %>
        <!-- File Card -->
        <div class="bg-white shadow-md rounded-lg p-4 border border-gray-200 hover:shadow-lg transition w-full h-56 file-card">
            <a href="uploads/<%= file %>" target="_blank" class="flex flex-col items-center h-full">
                <div class="file-icon-container">
                    <img src="<%= fileIcon %>" alt="<%= file %>" class="w-16 h-16 object-cover rounded">
                </div>
                <div class="file-name-container tooltip">
                    <p class="file-name text-gray-700 font-medium"><%= displayName %></p>
                    <span class="tooltip-text"><%= file %></span>
                </div>
            </a>
            <!-- Delete Button -->
            <div class="action-container">
                <a href="courseDetails.jsp?courseId=<%= courseId %>&deleteFile=<%= file %>" 
                   onclick="return confirm('Are you sure you want to delete this material?')" 
                   class="bg-red-500 text-white px-4 py-1 rounded text-sm w-full inline-block hover:bg-red-600 transition">
                    Delete
                </a>
            </div>
        </div>
        <%
        }
        }
        %>
    </div>
</div>

	<div class="flex justify-center mt-6">
		<a href="viewInstructorCourses"
			class="bg-sky-200 text-black hover:bg-blue-600 hover:text-white px-4 py-2 rounded-lg hover:bg-blue-700 mb-4">
			Back to Courses </a>
	</div>
	</div>
	</div>

	<!-- Footer -->
	<jsp:include page="footer.jsp" />

</body>
</html>