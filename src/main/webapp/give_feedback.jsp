<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page pageEncoding="UTF-8" %>
<%@ page import="com.lms.models.User,com.lms.dao.CourseDAO" %>

<%
User user = (User) session.getAttribute("user");
if (user == null || !"STUDENT".equals(user.getRole())) {
    response.sendRedirect("login.jsp");
    return;
}

CourseDAO courseDAO = new CourseDAO();
String courseIdstr = request.getParameter("courseId");
if (courseIdstr == null) {
    response.sendRedirect("myEnrolledCourses.jsp");
    return;
}
int courseId = Integer.parseInt(courseIdstr);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Give Feedback</title>
    <script src="https://cdn.tailwindcss.com"></script>

    <style>
        /* Popup Styles */
        .popup-overlay {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: rgba(0, 0, 0, 0.5);
            display: flex;
            justify-content: center;
            align-items: center;
            z-index: 50;
            opacity: 0;
            visibility: hidden;
            transition: opacity 0.3s ease, visibility 0.3s ease;
        }
        
        .popup-overlay.active {
            opacity: 1;
            visibility: visible;
        }
        
        .popup {
            background-color: white;
            border-radius: 0.5rem;
            padding: 1.5rem;
            max-width: 90%;
            width: 24rem;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
            transform: translateY(-20px);
            transition: transform 0.3s ease;
            text-align: center;
        }
        
        .popup-overlay.active .popup {
            transform: translateY(0);
        }
        
        .popup-icon {
            margin: 0 auto;
            width: 3rem;
            height: 3rem;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 1rem;
        }
        
        .popup-icon.success {
            background-color: #10B981;
            color: white;
        }
        
        .popup-icon.error {
            background-color: #EF4444;
            color: white;
        }
        
        .popup-title {
            font-size: 1.25rem;
            font-weight: 600;
            margin-bottom: 0.5rem;
        }
        
        .popup-message {
            color: #6B7280;
            margin-bottom: 1.5rem;
        }
    </style>
</head>

