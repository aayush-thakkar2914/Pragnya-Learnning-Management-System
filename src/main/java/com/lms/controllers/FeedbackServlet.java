package com.lms.controllers;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.lms.dao.FeedbackDAO;
import com.lms.models.Feedback;
import com.google.gson.Gson;

@WebServlet("/feedback")
public class FeedbackServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try (PrintWriter out = response.getWriter()) {
            int studentId = Integer.parseInt(request.getParameter("studentId"));
            int courseId = Integer.parseInt(request.getParameter("courseId"));
            int rating = Integer.parseInt(request.getParameter("rating"));
            String feedbackText = request.getParameter("feedback");

            // Validate rating (should be between 1-5)
            if (rating < 1 || rating > 5) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.write("{\"success\": false, \"message\": \"Rating must be between 1 and 5.\"}");
                return;
            }

            // Trim and sanitize feedback text (prevent XSS)
            feedbackText = feedbackText.trim().replaceAll("<[^>]*>", "");

            FeedbackDAO dao = new FeedbackDAO();
            if (dao.hasGivenFeedback(studentId, courseId)) {
                response.setStatus(HttpServletResponse.SC_CONFLICT); // 409 Conflict
                out.write("{\"success\": false, \"message\": \"You have already given feedback for this course.\"}");
                return;
            }

            boolean success = dao.addFeedback(studentId, courseId, rating, feedbackText);
            if (success) {
                response.setStatus(HttpServletResponse.SC_CREATED); // 201 Created
                out.write("{\"success\": true, \"message\": \"Feedback submitted successfully.\"}");
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                out.write("{\"success\": false, \"message\": \"Failed to submit feedback.\"}");
            }
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            try (PrintWriter out = response.getWriter()) {
                out.write("{\"success\": false, \"message\": \"Invalid input. Please check your data.\"}");
            }
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try (PrintWriter out = response.getWriter()) {
            int courseId = Integer.parseInt(request.getParameter("courseId"));
            FeedbackDAO dao = new FeedbackDAO();

            double avgRating = dao.getAverageRating(courseId);
//            List<Feedback> feedbacks = dao.getRandomFeedbacks(courseId);

//            Gson gson = new Gson();
//            String jsonResponse = gson.toJson(feedbacks);

            out.print("{\"averageRating\": " + avgRating +  "}");
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse	.SC_BAD_REQUEST);
            try (PrintWriter out = response.getWriter()) {
                out.write("{\"success\": false, \"message\": \"Invalid course ID.\"}");
            }
        }
    }
}
