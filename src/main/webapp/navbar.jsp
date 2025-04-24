<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.lms.models.User" %>
<%@ page import="javax.servlet.http.HttpSession" %>

<%
HttpSession userSession = request.getSession(false);
User user = (userSession != null) ? (User) userSession.getAttribute("user") : null;
boolean isLoggedIn = (user != null);
boolean isInstructor = isLoggedIn && "INSTRUCTOR".equals(user.getRole());
%>

<!-- Navigation Bar -->
<nav class="bg-sky-200 p-4">
  <div class="container mx-auto">
    <div class="flex justify-between items-center">
      <!-- Logo -->
      <a href="index.jsp" class="flex items-center">
        <img src="images/logo_f.png" alt="Pragnya Logo" class="h-16 md:h-20 w-auto ">
      </a>
      
      <!-- Hamburger Menu Button (visible on mobile) -->
      <button id="menuToggle" class="md:hidden block text-black focus:outline-none">
        <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16" />
        </svg>
      </button>
      
      <!-- Navigation Links (hidden on mobile until toggled) -->
      <div id="navLinks" class="hidden md:flex md:items-center md:space-x-6 absolute md:static left-0 right-0 top-24 md:top-auto bg-sky-200 md:bg-transparent flex-col md:flex-row p-4 md:p-0 shadow-lg md:shadow-none z-50">
        <a href="index.jsp" class="block py-2 md:py-0 px-2 md:px-0 text-black hover:text-blue-600">Home</a>
        <a href="about.jsp" class="block py-2 md:py-0 px-2 md:px-0 text-black hover:text-blue-600">About Us</a>
        
        <% if (isLoggedIn) { %>
          <% if (isInstructor) { %>
            <a href="instructor_dashboard.jsp" class="block py-2 md:py-0 px-2 md:px-0 text-black hover:text-blue-600">Dashboard</a>
          <% } else { %>
            <a href="student_dashboard.jsp" class="block py-2 md:py-0 px-2 md:px-0 text-black hover:text-blue-600">Dashboard</a>
          <% } %>
          
          <!-- Logout Button -->
          <a href="logout.jsp" class="block mt-2 md:mt-0 px-4 py-2 bg-red-600 text-white rounded-md hover:bg-red-700 transition w-full md:w-auto text-center">
            Logout
          </a>
        <% } else { %>
          <a href="login.jsp" class="block mt-2 md:mt-0 px-4 py-2 bg-yellow-600 text-white rounded-md hover:bg-yellow-700 transition w-full md:w-auto text-center">
            Login
          </a>
          <a href="signup.jsp" class="block mt-2 md:mt-0 px-4 py-2 bg-green-600 text-white rounded-md hover:bg-green-700 transition w-full md:w-auto text-center">
            Sign Up
          </a>
        <% } %>
      </div>
    </div>
  </div>
</nav>

<!-- JavaScript for toggle menu -->
<script>
  document.getElementById('menuToggle').addEventListener('click', function() {
    const navLinks = document.getElementById('navLinks');
    if (navLinks.classList.contains('hidden')) {
      navLinks.classList.remove('hidden');
      navLinks.classList.add('flex');
    } else {
      navLinks.classList.add('hidden');
      navLinks.classList.remove('flex');
    }
  });
  
  // Close menu when window is resized to desktop size
  window.addEventListener('resize', function() {
    const navLinks = document.getElementById('navLinks');
    if (window.innerWidth >= 768) { // md breakpoint
      navLinks.classList.remove('hidden');
      navLinks.classList.add('flex');
    } else {
      navLinks.classList.add('hidden');
      navLinks.classList.remove('flex');
    }
  });
</script>