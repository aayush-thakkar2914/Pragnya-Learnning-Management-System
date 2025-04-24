<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page pageEncoding="UTF-8" %>
<%@ page import="javax.servlet.http.HttpSession" %>

<%
// Prevent caching (Ensures user cannot go back)
response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
response.setHeader("Pragma", "no-cache");
response.setHeader("Expires", "0");

// Invalidate the session
HttpSession userSession = request.getSession(false);
if (userSession != null) {
    userSession.invalidate();
}

// Set a flag in the session to indicate a logout has occurred
session = request.getSession(true);
session.setAttribute("logout_flag", "true");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Logging Out...</title>
    <script>
        // More aggressive approach to prevent back navigation
        window.onload = function() {
            // Clear browser history state
            window.history.pushState(null, null, document.URL);
            window.addEventListener('popstate', function() {
                window.history.pushState(null, null, document.URL);
            });
            
            // Redirect to login page after logout
            setTimeout(function() {
                // Use replace to prevent the page from being added to history
                window.location.replace("login.jsp?logout=true");
            }, 500);
        };
    </script>
</head>
<body>
    <div style="display: flex; justify-content: center; align-items: center; height: 100vh;">
        <p>Logging out, please wait...</p>
    </div>
</body>
</html>