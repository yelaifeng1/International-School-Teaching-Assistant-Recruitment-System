package com.group50.tasystem.controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if ("ta".equals(username) && "123".equals(password)) {
            response.sendRedirect("applicant/dashboard.jsp");
        } else if ("mo".equals(username) && "123".equals(password)) {
            response.sendRedirect("mo/dashboard.jsp");
        } else if ("admin".equals(username) && "123".equals(password)) {
            response.sendRedirect("admin/dashboard.jsp");
        } else {
            response.getWriter().write("Login failed.");
        }
    }
}