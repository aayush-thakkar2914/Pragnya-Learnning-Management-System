package com.lms.models;

import java.sql.Timestamp;

public class Course {
	private int courseId;
	private String title;
	private String description;
	private int instructorId;
	private Timestamp createdAt;
	private boolean isActive;

	public Course(int courseId, String title, String description, int instructorId, Timestamp createdAt) {
		this.courseId = courseId;
		this.title = title;
		this.description = description;
		this.instructorId = instructorId;
		this.createdAt = createdAt;
		this.isActive = false; // Default to inactive
	}

	public Course(int courseId, String title, String description, int instructorId, Timestamp createdAt,
			boolean isActive) {
		this.courseId = courseId;
		this.title = title;
		this.description = description;
		this.instructorId = instructorId;
		this.createdAt = createdAt;
		this.isActive = isActive;
	}

	public Course(int courseId, String title, String description) {
		super();
		this.courseId = courseId;
		this.title = title;
		this.description = description;
		this.isActive = false; // Default to inactive
	}

	public int getCourseId() {
		return courseId;
	}

	public String getTitle() {
		return title;
	}

	public String getDescription() {
		return description;
	}

	public int getInstructorId() {
		return instructorId;
	}

	public Timestamp getCreatedAt() {
		return createdAt;
	}

	public boolean isActive() {
		return isActive;
	}

	public void setActive(boolean isActive) {
		this.isActive = isActive;
	}
}