<body class="bg-gray-100 flex flex-col min-h-screen">
    <!-- Navbar -->
    <jsp:include page="navbar.jsp"/>

    <!-- Main Content -->
    <div class="flex flex-grow items-center justify-center mt-12">
        <div class="bg-white shadow-lg rounded-lg overflow-hidden max-w-4xl w-full flex">

            <!-- Left Side - Image -->
            <div class="hidden md:block w-1/2">
                <img src="images/feedback.jpg" alt="Feedback Image" class="h-full w-full object-cover">
            </div>

            <!-- Right Side - Feedback Form -->
            <div class="w-full md:w-1/2 p-6">
                <h2 class="text-2xl font-bold text-center">Give Feedback</h2>

                <!-- Course Name -->
                <p class="text-lg font-semibold text-gray-700 mt-2 text-center">
                    Course: <%= courseDAO.getCourseTitleById(courseId) %>
                </p>

                <!-- Feedback Form -->
                <form id="feedbackForm" class="mt-4">
                    <input type="hidden" name="studentId" value="<%= user.getUserId() %>">
                    <input type="hidden" name="courseId" value="<%= courseId %>">

                    <!-- Star Rating -->
                    <label class="block font-semibold mt-2">Rating:</label>
                    <div class="flex justify-center space-x-1 text-4xl">
                        <%
                        for (int i = 1; i <= 5; i++) {
                        %>
                        <input type="radio" id="star<%= i %>" name="rating" value="<%= i %>" class="hidden">
                        <label for="star<%= i %>" class="cursor-pointer text-gray-300 hover:text-yellow-500 star transition duration-300"
                            data-value="<%= i %>">&#9733;</label>
                        <%
                        }
                        %>
                    </div>

                    <!-- Feedback Textarea -->
                    <label class="block font-semibold mt-4">Your Feedback:</label>
                    <textarea name="feedback" required class="border rounded p-2 w-full h-24"></textarea>

                    <!-- Submit Button -->
                    <button type="submit" class="bg-blue-500 text-white px-4 py-2 rounded mt-4 w-full hover:bg-blue-600 transition">
                        Submit Feedback
                    </button>
                </form>

                <!-- Back to Courses Link -->
                <a href="myEnrolledCourses" class="block mt-4 text-blue-500 text-center hover:underline">
                    Back to Courses
                </a>
            </div>
        </div>
    </div>

    <!-- Popup Overlay -->
    <div id="popupOverlay" class="popup-overlay">
        <div class="popup">
            <div id="popupIcon" class="popup-icon success">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
                </svg>
            </div>
            <h3 id="popupTitle" class="popup-title">Success!</h3>
            <p id="popupMessage" class="popup-message">Feedback submitted successfully.</p>
        </div>
    </div>

    <!-- Footer -->
    <jsp:include page="footer.jsp"/>

    <!-- Star Rating JavaScript -->
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            const stars = document.querySelectorAll(".star");
            let selectedRating = 0;

            stars.forEach(star => {
                star.addEventListener("click", function () {
                    selectedRating = this.getAttribute("data-value");
                    document.getElementById("star" + selectedRating).checked = true;
                    updateStars(selectedRating);
                });

                star.addEventListener("mouseover", function () {
                    updateStars(this.getAttribute("data-value"));
                });

                star.addEventListener("mouseout", function () {
                    updateStars(selectedRating);
                });
            });

            function updateStars(value) {
                stars.forEach(star => {
                    if (star.getAttribute("data-value") <= value) {
                        star.classList.add("text-yellow-500");
                        star.classList.remove("text-gray-300");
                    } else {
                        star.classList.add("text-gray-300");
                        star.classList.remove("text-yellow-500");
                    }
                });
            }

            // Form Submission
            const feedbackForm = document.getElementById("feedbackForm");
            const popupOverlay = document.getElementById("popupOverlay");
            const popupIcon = document.getElementById("popupIcon");
            const popupTitle = document.getElementById("popupTitle");
            const popupMessage = document.getElementById("popupMessage");

            feedbackForm.addEventListener("submit", function(e) {
                e.preventDefault();
                
                // Check if rating is selected
                if (!selectedRating) {
                    showPopup("error", "Error", "Please select a rating.");
                    return;
                }
                
                // Get form data
                const formData = new FormData(feedbackForm);
                
                // Convert FormData to URL-encoded string
                const urlEncodedData = new URLSearchParams(formData).toString();
                
                // Send AJAX request
                fetch("feedback", {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/x-www-form-urlencoded"
                    },
                    body: urlEncodedData
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        showPopup("success", "Success!", data.message);
                        
                        // Redirect after 2 seconds
                        setTimeout(() => {
                            window.location.href = "myEnrolledCourses";
                        }, 2000);
                    } else {
                        showPopup("error", "Error", data.message);
                    }
                })
                .catch(error => {
                    console.error("Error:", error);
                    showPopup("error", "Error", "An error occurred. Please try again.");
                });
            });

            // Function to show popup
            function showPopup(type, title, message) {
                // Set popup content
                if (type === "success") {
                    popupIcon.className = "popup-icon success";
                    popupIcon.innerHTML = '<svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" /></svg>';
                } else {
                    popupIcon.className = "popup-icon error";
                    popupIcon.innerHTML = '<svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" /></svg>';
                }
                
                popupTitle.textContent = title;
                popupMessage.textContent = message;
                
                // Show popup
                popupOverlay.classList.add("active");
                
                // Hide popup after 2 seconds if success
                if (type === "success") {
                    setTimeout(() => {
                        popupOverlay.classList.remove("active");
                    }, 1800);
                } else {
                    // For error popups, hide after 4 seconds
                    setTimeout(() => {
                        popupOverlay.classList.remove("active");
                    }, 4000);
                }
            }
        });
    </script>
</body>
</html>