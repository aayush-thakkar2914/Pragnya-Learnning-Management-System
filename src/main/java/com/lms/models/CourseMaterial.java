package com.lms.models;

import java.sql.Timestamp;

public class CourseMaterial {
	private int materialId;
	private int courseId;
	private String fileName;
	private String fileType;
	private String filePath;
	private Timestamp uploadedAt;
	private String courseName;
	 private boolean isCompleted; 
	 
	 public CourseMaterial(int materialId, String fileName, String filePath, boolean isCompleted) {
	        this.materialId = materialId;
	        this.fileName = fileName;
	        this.filePath = filePath;
	        this.isCompleted = isCompleted;
	    }

	public CourseMaterial() {
		super();
		// TODO Auto-generated constructor stub
	}

	// Getters and Setters
	public int getMaterialId() {
		return materialId;
	}

	public void setMaterialId(int materialId) {
		this.materialId = materialId;
	}

	public int getCourseId() {
		return courseId;
	}

	public void setCourseId(int courseId) {
		this.courseId = courseId;
	}

	public String getFileName() {
		return fileName;
	}

	public void setFileName(String fileName) {
		this.fileName = fileName;
	}

	public String getFileType() {
		return fileType;
	}

	public void setFileType(String fileType) {
		this.fileType = fileType;
	}

	public String getFilePath() {
		return filePath;
	}

	public void setFilePath(String filePath) {
		this.filePath = filePath;
	}

	public Timestamp getUploadedAt() {
		return uploadedAt;
	}

	public void setUploadedAt(Timestamp uploadedAt) {
		this.uploadedAt = uploadedAt;
	}

	public String getCourseName() {
		return courseName;
	}

	public void setCourseName(String courseName) {
		this.courseName = courseName;
	}
	
	public boolean isCompleted() {
        return isCompleted;
    }

    public void setCompleted(boolean completed) {
        this.isCompleted = completed;
    }

	public CourseMaterial(int materialId, int courseId, String fileName, String filePath) {
		super();
		this.materialId = materialId;
		this.courseId = courseId;
		this.fileName = fileName;
		this.filePath = filePath;
	}
}
