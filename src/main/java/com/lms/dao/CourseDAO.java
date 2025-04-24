package com.lms.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.lms.models.Course;
import com.lms.models.CourseMaterial;
import com.lms.utils.DatabaseConnection;

public class CourseDAO {
    private Connection conn;

    public CourseDAO()  {
        conn = DatabaseConnection.getConnection();
    }

    public boolean addCourse(Course course) {
        String query = "INSERT INTO courses (title, description, instructor_id, is_active) VALUES (?, ?, ?, ?)";
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, course.getTitle());
            stmt.setString(2, course.getDescription());
            stmt.setInt(3, course.getInstructorId());
            stmt.setBoolean(4, course.isActive());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Course> getCoursesByInstructor(int instructorId) {
        List<Course> courses = new ArrayList<>();
        String query = "SELECT course_id, title, description, is_active FROM courses WHERE instructor_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, instructorId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Course course = new Course(
                        rs.getInt("course_id"),
                        rs.getString("title"),
                        rs.getString("description")
                );
                // We need to set the active status separately since the constructor doesn't support it
                boolean isActive = rs.getBoolean("is_active");
                course.setActive(isActive);
                courses.add(course);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return courses;
    }

    public List<Course> getAllCourses() {
        List<Course> courses = new ArrayList<>();
        String query = "SELECT * FROM courses";
        try (Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            while (rs.next()) {
                Course course = new Course(
                    rs.getInt("course_id"),
                    rs.getString("title"),
                    rs.getString("description"),
                    rs.getInt("instructor_id"),
                    rs.getTimestamp("created_at")
                );
                course.setActive(rs.getBoolean("is_active"));
                courses.add(course);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return courses;
    }
    
    public boolean uploadCourseMaterial(int courseId, String fileName, String filePath) {
        String query = "INSERT INTO course_materials (course_id, file_name, file_path) VALUES (?, ?, ?)";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
             
            stmt.setInt(1, courseId);
            stmt.setString(2, fileName);
            stmt.setString(3, filePath);

            int rowsInserted = stmt.executeUpdate();
            return rowsInserted > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Delete Course and its Materials
    public boolean deleteCourse(int courseId) {
        String query = "DELETE FROM courses WHERE course_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, courseId);
            int rowsDeleted = stmt.executeUpdate();
            return rowsDeleted > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public List<CourseMaterial> getCourseMaterials(int studentId) {
        List<CourseMaterial> materials = new ArrayList<>();
        String query = "SELECT cm.material_id, cm.course_id, cm.material_name, cm.file_path, cm.uploaded_at " +
                       "FROM course_materials cm " +
                       "JOIN enrollments e ON cm.course_id = e.course_id " +
                       "WHERE e.student_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, studentId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                CourseMaterial material = new CourseMaterial();
                material.setMaterialId(rs.getInt("material_id"));
                material.setCourseId(rs.getInt("course_id"));
                material.setFileName(rs.getString("material_name"));
                material.setFilePath(rs.getString("file_path"));
                material.setUploadedAt(rs.getTimestamp("uploaded_at"));
                materials.add(material);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return materials;
    }
    
    public String getCourseTitleById(int courseId) {
        String title = "";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement("SELECT title FROM courses WHERE course_id = ?")) {
            stmt.setInt(1, courseId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                title = rs.getString("title");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return title;
    }

    public Course getCourseById(int courseId) {
        Course course = null;
        String query = "SELECT * FROM courses WHERE course_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, courseId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                course = new Course(
                    rs.getInt("course_id"),
                    rs.getString("title"),
                    rs.getString("description"),
                    rs.getInt("instructor_id"),
                    rs.getTimestamp("created_at")
                );
                course.setActive(rs.getBoolean("is_active"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return course;
    }
    
    // New method to toggle course active status
    public boolean toggleCourseActiveStatus(int courseId, boolean isActive) {
        String query = "UPDATE courses SET is_active = ? WHERE course_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setBoolean(1, isActive);
            stmt.setInt(2, courseId);
            
            int rowsUpdated = stmt.executeUpdate();
            return rowsUpdated > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // New method to check if course has materials
    public boolean hasMaterials(int courseId) {
        String query = "SELECT COUNT(*) FROM course_materials WHERE course_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, courseId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
}