<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Signup | Pragya</title>
<script src="https://cdn.tailwindcss.com"></script>
<script>
document.addEventListener("DOMContentLoaded", function() {
    let password = document.getElementById("password");
    let confirmPassword = document.getElementById("confirm_password");
    let errorMessage = document.getElementById("error-message");
    let strengthBar = document.getElementById("strength-bar");
    let validationList = document.getElementById("password-validation");
    let confirmTouched = false;

    function validatePasswords() {
        if (!confirmTouched) return;
        if (password.value !== confirmPassword.value) {
            confirmPassword.classList.add("border-red-500");
            errorMessage.classList.remove("hidden");
        } else {
            confirmPassword.classList.remove("border-red-500");
            errorMessage.classList.add("hidden");
            // Hide bar & criteria once confirm password is entered
            validationList.classList.add("hidden");
            strengthBar.style.width = "0%";
        }
    }

    confirmPassword.addEventListener("input", function() {
        confirmTouched = true;
        validatePasswords();
    });

    // Also validate when password changes
    password.addEventListener("input", validatePasswords);

    function checkPasswordStrength() {
        if (password.value.length === 0) {
            validationList.classList.add("hidden");
            strengthBar.style.width = "0%";
            return;
        } 

        validationList.classList.remove("hidden");

        let value = password.value;
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

        // Hide bar if all conditions are met and confirm password is entered
        if (strength === 4 && confirmPassword.value.length > 0) {
            validationList.classList.add("hidden");
            strengthBar.style.width = "0%";
        }
    }

    password.addEventListener("input", checkPasswordStrength);
});
</script>
</head>
<body class="bg-gray-100 flex flex-col min-h-screen">
    <jsp:include page="navbar.jsp" />
    <div class="flex-grow flex items-center justify-center p-10">
        <div class="bg-white rounded-lg shadow-lg w-3/4 flex items-center p-8">
            <div class="w-1/2">
                <img src="images/signupSide.jpeg" alt="Signup Illustration" class="w-full h-auto">
            </div>
            <div class="w-full md:w-1/2 p-6">
                <h2 class="text-xl md:text-2xl font-bold text-center mb-4">SignUp</h2>
                <form action="signup" method="post" class="space-y-4">
                    <div>
                        <label class="block text-sm font-medium">Full Name</label>
                        <input type="text" name="name" required class="w-full p-2 border rounded hover:bg-gray-100 hover:shadow-sm">
                    </div>
                    <div>
                        <label class="block text-sm font-medium">Email</label>
                        <input type="email" name="email" required class="w-full p-2 border rounded hover:bg-gray-100 hover:shadow-sm">
                    </div>
                    <div id="error-message" class="text-red-500 text-sm mb-2 hidden">
                        ⚠ Passwords do not match!
                    </div>
                    <div>
                        <label class="block text-sm font-medium">Password</label>
                        <input type="password" name="password" id="password" required class="w-full p-2 border rounded hover:bg-gray-100 hover:shadow-sm">
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
                        <label class="block text-sm font-medium">Confirm Password</label>
                        <input type="password" id="confirm_password" required class="w-full p-2 border rounded hover:bg-gray-100 hover:shadow-sm">
                    </div>
                    <div>
                        <label class="block text-sm font-medium">Role</label>
                        <select name="role" required class="w-full p-2 border rounded hover:bg-gray-100 hover:shadow-sm">
                            <option value="STUDENT">Student</option>
                            <option value="INSTRUCTOR">Instructor</option>
                        </select>
                    </div>
                    <button type="submit" class="w-full bg-sky-200 text-black py-2 rounded hover:bg-blue-600 hover:text-white">Register</button>
                </form>
                <p class="text-center mt-4 text-sm">
                    Already have an account? <a href="login.jsp" class="text-black hover:text-blue-600 text-m underline">Login</a>
                </p>
            </div>
        </div>
    </div>
    <jsp:include page="footer.jsp" />
</body>
</html>