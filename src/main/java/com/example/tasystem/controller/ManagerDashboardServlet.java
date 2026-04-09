package com.example.tasystem.controller;

import com.example.tasystem.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/mo/dashboard")
public class ManagerDashboardServlet extends BaseServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = currentUser(request);
        request.setAttribute("jobs", services().getJobService().listJobsForManager(user));
        request.setAttribute("applications", services().getApplicationService().listManagerApplications(user));
        request.setAttribute("assignments", services().getApplicationService().listManagerAssignments(user));
        request.setAttribute("openJobCount", services().getJobService().listJobsForManager(user).stream()
                .filter(job -> "OPEN".equals(job.getStatus()))
                .count());
        request.setAttribute("pendingCount", services().getApplicationService().countPendingForManager(user));
        render("mo/dashboard.jsp", request, response);
    }
}
