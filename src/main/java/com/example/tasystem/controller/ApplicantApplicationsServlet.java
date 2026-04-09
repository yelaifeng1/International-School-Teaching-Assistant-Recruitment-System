package com.example.tasystem.controller;

import com.example.tasystem.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/applicant/applications")
public class ApplicantApplicationsServlet extends BaseServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = currentUser(request);
        request.setAttribute("applications", services().getApplicationService().listApplicantApplications(user));
        request.setAttribute("assignments", services().getApplicationService().listApplicantAssignments(user));
        render("applicant/applications.jsp", request, response);
    }
}
