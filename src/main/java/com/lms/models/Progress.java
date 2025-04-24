package com.lms.models;

public class Progress {
    private int progressId;
    private int studentId;
    private int courseId;
    private double completionPercentage;

    // Constructor
    public Progress(int progressId, int studentId, int courseId, double completionPercentage) {
        this.progressId = progressId;
        this.studentId = studentId;
        this.courseId = courseId;
        this.completionPercentage = completionPercentage;
    }

    // Getters and Setters
    public int getProgressId() {
        return progressId;
    }

    public void setProgressId(int progressId) {
        this.progressId = progressId;
    }

    public int getStudentId() {
        return studentId;
    }

    public void setStudentId(int studentId) {
        this.studentId = studentId;
    }

    public int getCourseId() {
        return courseId;
    }

    public void setCourseId(int courseId) {
        this.courseId = courseId;
    }

    public double getCompletionPercentage() {
        return completionPercentage;
    }

    public void setCompletionPercentage(double completionPercentage) {
        this.completionPercentage = completionPercentage;
    }
}
