package com.lms.controllers;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import com.lms.dao.CourseDAO;
import com.lms.models.User;
@WebServlet("/uploadMaterial")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
                 maxFileSize = 1024 * 1024 * 50,      // 50MB
                 maxRequestSize = 1024 * 1024 * 100)  // 100MB
public class UploadMaterialServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        User user = (User) session.getAttribute("user");
        if (!"INSTRUCTOR".equals(user.getRole())) {
            response.sendRedirect("instructor_dashboard.jsp");
            return;
        }
        int courseId = Integer.parseInt(request.getParameter("courseId"));
        Part filePart = request.getPart("file");
        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        String uploadPath = getServletContext().getRealPath("") + "uploads" + File.separator + fileName;
        File uploadDir = new File(getServletContext().getRealPath("") + "uploads");
        if (!uploadDir.exists()) uploadDir.mkdir();
        filePart.write(uploadPath);
        CourseDAO courseDAO = new CourseDAO();
        boolean success = courseDAO.uploadCourseMaterial(courseId, fileName, "uploads/" + fileName);
        if (success) {
            // Add the uploadSuccess parameter to the redirect URL
            response.sendRedirect("viewInstructorCourses?uploadSuccess=true");
        } else {
            response.getWriter().println("Failed to upload material.");
        }
    }
}