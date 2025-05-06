<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%
response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1
response.setHeader("Pragma", "no-cache"); // HTTP 1.0
response.setHeader("Expires", "0"); // Proxies

// Invalidate session if user is returning to login page
if (session != null) {
    session.invalidate();
}
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - LMS</title>
    <link rel="icon" href="images/favicon.png" type="image/png"> 
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 flex flex-col min-h-screen">

    <!-- Navbar -->
    <jsp:include page="navbar.jsp" />

    <!-- Main Content -->
    <div class="flex-grow flex items-center justify-center p-10">
        <div class="bg-white rounded-lg shadow-lg w-full md:w-3/4 flex flex-col md:flex-row items-center p-8">

            <!-- Left Side Graphic -->
            <div class="w-1/2">
                <img src="images/loginSide.jpeg" alt="Login Illustration" class="w-full h-auto">
            </div>

            <!-- Right Side Form -->
            <div class="w-1/2 p-6">
                <h2 class="text-xl md:text-2xl font-bold text-center mb-4">Login</h2>

                <%-- Show error message if present --%>
                <% if (request.getParameter("error") != null) { %>
                    <p class="text-red-500 text-sm text-center"><%= request.getParameter("error") %></p>
                <% } %>

                <form action="login" method="post" class="space-y-4">
                    <div>
                        <label class="block text-sm font-medium">Email</label>
                        <input type="email" name="email" required class="w-full p-2 border rounded hover:bg-gray-100 hover:shadow-sm">
                    </div>
                    <div>
                        <label class="block text-sm font-medium">Password</label>
                        <input type="password" name="password" required class="w-full p-2 border rounded hover:bg-gray-100 hover:shadow-sm">
                    </div>
                    <button type="submit" class="w-full bg-sky-200 text-black py-2 rounded hover:bg-blue-600 hover:text-white hover:shadow-xl">Login</button>
                </form>
                <div class="flex justify-center pt-4">
                    <a href="forgot_password.jsp" class="text-black hover:text-blue-600 text-sm">Forgot Password?</a>
                </div>

                <p class="text-center mt-4 text-sm">
                    Don't have an account? <a href="signup.jsp" class="text-black hover:text-blue-600 text-m underline">Register</a>
                </p>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <jsp:include page="footer.jsp" />
    
    <script>
        // Clear browser history to prevent back navigation to protected pages
        window.addEventListener('load', function() {
            if (performance.navigation.type === 2) { // Back button navigation
                location.reload(true); // Force a reload from server
            }
            
            // Fix for Safari and older browsers
            window.history.pushState(null, null, window.location.href);
            window.onpopstate = function() {
                window.history.pushState(null, null, window.location.href);
            };
        });
    </script>
</body>
</html>