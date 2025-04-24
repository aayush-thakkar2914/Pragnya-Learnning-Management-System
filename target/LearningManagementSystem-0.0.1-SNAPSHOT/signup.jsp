<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
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
		let confirmTouched = false; // Track if user has touched confirm password

		function validatePasswords() {
			if (!confirmTouched)
				return; // Don't show error before typing in confirm password

			if (password.value !== confirmPassword.value) {
				confirmPassword.classList.add("border-red-500");
				errorMessage.classList.remove("hidden");
			} else {
				confirmPassword.classList.remove("border-red-500");
				errorMessage.classList.add("hidden");
			}
		}

		// Mark confirm password as "touched" when user types in it
		confirmPassword.addEventListener("input", function() {
			confirmTouched = true;
			validatePasswords();
		});

		// Validate passwords when user types in either field
		password.addEventListener("input", validatePasswords);
	});
</script>
</head>
<body class="bg-gray-100 flex flex-col min-h-screen">

	<!-- Navbar -->
	<jsp:include page="navbar.jsp" />

	<!-- Main Content -->
	<div class="flex-grow flex items-center justify-center p-10">
		<div class="bg-white rounded-lg shadow-lg w-3/4 flex items-center p-8">

			<!-- Left Side Graphic -->
			<div class="w-1/2">
				<img src="images/signupSide.jpeg" alt="Signup Illustration"
					class="w-full h-auto">
			</div>

			<!-- Right Side Form -->
			<div class="w-1/2 p-6">
				<h2 class="text-2xl font-bold text-center mb-4">SignUp</h2>

				<form action="signup" method="post" class="space-y-4">
					<div>
						<label class="block text-sm font-medium">Full Name</label> <input
							type="text" name="name" required
							class="w-full p-2 border rounded">
					</div>
					<div>
						<label class="block text-sm font-medium">Email</label> <input
							type="email" name="email" required
							class="w-full p-2 border rounded">
					</div>
					<div id="error-message" class="text-red-500 text-sm mb-2 hidden">
						⚠ Passwords do not match!</div>

					<div>
						<label class="block text-sm font-medium">Password</label> <input
							type="password" name="password" id="password" required
							class="w-full p-2 border rounded">
					</div>

					<div>
						<label class="block text-sm font-medium">Confirm Password</label>
						<input type="password" id="confirm_password" required
							class="w-full p-2 border rounded">
					</div>
					<div>
						<label class="block text-sm font-medium">Role</label> <select
							name="role" required class="w-full p-2 border rounded">
							<option value="STUDENT">Student</option>
							<option value="INSTRUCTOR">Instructor</option>
						</select>
					</div>
					<button type="submit"
						class="w-full bg-blue-600 text-white py-2 rounded">Register</button>
				</form>

				<p class="text-center mt-4 text-sm">
					Already have an account? <a href="login.jsp" class="text-blue-600">Login</a>
				</p>
			</div>
		</div>
	</div>

	<!-- Footer -->
	<jsp:include page="footer.jsp" />

</body>
</html>
