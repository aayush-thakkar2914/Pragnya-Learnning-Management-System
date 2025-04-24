package com.lms.controllers;

import java.io.IOException;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.lms.dao.CourseMaterialDAO;
import com.lms.models.CourseMaterial;
import com.lms.models.User;

@WebServlet("/viewMaterials")
public class ViewMaterialsServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!"STUDENT".equals(user.getRole())) {
            response.sendRedirect("dashboard.jsp");
            return;
        }

        CourseMaterialDAO materialDAO = new CourseMaterialDAO();
        List<CourseMaterial> materials = materialDAO.getMaterialsByStudent(user.getUserId());

        request.setAttribute("materials", materials);
        RequestDispatcher dispatcher = request.getRequestDispatcher("viewMaterials.jsp");
        dispatcher.forward(request, response);
    }
}
