<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>About Us - Pragnya</title>
<script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-50 text-gray-800">
	<!-- Include Navbar or Header Component -->
	<jsp:include page="navbar.jsp" />

	<!-- Hero Section -->
	<section class="bg-yellow-100 py-16">
		<div class="container mx-auto px-4">
			<div class="max-w-4xl mx-auto text-center">
				<h1 class="text-xl md:text-4xl font-bold text-black mb-6">About
					Pragnya</h1>
				<p class="text-l text-gray-400">Empowering through innovation
					and technology</p>
			</div>
		</div>
	</section>

	<!-- Our Story Section -->
	<section class="py-12 md:py-16">
		<div class="container mx-auto px-4">
			<div class="max-w-4xl mx-auto">
				<h2 class="text-3xl font-bold mb-8 text-center">Our Story</h2>
				<div class="bg-white rounded-lg shadow-md p-8">
					<p class="text-m">Founded in 2025, Pragnya was born from an
						ambitious internship project. What started as a collaborative
						effort among passionate computer science students evolved into a
						comprehensive learning management system designed to bridge
						educational gaps.</p>

					<p class="text-m ">Our journey began when we identified the
						need for a more intuitive and accessible learning platform during
						our internship at a local tech company. Working nights and
						weekends, we developed Pragnya from the ground up, focusing on
						creating a user-friendly interface that could serve both students
						and instructors effectively.</p>

					<p class="text-m">Today, we're proud to see our internship
						project grow into a full-fledged educational tool being used by
						our university and several neighboring institutions. Pragnya
						represents not just our technical skills, but our commitment to
						improving education through technology.</p>
				</div>
			</div>
		</div>
	</section>

	<!-- Our Values Section -->
	<section class="py-12 md:py-16 bg-gray-100">
		<div class="container mx-auto px-4">
			<div class="max-w-4xl mx-auto">
				<h2 class="text-3xl font-bold mb-8 text-center">Our Values</h2>
				<div class="grid md:grid-cols-2 gap-6">
					<!-- Value 1 -->
					<div
						class="bg-white rounded-lg shadow-md p-6 hover:shadow-lg transition duration-300">
						<h3 class="text-xl font-bold mb-3 text-blue-600">Innovation</h3>
						<p>We constantly push boundaries and explore new possibilities
							to deliver cutting-edge solutions.</p>
					</div>

					<!-- Value 2 -->
					<div
						class="bg-white rounded-lg shadow-md p-6 hover:shadow-lg transition duration-300">
						<h3 class="text-xl font-bold mb-3 text-blue-600">Integrity</h3>
						<p>We maintain the highest ethical standards in all our
							operations and relationships.</p>
					</div>

					<!-- Value 3 -->
					<div
						class="bg-white rounded-lg shadow-md p-6 hover:shadow-lg transition duration-300">
						<h3 class="text-xl font-bold mb-3 text-blue-600">Excellence</h3>
						<p>We strive for excellence in everything we do, from product
							development to customer service.</p>
					</div>

					<!-- Value 4 -->
					<div
						class="bg-white rounded-lg shadow-md p-6 hover:shadow-lg transition duration-300">
						<h3 class="text-xl font-bold mb-3 text-blue-600">Collaboration</h3>
						<p>We believe in the power of teamwork and building strong
							partnerships with our clients and community.</p>
					</div>
				</div>
			</div>
		</div>
	</section>

	<!-- Our Approach Section -->
	<section class="py-12 md:py-16">
		<div class="container mx-auto px-4">
			<div class="max-w-4xl mx-auto">
				<h2 class="text-3xl font-bold mb-8 text-center">Our Approach</h2>
				<div class="bg-white rounded-lg shadow-md p-8">
					<p class="text-m mb-6">At Pragnya, we believe in creating
						learning experiences that are engaging, effective, and enjoyable.
						Our approach combines technical expertise with deep understanding
						of educational needs to create solutions that are:</p>

					<div class="grid md:grid-cols-2 gap-4 mt-6">
						<div class="flex items-start">
							<div class="bg-blue-100 p-2 rounded-full mr-3">
								<svg xmlns="http://www.w3.org/2000/svg"
									class="h-5 w-5 text-blue-600" fill="none" viewBox="0 0 24 24"
									stroke="currentColor">
                                    <path stroke-linecap="round"
										stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
                                </svg>
							</div>
							<div>
								<h4 class="font-bold">User-centric</h4>
								<p>Designed with the end-user in mind</p>
							</div>
						</div>

						<div class="flex items-start">
							<div class="bg-blue-100 p-2 rounded-full mr-3">
								<svg xmlns="http://www.w3.org/2000/svg"
									class="h-5 w-5 text-blue-600" fill="none" viewBox="0 0 24 24"
									stroke="currentColor">
                                    <path stroke-linecap="round"
										stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
                                </svg>
							</div>
							<div>
								<h4 class="font-bold">Scalable</h4>
								<p>Built to grow with your needs</p>
							</div>
						</div>

						<div class="flex items-start">
							<div class="bg-blue-100 p-2 rounded-full mr-3">
								<svg xmlns="http://www.w3.org/2000/svg"
									class="h-5 w-5 text-blue-600" fill="none" viewBox="0 0 24 24"
									stroke="currentColor">
                                    <path stroke-linecap="round"
										stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
                                </svg>
							</div>
							<div>
								<h4 class="font-bold">Secure</h4>
								<p>Implementing industry-leading security practices</p>
							</div>
						</div>

						<div class="flex items-start">
							<div class="bg-blue-100 p-2 rounded-full mr-3">
								<svg xmlns="http://www.w3.org/2000/svg"
									class="h-5 w-5 text-blue-600" fill="none" viewBox="0 0 24 24"
									stroke="currentColor">
                                    <path stroke-linecap="round"
										stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
                                </svg>
							</div>
							<div>
								<h4 class="font-bold">Innovative</h4>
								<p>Leveraging the latest technologies</p>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</section>

	<!-- Connect With Us Section -->
	<section class="py-12 md:py-16 bg-sky-200 text-black">
		<div class="container mx-auto px-4">
			<div class="max-w-4xl mx-auto text-center">
				<h2 class="text-3xl font-bold mb-6">Connect With Us</h2>
				<p class="text-xl mb-8">We'd love to hear from you! Reach out to
					learn more about Pragnya and how we can help you achieve your
					goals.</p>

				
			</div>
		</div>
	</section>

	<!-- Include Footer -->
	<jsp:include page="footer.jsp" />
</body>
</html>