package com.lms.controllers;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.lms.dao.MaterialProgressDAO;

@WebServlet("/updateProgress")
public class MaterialProgressServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try {
            MaterialProgressDAO dao = new MaterialProgressDAO();
            
            int userId = Integer.parseInt(request.getParameter("userId"));
            int materialId = Integer.parseInt(request.getParameter("materialId"));
            boolean completed = Boolean.parseBoolean(request.getParameter("completed"));
            
            boolean success = dao.updateProgress(userId, materialId, completed);
            if (success) {
                int courseId = dao.getCourseIdFromMaterial(materialId);
                dao.updateProgressPercentage(userId, courseId);
            }
            
            response.getWriter().write("{\"success\": " + success + "}");
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("{\"success\": false, \"error\": \"An error occurred\"}");
        }
    }
}
