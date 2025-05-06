<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Reset Password | LMS</title>
<link rel="icon" href="images/favicon.png" type="image/png"> 
<script src="https://cdn.tailwindcss.com"></script>
<script>
document.addEventListener("DOMContentLoaded", function() {
    let form = document.getElementById("reset-form");
    let newPassword = document.getElementById("new_password");
    let confirmPassword = document.getElementById("confirm_password");
    let errorMessage = document.getElementById("error-message");
    let strengthBar = document.getElementById("strength-bar");
    let validationList = document.getElementById("password-validation");
    let submitButton = document.getElementById("submit-button");
    let confirmTouched = false;

    function validatePasswords() {
        if (!confirmTouched && confirmPassword.value.length === 0) return;
        
        confirmTouched = true;
        if (newPassword.value !== confirmPassword.value) {
            confirmPassword.classList.add("border-red-500");
            errorMessage.classList.remove("hidden");
            submitButton.disabled = true;
            return false;
        } else {
            confirmPassword.classList.remove("border-red-500");
            errorMessage.classList.add("hidden");
            submitButton.disabled = false;
            return true;
        }
    }

    confirmPassword.addEventListener("input", validatePasswords);
    newPassword.addEventListener("input", validatePasswords);
	
	function checkPasswordStrength() {
        if (newPassword.value.length === 0) {
            validationList.classList.add("hidden");
            strengthBar.style.width = "0%";
            return;
        }
        
        validationList.classList.remove("hidden");
        
        let value = newPassword.value;
        let hasNumber = /[0-9]/.test(value);
        let hasUpperCase = /[A-Z]/.test(value);
        let hasSpecialChar = /[!@#$%^&*(),.?":{}|<>]/.test(value);
        let hasMinLength = value.length >= 8;
        
        document.getElementById("length-check").classList.toggle("text-green-500", hasMinLength);
        document.getElementById("number-check").classList.toggle("text-green-500", hasNumber);
        document.getElementById("uppercase-check").classList.toggle("text-green-500", hasUpperCase);
        document.getElementById("special-check").classList.toggle("text-green-500", hasSpecialChar);
        
        let strength = hasNumber + hasUpperCase + hasSpecialChar + hasMinLength;
        strengthBar.style.width = (strength * 25) + "%";
        strengthBar.classList.remove("bg-red-500", "bg-yellow-500", "bg-green-500");
        
        if (strength <= 1) strengthBar.classList.add("bg-red-500");
        else if (strength == 2 || strength == 3) strengthBar.classList.add("bg-yellow-500");
        else strengthBar.classList.add("bg-green-500");
    }

    newPassword.addEventListener("input", checkPasswordStrength);
    
    // Form validation before submission
    form.addEventListener("submit", function(event) {
        if (!validatePasswords()) {
            event.preventDefault();
        }
    });
});
</script>
</head>
<body class="bg-gray-100 flex flex-col min-h-screen">
    <jsp:include page="navbar.jsp" />
    <div class="flex-grow flex items-center justify-center p-10">
        <div class="bg-white rounded-lg shadow-lg w-3/4 flex items-center p-8">
            <div class="w-1/2">
                <img src="images/resetPassword.jpg" alt="Reset Password" class="w-full h-auto">
            </div>
            <div class="w-full md:w-1/2 p-6">
                <h2 class="text-xl md:text-2xl font-bold text-center mb-4">Reset Password</h2>
                
                <% if(request.getParameter("error") != null) { %>
                    <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative mb-4">
                        <%= request.getParameter("error") %>
                    </div>
                <% } %>
                
                <form id="reset-form" action="ResetPassword" method="post" class="space-y-4">
                    <input type="hidden" name="token" value="<%= request.getParameter("token") %>">
                    <div>
                        <label class="block text-sm font-medium">New Password</label>
                        <input type="password" name="new_password" id="new_password" required 
                               class="w-full p-2 border rounded hover:bg-gray-100 hover:shadow-sm">
                        <div id="password-validation" class="hidden mt-2 text-sm text-gray-600">
                            <p id="length-check">✔ At least 8 characters</p>
                            <p id="number-check">✔ At least 1 number</p>
                            <p id="uppercase-check">✔ At least 1 uppercase letter</p>
                            <p id="special-check">✔ At least 1 special character</p>
                        </div>
                        <div class="w-full h-2 bg-gray-200 rounded mt-1">
                            <div id="strength-bar" class="h-full w-0 bg-red-500 rounded"></div>
                        </div>
                    </div>
                    <div>
                        <label class="block text-sm font-medium">Confirm New Password</label>
                        <input type="password" name="confirm_password" id="confirm_password" required 
                               class="w-full p-2 border rounded hover:bg-gray-100 hover:shadow-sm">
                        <div id="error-message" class="text-red-500 text-sm mb-2 hidden">⚠ Passwords do not match!</div>
                    </div>
                    <button id="submit-button" type="submit" 
                            class="w-full bg-sky-200 text-black py-2 rounded hover:bg-blue-600 hover:text-white">
                        Reset Password
                    </button>
                </form>
            </div>
        </div>
    </div>
    <jsp:include page="footer.jsp" />
</body>
</html>