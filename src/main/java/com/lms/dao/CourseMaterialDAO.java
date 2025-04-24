package com.lms.dao;

import com.lms.models.CourseMaterial;
import com.lms.utils.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CourseMaterialDAO {
    
    // Fetch materials for enrolled courses of a student
    public List<CourseMaterial> getMaterialsForStudent(int studentId) {
        List<CourseMaterial> materials = new ArrayList<>();
        String query = "SELECT cm.material_id, cm.course_id, cm.file_name, cm.file_type, cm.file_path, cm.uploaded_at " +
                       "FROM Course_Materials cm " +
                       "JOIN Enrollments e ON cm.course_id = e.course_id " +
                       "WHERE e.student_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setInt(1, studentId);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                CourseMaterial material = new CourseMaterial();
                material.setMaterialId(rs.getInt("material_id"));
                material.setCourseId(rs.getInt("course_id"));
                material.setFileName(rs.getString("file_name"));
                material.setFileType(rs.getString("file_type"));
                material.setFilePath(rs.getString("file_path"));
                material.setUploadedAt(rs.getTimestamp("uploaded_at"));

                materials.add(material);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return materials;
    }
    public List<CourseMaterial> getMaterialsByStudent(int studentId) {
        List<CourseMaterial> materials = new ArrayList<>();
        String query = "SELECT cm.material_id, cm.file_name, cm.file_path, cm.course_id, c.title " +
                       "FROM course_materials cm " +
                       "JOIN enrollments e ON cm.course_id = e.course_id " +
                       "JOIN courses c ON cm.course_id = c.course_id " +
                       "WHERE e.student_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, studentId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                CourseMaterial material = new CourseMaterial(
                    rs.getInt("material_id"),
                    rs.getInt("course_id"),
                    rs.getString("file_name"),
                    rs.getString("file_path")
                );
                material.setCourseName(rs.getString("title")); // Add course name
                materials.add(material);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return materials;
    }
    
    public List<CourseMaterial> getMaterialsByCourse(int courseId, int userId) {
        List<CourseMaterial> materials = new ArrayList<>();
        String query = "SELECT cm.material_id, cm.file_name, cm.file_path, " +
                       "COALESCE(p.is_completed, 0) AS isCompleted " +
                       "FROM course_materials cm " +
                       "LEFT JOIN MaterialProgress p ON cm.material_id = p.material_id AND p.student_id = ? " +
                       "WHERE cm.course_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, userId);
            stmt.setInt(2, courseId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                CourseMaterial material = new CourseMaterial(
                        rs.getInt("material_id"),
                        rs.getString("file_name"),
                        rs.getString("file_path"),
                        rs.getBoolean("isCompleted")  // Fetch completion status
                );
                materials.add(material);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return materials;
    }


}
