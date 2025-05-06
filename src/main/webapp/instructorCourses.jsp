<%@ page import="java.util.List"%>
<%@ page import="com.lms.models.Course"%>
<%@ page import="com.lms.models.User"%>
<%@ page import="javax.servlet.http.HttpSession"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
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
<title>My Courses</title>
<link rel="icon" href="images/favicon.png" type="image/png"> 
<script src="https://cdn.tailwindcss.com"></script>
<style>
.popup {
	display: none;
	position: fixed;
	top: 20px;
	right: 20px;
	background-color: #4CAF50;
	color: white;
	padding: 16px;
	border-radius: 5px;
	box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
	z-index: 1000;
	animation: slideIn 0.5s;
}

@keyframes slideIn {
	from {transform: translateX(100%);
	opacity: 0;
}

to {
	transform: translateX(0);
	opacity: 1;
}
}

/* Toggle Switch Styles */
.toggle-switch {
  position: relative;
  display: inline-block;
  width: 50px;
  height: 24px;
}

.toggle-switch input {
  opacity: 0;
  width: 0;
  height: 0;
}

.slider {
  position: absolute;
  cursor: pointer;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: #ccc;
  transition: .3s;
  border-radius: 24px;
}

.slider:before {
  position: absolute;
  content: "";
  height: 18px;
  width: 18px;
  left: 3px;
  bottom: 3px;
  background-color: white;
  transition: .3s;
  border-radius: 50%;
}

input:checked + .slider {
  background-color: #4CAF50;
}

input:focus + .slider {
  box-shadow: 0 0 1px #4CAF50;
}

input:checked + .slider:before {
  transform: translateX(26px);
}

.slider-text {
  margin-left: 8px;
  font-size: 14px;
  font-weight: 500;
}

.status-active {
  color: #4CAF50;
}

