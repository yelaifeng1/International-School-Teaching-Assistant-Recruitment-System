package com.example.tasystem.controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/mo/applications")
public class ManagerApplicationsServlet extends BaseServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("applications", services().getApplicationService().listManagerApplications(currentUser(request)));
        render("mo/applications.jsp", request, response);
    }
}
