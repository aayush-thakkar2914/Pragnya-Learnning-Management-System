package com.lms.models;

import java.sql.Timestamp;

public class Feedback {
    private int feedbackId;
    private int studentId;
    private int courseId;
    private int rating;
    private String courseFeedback;
    private Timestamp createdAt;

    public Feedback(int feedbackId, int studentId, int courseId, int rating, String courseFeedback, Timestamp createdAt) {
        this.feedbackId = feedbackId;
        this.studentId = studentId;
        this.courseId = courseId;
        this.rating = rating;
        this.courseFeedback = courseFeedback;
        this.createdAt = createdAt;
    }
    
    
    

    public Feedback(String courseFeedback) {
		super();
		this.courseFeedback = courseFeedback;
	}




	public Feedback(int studentId, int courseId, int rating, String courseFeedback) {
		super();
		this.studentId = studentId;
		this.courseId = courseId;
		this.rating = rating;
		this.courseFeedback = courseFeedback;
	}



	public int getFeedbackId() { return feedbackId; }
    public int getStudentId() { return studentId; }
    public int getCourseId() { return courseId; }
    public int getRating() { return rating; }
    public String getCourseFeedback() { return courseFeedback; }
    public Timestamp getCreatedAt() { return createdAt; }
}