.status-inactive {
  color: #888;
}
</style>
</head>
<body class="bg-gray-100">
	<!-- Include Navbar -->
	<jsp:include page="navbar.jsp" />

	<!-- Success Popup -->
	<div id="successPopup" class="popup">
		<div class="flex items-center">
			<svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 mr-2"
				fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round"
					stroke-width="2" d="M5 13l4 4L19 7" />
        </svg>
			<span id="popupMessage">Material uploaded successfully!</span>
		</div>
	</div>

	<!-- Error Popup -->
	<div id="errorPopup" class="popup" style="background-color: #f44336;">
		<div class="flex items-center">
			<svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 mr-2"
				fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round"
					stroke-width="2" d="M6 18L18 6M6 6l12 12" />
        </svg>
			<span id="errorMessage">Error occurred!</span>
		</div>
	</div>

	<!-- Main Content -->
	<div
		class="w-full px-4 sm:px-6 md:px-12 py-6 md:py-12 flex justify-center">
		<div
			class="w-full max-w-3xl mx-auto min-h-[20rem] flex flex-col items-center justify-center p-4 sm:p-6 bg-white shadow-lg rounded-lg mt-4 sm:mt-10">
			<h2 class="text-xl sm:text-2xl font-bold mb-4">My Uploaded
				Courses</h2>
			<% List<Course> instructorCourses = (List<Course>) request.getAttribute("instructorCourses");
        if (instructorCourses != null && !instructorCourses.isEmpty()) {
            for (Course course : instructorCourses) { %>

			<div class="w-full p-4 mb-4 border rounded-lg shadow-sm bg-gray-50">
				<div class="flex justify-between items-center">
				    <h3 class="text-lg sm:text-xl font-semibold text-gray-900"><%=course.getTitle()%></h3>
				    <!-- Toggle Switch at top where status was -->
				    <div class="flex items-center">
				        <label class="toggle-switch">
				            <input type="checkbox" id="toggle-<%=course.getCourseId()%>" 
				                   <%= course.isActive() ? "checked" : "" %> 
				                   onchange="toggleCourseStatus(<%=course.getCourseId()%>, this.checked)">
				            <span class="slider"></span>
				        </label>
				        <span class="slider-text <%= course.isActive() ? "status-active" : "status-inactive" %>" 
				              id="status-text-<%=course.getCourseId()%>">
				            <%= course.isActive() ? "Active" : "Inactive" %>
				        </span>
				    </div>
				</div>
				<p class="text-gray-600 text-sm sm:text-base"><%=course.getDescription()%></p>
				<a href="courseDetails.jsp?courseId=<%=course.getCourseId()%>"
					class="text-blue-500 text-sm sm:text-base">View Details</a>

				<div
					class="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4 mt-4">
					<form action="uploadMaterial" method="post"
						enctype="multipart/form-data"
						class="flex flex-col sm:flex-row items-start sm:items-center gap-2 w-full sm:w-auto">
						<input type="hidden" name="courseId"
							value="<%=course.getCourseId()%>"> <input type="file"
							name="file" required
							class="border p-2 rounded w-full sm:w-auto text-sm">
						<button type="submit"
							class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600 transition w-full sm:w-auto mt-2 sm:mt-0">
							Upload Material</button>
					</form>
					<div class="flex gap-2 items-center">
					    <a href="viewEnrolledStudents?courseId=<%=course.getCourseId()%>"
						    class="bg-green-500 text-white px-4 py-2 rounded hover:bg-green-600 transition">
						    View Enrolled Students
					    </a>
					</div>
					<form action="deleteCourse" method="post" class="w-full sm:w-auto">
						<input type="hidden" name="courseId"
							value="<%=course.getCourseId()%>">
						<button type="submit"
							class="bg-red-500 text-white px-4 py-2 rounded hover:bg-red-600 transition w-full">
							Delete Course</button>
					</form>
				</div>
			</div>
			<% } } else { %>
			<p class="text-gray-500">You have not uploaded any courses yet.</p>
			<% } %>
			<a href="instructor_dashboard.jsp"
				class="block text-center text-white bg-blue-500 w-full max-w-xs px-4 py-2 rounded-lg mt-6 hover:bg-blue-600 transition">
				Back to Dashboard </a>
		</div>
	</div>

	<!-- Include Footer -->
	<jsp:include page="footer.jsp" />

	<script>
    // Function to toggle course status
    function toggleCourseStatus(courseId, isActive) {
        // Update the status text while the request is being processed
        const statusText = document.getElementById('status-text-' + courseId);
        statusText.textContent = isActive ? 'Active' : 'Inactive';
        
        // Update the class for color
        if (isActive) {
            statusText.classList.remove('status-inactive');
            statusText.classList.add('status-active');
        } else {
            statusText.classList.remove('status-active');
            statusText.classList.add('status-inactive');
        }
        
        // Create and submit form programmatically
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = 'toggleCourseStatus';
        form.style.display = 'none';
        
        const courseIdInput = document.createElement('input');
        courseIdInput.type = 'hidden';
        courseIdInput.name = 'courseId';
        courseIdInput.value = courseId;
        
        const activeInput = document.createElement('input');
        activeInput.type = 'hidden';
        activeInput.name = 'active';
        activeInput.value = isActive;
        
        form.appendChild(courseIdInput);
        form.appendChild(activeInput);
        document.body.appendChild(form);
        form.submit();
    }
    
    // Function to display success popup - executes on page load
    document.addEventListener('DOMContentLoaded', function() {
        // Check for success parameter from either URL or request attribute
        <% if(request.getParameter("uploadSuccess") != null || request.getAttribute("uploadSuccess") != null) { %>
            console.log("Success detected - showing popup");
            const popup = document.getElementById('successPopup');
            document.getElementById('popupMessage').textContent = "Material uploaded successfully!";
            popup.style.display = 'block';
            
            // Hide popup after 3 seconds
            setTimeout(function() {
                popup.style.display = 'none';
                
                // Clean the URL by removing the query parameter if it exists
                if(window.location.search) {
                    const url = window.location.href.split('?')[0];
                    window.history.replaceState({}, document.title, url);
                }
            }, 3000);
        <% } %>
        
        <% if(request.getParameter("statusSuccess") != null) { %>
            console.log("Status change detected - showing popup");
            const popup = document.getElementById('successPopup');
            document.getElementById('popupMessage').textContent = "Course status updated successfully!";
            popup.style.display = 'block';
            
            // Hide popup after 3 seconds
            setTimeout(function() {
                popup.style.display = 'none';
                
                // Clean the URL by removing the query parameter if it exists
                if(window.location.search) {
                    const url = window.location.href.split('?')[0];
                    window.history.replaceState({}, document.title, url);
                }
            }, 3000);
        <% } %>
        
        <% if(request.getParameter("error") != null) { %>
            console.log("Error detected - showing popup");
            const popup = document.getElementById('errorPopup');
            document.getElementById('errorMessage').textContent = "<%= request.getParameter("error") %>";
            popup.style.display = 'block';
            
            // Hide popup after 4 seconds
            setTimeout(function() {
                popup.style.display = 'none';
                
                // Clean the URL by removing the query parameter if it exists
                if(window.location.search) {
                    const url = window.location.href.split('?')[0];
                    window.history.replaceState({}, document.title, url);
                }
            }, 4000);
        <% } %>
    });
</script>

</body>
</html>