<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Reset Password - LMS</title>
<script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 flex flex-col min-h-screen">

    <!-- Navbar -->
    <jsp:include page="navbar.jsp" />

    <!-- Main Content -->
    <div class="flex-grow flex items-center justify-center p-10">
        <div class="bg-white rounded-lg shadow-lg w-3/4 flex items-center p-8">

            <!-- Left Side Graphic -->
            <div class="w-1/2">
                <img src="images/resetPassword.jpeg" alt="Reset Password Illustration"
                    class="w-full h-auto">
            </div>

            <!-- Right Side Form -->
            <div class="w-1/2 p-6">
                <h2 class="text-2xl font-bold text-center mb-4">Reset Your Password</h2>

                <%-- Show error message if present --%>
                <%
                if (request.getParameter("error") != null) {
                %>
                <p class="text-red-500 text-sm text-center"><%=request.getParameter("error")%></p>
                <%
                }
                %>

                <form action="ResetPasswordServlet" method="post" class="space-y-4">
                    <input type="hidden" name="token" value="<%= request.getParameter("token") %>">

                    <div>
                        <label class="block text-sm font-medium">New Password</label>
                        <input type="password" name="password" required
                            class="w-full p-2 border rounded">
                    </div>
                    <div>
                        <label class="block text-sm font-medium">Confirm Password</label>
                        <input type="password" name="confirm_password" required
                            class="w-full p-2 border rounded">
                    </div>

                    <button type="submit"
                        class="w-full bg-green-600 text-white py-2 rounded">Reset Password
                    </button>
                </form>

                <div class="flex justify-center pt-4">
                    <a href="login.jsp" class="text-blue-500 text-sm">Back to Login</a>
                </div>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <jsp:include page="footer.jsp" />

</body>
</html>
