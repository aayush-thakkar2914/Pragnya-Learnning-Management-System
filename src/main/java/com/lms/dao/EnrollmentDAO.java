package com.lms.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.lms.models.Course;
import com.lms.models.Enrollment;
import com.lms.utils.DatabaseConnection;

public class EnrollmentDAO {
    private Connection conn;

    public EnrollmentDAO() {
        conn = DatabaseConnection.getConnection();
    }
    
    

    // Method to check if a student is already enrolled in a course
    public boolean isStudentEnrolled(int studentId, int courseId) {
        String query = "SELECT COUNT(*) FROM enrollments WHERE student_id = ? AND course_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, studentId);
            stmt.setInt(2, courseId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;  // If count > 0, student is already enrolled
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean enrollStudent(int studentId, int courseId) {
        // Check if student is already enrolled
        if (isStudentEnrolled(studentId, courseId)) {
            System.out.println("Student ID " + studentId + " is already enrolled in Course ID " + courseId);
            return false;
        }

        String query = "INSERT INTO enrollments (student_id, course_id, enrolled_at) VALUES (?, ?, SYSDATE)";
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, studentId);
            stmt.setInt(2, courseId);
            int rowsInserted = stmt.executeUpdate();
            return rowsInserted > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Course> getEnrolledCourseDetails(int studentId) {
        List<Course> courses = new ArrayList<>();
        String query = "SELECT c.course_id, c.title, c.description FROM courses c " +
                       "JOIN enrollments e ON c.course_id = e.course_id " +
                       "WHERE e.student_id = ?";

        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, studentId);
            System.out.println("Fetching enrolled courses for Student ID: " + studentId);  // Debugging
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                System.out.println("Enrolled Course: " + rs.getString("title"));  // Debugging
                Course course = new Course(
                        rs.getInt("course_id"),
                        rs.getString("title"),
                        rs.getString("description")
                );
                courses.add(course);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return courses;
    }

    public List<Enrollment> getEnrolledCourses(int studentId) {
        List<Enrollment> enrollments = new ArrayList<>();
        String query = "SELECT * FROM enrollments WHERE student_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, studentId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                enrollments.add(new Enrollment(
                    rs.getInt("enrollment_id"),
                    rs.getInt("student_id"),
                    rs.getInt("course_id"),
                    rs.getTimestamp("enrolled_at")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return enrollments;
    }
}
