package com.lms.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import com.lms.models.Feedback;
import com.lms.utils.DatabaseConnection;

public class FeedbackDAO {

	public boolean addFeedback(int studentId, int courseId, int rating, String courseFeedback) {
		String query = "INSERT INTO Feedback (student_id, course_id, rating, course_feedback) VALUES (?, ?, ?, ?)";
		try (Connection conn = DatabaseConnection.getConnection();
				PreparedStatement stmt = conn.prepareStatement(query)) {
			stmt.setInt(1, studentId);
			stmt.setInt(2, courseId);
			stmt.setInt(3, rating);
			stmt.setString(4, courseFeedback);
			return stmt.executeUpdate() > 0;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return false;
	}

	public Feedback getFeedbackByStudentAndCourse(int studentId, int courseId) {
		try {
			Connection conn = DatabaseConnection.getConnection();
			String query = "SELECT rating, course_feedback FROM Feedback WHERE student_id=? AND course_id=?";
			PreparedStatement ps = conn.prepareStatement(query);
			ps.setInt(1, studentId);
			ps.setInt(2, courseId);
			ResultSet rs = ps.executeQuery();
			if (rs.next()) {
				return new Feedback(studentId, courseId, rs.getInt("rating"), rs.getString("course_feedback"));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}

	public boolean hasGivenFeedback(int studentId, int courseId) {
		String query = "SELECT COUNT(*) FROM Feedback WHERE student_id = ? AND course_id = ?";
		try (Connection conn = DatabaseConnection.getConnection();
				PreparedStatement stmt = conn.prepareStatement(query)) {
			stmt.setInt(1, studentId);
			stmt.setInt(2, courseId);
			ResultSet rs = stmt.executeQuery();
			if (rs.next()) {
				return rs.getInt(1) > 0;
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return false;
	}

	public double getAverageRating(int courseId) {
		String query = "SELECT AVG(rating) FROM Feedback WHERE course_id = ?";
		try (Connection conn = DatabaseConnection.getConnection();
				PreparedStatement stmt = conn.prepareStatement(query)) {
			stmt.setInt(1, courseId);
			ResultSet rs = stmt.executeQuery();
			if (rs.next()) {
				return rs.getDouble(1);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return 0;
	}

//	 public List<Feedback> getRandomFeedbacks(int courseId) {
//	        List<Feedback> feedbacks = new ArrayList<>();
//	        String query = "SELECT feedback_id, student_id, course_id, rating, DBMS_LOB.SUBSTR(course_feedback, 4000, 1) AS feedback, created_at FROM Feedback WHERE course_id = ? ORDER BY DBMS_RANDOM.VALUE FETCH FIRST 5 ROWS ONLY";
//
//	        try (Connection con = DatabaseConnection.getConnection();
//	             PreparedStatement ps = con.prepareStatement(query)) {
//	            ps.setInt(1, courseId);
//	            ResultSet rs = ps.executeQuery();
//
//	            while (rs.next()) {
//	                String feedbackText = rs.getString("course_feedback"); // Retrieve CLOB as string
//	                if (feedbackText == null || feedbackText.trim().isEmpty()) {
//	                    feedbackText = "No feedback provided"; // Handle NULL or empty case
//	                }
//
//	                Feedback fb = new Feedback(
//	                    rs.getInt("feedback_id"),
//	                    rs.getInt("student_id"),
//	                    rs.getInt("course_id"),
//	                    rs.getInt("rating"),
//	                    feedbackText, // Use retrieved feedback
//	                    rs.getTimestamp("created_at")
//	                );
//
//	                feedbacks.add(fb);
//	                System.out.println("Retrieved Feedback: " + fb.getCourseFeedback()); // Debugging
//	            }
//	        } catch (Exception e) {
//	            e.printStackTrace();
//	        }
//	        return feedbacks;
//	    }
}
