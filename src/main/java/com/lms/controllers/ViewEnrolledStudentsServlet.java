package com.lms.controllers;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.lms.dao.CourseDAO;
import com.lms.models.Course;
import com.lms.utils.DatabaseConnection;

@WebServlet("/viewEnrolledStudents")
public class ViewEnrolledStudentsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String courseIdParam = request.getParameter("courseId");
        
        if (courseIdParam == null || courseIdParam.isEmpty()) {
            response.sendRedirect("viewInstructorCourses");
            return;
        }
        
        int courseId = Integer.parseInt(courseIdParam);
        
        // Get course details
        CourseDAO courseDAO = new CourseDAO();
        Course course = courseDAO.getCourseById(courseId);
        
        if (course == null) {
            response.sendRedirect("viewInstructorCourses");
            return;
        }
        
        List<EnrolledStudentInfo> enrolledStudents = getEnrolledStudents(courseId);
        
        request.setAttribute("course", course);
        request.setAttribute("enrolledStudents", enrolledStudents);
        
        request.getRequestDispatcher("/enrolledStudents.jsp").forward(request, response);
    }
    
    private List<EnrolledStudentInfo> getEnrolledStudents(int courseId) {
        List<EnrolledStudentInfo> enrolledStudents = new ArrayList<>();
        
        String query = "SELECT u.user_id, u.name, u.email, e.enrolled_at, " +
                       "NVL(p.completed_percentage, 0) as progress_percentage " +
                       "FROM Users u " +
                       "JOIN Enrollments e ON u.user_id = e.student_id " +
                       "LEFT JOIN Progress p ON u.user_id = p.student_id AND e.course_id = p.course_id " +
                       "WHERE e.course_id = ? " +
                       "ORDER BY u.name";

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseConnection.getConnection();
            stmt = conn.prepareStatement(query);
            stmt.setInt(1, courseId);
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                int studentId = rs.getInt("user_id");
                String username = rs.getString("name");
                String email = rs.getString("email");
                Date enrollmentDate = rs.getTimestamp("enrolled_at");
                int progressPercentage = rs.getInt("progress_percentage");

                EnrolledStudentInfo student = new EnrolledStudentInfo(
                    studentId, username, email, enrollmentDate, progressPercentage
                );

                enrolledStudents.add(student);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        return enrolledStudents;
    }
    
    // If progress needs to be calculated based on material completion instead of using the Progress table
    private int calculateMaterialProgress(Connection conn, int studentId, int courseId) throws SQLException {
        String query = "SELECT " +
                      "COUNT(cm.material_id) as total_materials, " +
                      "COUNT(mp.progress_id) as completed_materials " +
                      "FROM Course_Materials cm " +
                      "LEFT JOIN MaterialProgress mp ON cm.material_id = mp.material_id " +
                      "AND mp.student_id = ? AND mp.is_completed = 1 " +
                      "WHERE cm.course_id = ?";
                      
        PreparedStatement stmt = null;
        ResultSet rs = null;
        int progressPercentage = 0;
        
        try {
            stmt = conn.prepareStatement(query);
            stmt.setInt(1, studentId);
            stmt.setInt(2, courseId);
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                int totalMaterials = rs.getInt("total_materials");
                int completedMaterials = rs.getInt("completed_materials");
                
                if (totalMaterials > 0) {
                    progressPercentage = (completedMaterials * 100) / totalMaterials;
                }
            }
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
        }
        
        return progressPercentage;
    }
    
    // Inner class to hold student info with progress
    public static class EnrolledStudentInfo {
        private int id;
        private String username;
        private String email;
        private Date enrollmentDate;
        private int progressPercentage;
        
        public EnrolledStudentInfo(int id, String username, String email, Date enrollmentDate, int progressPercentage) {
            this.id = id;
            this.username = username;
            this.email = email;
            this.enrollmentDate = enrollmentDate;
            this.progressPercentage = progressPercentage;
        }
        
        public int getId() { return id; }
        public String getUsername() { return username; }
        public String getEmail() { return email; }
        public Date getEnrollmentDate() { return enrollmentDate; }
        public int getProgressPercentage() { return progressPercentage; }
    }
}