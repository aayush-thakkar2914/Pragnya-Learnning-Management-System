//MaterialProgressDAO.java
package com.lms.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.lms.utils.DatabaseConnection;

public class MaterialProgressDAO {

	public int getProgressPercentage(int userId, int courseId) {
		int percentage = 0;
		String sql = "SELECT COMPLETED_PERCENTAGE FROM Progress WHERE student_id = ? AND course_id = ?";
		try (Connection conn = DatabaseConnection.getConnection();
				PreparedStatement stmt = conn.prepareStatement(sql)) {
			stmt.setInt(1, userId);
			stmt.setInt(2, courseId);
			ResultSet rs = stmt.executeQuery();
			if (rs.next()) {
				percentage = rs.getInt("COMPLETED_PERCENTAGE");
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return percentage;
	}

	public void updateProgressPercentage(int studentId, int courseId) {
		String totalMaterialsQuery = "SELECT COUNT(*) FROM Course_Materials WHERE course_id = ?";
		String completedMaterialsQuery = "SELECT COUNT(*) FROM MaterialProgress WHERE student_id = ? AND material_id IN (SELECT material_id FROM Course_Materials WHERE course_id = ?) AND is_completed = 1";
		String updateProgressQuery = "MERGE INTO Progress p USING (SELECT ? AS student_id, ? AS course_id FROM dual) src "
				+ "ON (p.student_id = src.student_id AND p.course_id = src.course_id) "
				+ "WHEN MATCHED THEN UPDATE SET completed_percentage = ?, last_updated = CURRENT_TIMESTAMP "
				+ "WHEN NOT MATCHED THEN INSERT (student_id, course_id, completed_percentage) VALUES (?, ?, ?)";

		try (Connection conn = DatabaseConnection.getConnection();
				PreparedStatement totalStmt = conn.prepareStatement(totalMaterialsQuery);
				PreparedStatement completedStmt = conn.prepareStatement(completedMaterialsQuery);
				PreparedStatement updateStmt = conn.prepareStatement(updateProgressQuery)) {

			totalStmt.setInt(1, courseId);
			try (ResultSet totalRs = totalStmt.executeQuery()) {
				if (totalRs.next()) {
					int totalCount = totalRs.getInt(1);

					if (totalCount == 0)
						return; // No materials in this course

					completedStmt.setInt(1, studentId);
					completedStmt.setInt(2, courseId);

					try (ResultSet completedRs = completedStmt.executeQuery()) {
						int completedCount = completedRs.next() ? completedRs.getInt(1) : 0;
						int completedPercentage = (int) ((completedCount / (double) totalCount) * 100);

						updateStmt.setInt(1, studentId);
						updateStmt.setInt(2, courseId);
						updateStmt.setInt(3, completedPercentage);
						updateStmt.setInt(4, studentId);
						updateStmt.setInt(5, courseId);
						updateStmt.setInt(6, completedPercentage);
						updateStmt.executeUpdate();
					}
				}
			}

		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	public boolean updateProgress(int studentId, int materialId, boolean completed) {
		boolean success = false;
		String checkQuery = "SELECT COUNT(*) FROM MaterialProgress WHERE student_id = ? AND material_id = ?";
		String insertQuery = "INSERT INTO MaterialProgress (student_id, material_id, is_completed) VALUES (?, ?, ?)";
		String updateQuery = "UPDATE MaterialProgress SET is_completed = ? WHERE student_id = ? AND material_id = ?";
		String getCourseIdQuery = "SELECT course_id FROM Course_Materials WHERE material_id = ?";

		try (Connection conn = DatabaseConnection.getConnection();
				PreparedStatement checkStmt = conn.prepareStatement(checkQuery);
				PreparedStatement courseStmt = conn.prepareStatement(getCourseIdQuery)) {

			conn.setAutoCommit(false); // Start transaction

			// Fetch course ID
			int courseId = 0;
			courseStmt.setInt(1, materialId);
			try (ResultSet courseRs = courseStmt.executeQuery()) {
				if (courseRs.next()) {
					courseId = courseRs.getInt(1);
				}
			}

			// Check if progress entry exists
			checkStmt.setInt(1, studentId);
			checkStmt.setInt(2, materialId);
			try (ResultSet rs = checkStmt.executeQuery()) {
				rs.next();
				int count = rs.getInt(1);

				if (count == 0) {
					try (PreparedStatement insertStmt = conn.prepareStatement(insertQuery)) {
						insertStmt.setInt(1, studentId);
						insertStmt.setInt(2, materialId);
						insertStmt.setInt(3, completed ? 1 : 0);
						success = insertStmt.executeUpdate() > 0;
					}
				} else {
					try (PreparedStatement updateStmt = conn.prepareStatement(updateQuery)) {
						updateStmt.setInt(1, completed ? 1 : 0);
						updateStmt.setInt(2, studentId);
						updateStmt.setInt(3, materialId);
						success = updateStmt.executeUpdate() > 0;
					}
				}
			}

			updateProgressPercentage(studentId, courseId);
			conn.commit(); // Commit transaction

		} catch (SQLException e) {
			e.printStackTrace();
			try (Connection conn = DatabaseConnection.getConnection()) {
				conn.rollback(); // Rollback on failure
			} catch (SQLException rollbackEx) {
				rollbackEx.printStackTrace();
			}
		}

		return success;
	}

	public int getCourseIdFromMaterial(int materialId) throws SQLException {
	    int courseId = -1;
	    String sql = "SELECT course_id FROM Course_Materials WHERE material_id = ?";

	    try (Connection conn = DatabaseConnection.getConnection();
	         PreparedStatement stmt = conn.prepareStatement(sql)) {
	        stmt.setInt(1, materialId);
	        try (ResultSet rs = stmt.executeQuery()) { // Ensure proper closing of ResultSet
	            if (rs.next()) {
	                courseId = rs.getInt("course_id");
	            }
	        }
	    }
	    return courseId;
	}
}
