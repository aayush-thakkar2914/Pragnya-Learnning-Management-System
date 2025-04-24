<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>PRAGNYA - LMS</title>
<script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100">

	<!-- Include Navbar -->
	<jsp:include page="navbar.jsp" />

	<!-- Hero Section -->
	<div class="h-screen flex items-center px-12 relative">
		<div class="w-1/2 h-full flex justify-center items-center">
			<img src="images/dashboard_below_navbar.jpeg"
				alt="Learning Illustration"
				class="max-w-full max-h-[80%] object-contain">
		</div>
		<div
			class="w-1/2 flex flex-col justify-center text-gray-800 text-left px-8">
			<h1 class="text-5xl md:text-6xl font-extrabold tracking-wide">
				Welcome to <span class="text-gray-900">PRAGNYA!!</span>
			</h1>
			<p class="mt-4 text-lg md:text-xl leading-relaxed">Relive your
				lecture sessions and explore the unbounded knowledge shared!</p>
			<h2 class="text-3xl md:text-4xl font-semibold mt-6">Your
				Learning Hub</h2>
			<p class="mt-4 text-lg md:text-xl leading-relaxed">Access
				recorded lectures, notes, and engage with experts from different
				domains.</p>
		</div>
	</div>

	<!-- Features Section -->
	<div class="container mx-auto py-16 px-4">
		<h2 class="text-3xl font-bold text-center text-gray-800 mb-12">Why
			Choose PRAGNYA?</h2>
		<div class="grid grid-cols-1 md:grid-cols-3 gap-8">
			<div class="bg-white p-6 rounded-lg shadow-md">
				<div
					class="bg-blue-100 w-12 h-12 rounded-full flex items-center justify-center mx-auto mb-4">
					<svg xmlns="http://www.w3.org/2000/svg"
						class="h-6 w-6 text-blue-600" fill="none" viewBox="0 0 24 24"
						stroke="currentColor">
                        <path stroke-linecap="round"
							stroke-linejoin="round" stroke-width="2"
							d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253" />
                    </svg>
				</div>
				<h3 class="text-xl font-semibold text-center mb-2">Crash
					Courses</h3>
				<p class="text-gray-600 text-center">Access courses taught by
					the experts.</p>
			</div>

			<div class="bg-white p-6 rounded-lg shadow-md">
				<div
					class="bg-blue-100 w-12 h-12 rounded-full flex items-center justify-center mx-auto mb-4">
					<svg xmlns="http://www.w3.org/2000/svg"
						class="h-6 w-6 text-blue-600" fill="none" viewBox="0 0 24 24"
						stroke="currentColor">
                        <path stroke-linecap="round"
							stroke-linejoin="round" stroke-width="2"
							d="M9.663 17h4.673M12 3v1m6.364 1.636l-.707.707M21 12h-1M4 12H3m3.343-5.657l-.707-.707m2.828 9.9a5 5 0 117.072 0l-.548.547A3.374 3.374 0 0014 18.469V19a2 2 0 11-4 0v-.531c0-.895-.356-1.754-.988-2.386l-.548-.547z" />
                    </svg>
				</div>
				<h3 class="text-xl font-semibold text-center mb-2">Interactive
					Learning</h3>
				<p class="text-gray-600 text-center">Engage with interactive
					content video lectures along with learning material.</p>
			</div>

			<div class="bg-white p-6 rounded-lg shadow-md">
				<div
					class="bg-blue-100 w-12 h-12 rounded-full flex items-center justify-center mx-auto mb-4">
					<svg xmlns="http://www.w3.org/2000/svg"
						class="h-6 w-6 text-blue-600" fill="none" viewBox="0 0 24 24"
						stroke="currentColor">
                        <path stroke-linecap="round"
							stroke-linejoin="round" stroke-width="2"
							d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                    </svg>
				</div>
				<h3 class="text-xl font-semibold text-center mb-2">Learn
					Anytime</h3>
				<p class="text-gray-600 text-center">Study at your own pace with
					24/7 access to all resources from any device.</p>
			</div>
		</div>
	</div>

	<!-- Call to Action -->
	<div class="bg-gray-300 py-12">
		<div class="container mx-auto text-center px-4">
			<h2 class="text-3xl font-bold text-black mb-4">Ready to get
				started?</h2>
			<p class="text-black-100 mb-8 max-w-2xl mx-auto">Join thousands
				of students and instructors already using PRAGNYA to transform their
				learning experience.</p>
			<a href="login.jsp"
				class="bg-white text-blue-600 px-6 py-3 rounded-md font-semibold hover:bg-gray-100 transition">Login
				Now</a>
		</div>
	</div>

	<!-- Include Footer -->
	<jsp:include page="footer.jsp" />

</body>
</html>
