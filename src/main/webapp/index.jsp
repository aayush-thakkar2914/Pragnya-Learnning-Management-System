<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>PRAGNYA </title>
    <link rel="icon" href="images/favicon.png" type="image/png"> 

<script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-white">

    <!-- Include Navbar -->
    <jsp:include page="navbar.jsp" />

    <!-- Hero Section -->
    <div class="h-full flex flex-col md:flex-row items-center px-12 py-6 relative">
        <div class="w-full md:w-1/2 h-full flex justify-center items-center">
            <img src="images/dashboard_below_navbar.jpeg"
                alt="Learning Illustration"
                class="max-w-full max-h-[80%] object-contain">
        </div>
        <div
            class="w-full md:w-1/2 flex flex-col justify-center text-gray-800 text-left px-8 pt-8 md:pt-0">
            <h1 class="text-3xl md:text-4xl font-extrabold tracking-wide">
                Welcome to <span class="text-gray-900">PRAGNYA Online Course
                    Management System</span>
            </h1>
            <p class="mt-4 text-lg md:text-xl leading-relaxed">Manage your
                courses, access lectures, and engage in interactive learning!</p>
            <h2 class="text-3xl md:text-4xl font-semibold mt-6">Your
                Learning Hub</h2>
            <p class="mt-4 text-lg md:text-xl leading-relaxed">Join now to
                start your learning journey.</p>
        </div>
    </div>

    <%
        // Get session and user role
        HttpSession sessionObj = request.getSession(false);
        String userRole = (sessionObj != null && sessionObj.getAttribute("role") != null) 
                            ? (String) sessionObj.getAttribute("role") 
                            : null;

        // Variables for dashboard and courses
        String dashboardUrl = "";
        String coursesLabel = "";
        String coursesUrl = "";

        if (userRole == null) {
            // User is not logged in, show login/signup buttons
    %>
    <div class="bg-yellow-100 py-12">
        <div class="container mx-auto text-center px-4">
            <h2 class="text-3xl font-bold text-black mb-4">Ready to get started?</h2>
            <p class="text-black-100 mb-8 max-w-2xl mx-auto">Join thousands of students and instructors using our platform.</p>
            <a href="login.jsp" class="bg-white text-blue-600 px-6 py-3 rounded-md font-semibold hover:bg-gray-100 transition">Login</a> 
            | 
            <a href="signup.jsp" class="bg-white text-blue-600 px-6 py-3 rounded-md font-semibold hover:bg-gray-100 transition">Sign Up</a>
        </div>
    </div>
    <%
        } else {
            // User is logged in, set appropriate URLs
            dashboardUrl = userRole.equals("INSTRUCTOR") ? "instructor_dashboard.jsp" : "student_dashboard.jsp";
            coursesLabel = userRole.equals("INSTRUCTOR") ? "Manage Your Courses" : "Go to Courses";
            coursesUrl = userRole.equals("INSTRUCTOR") ? "viewInstructorCourses" : "courses.jsp";
    %>

    <div class="bg-yellow-100 py-12">
        <div class="container mx-auto text-center px-4">
            <h2 class="text-3xl font-bold text-black mb-4">Welcome Back!</h2>
            <p class="text-black-100 mb-8 max-w-2xl mx-auto">
                Continue your learning journey with our latest courses and resources.
            </p>
            <div class="flex justify-center gap-4">
                <a href="<%= dashboardUrl %>"
                    class="bg-white text-blue-600 px-6 py-3 rounded-md font-semibold hover:bg-gray-100 transition">
                    Go to Dashboard
                </a>
                <a href="<%= coursesUrl %>"
                    class="bg-white text-blue-600 px-6 py-3 rounded-md font-semibold hover:bg-gray-100 transition">
                    <%= coursesLabel %>
                </a>
            </div>
        </div>
    </div>

    <%
        } // End of if-else
    %>

    <!-- Include Footer -->
    <jsp:include page="footer.jsp" />

</body>
</html>
