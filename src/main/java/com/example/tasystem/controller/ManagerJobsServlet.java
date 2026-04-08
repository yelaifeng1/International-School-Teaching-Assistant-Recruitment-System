package com.example.tasystem.controller;

import com.example.tasystem.model.ApplicationView;
import com.example.tasystem.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Map;
import java.util.stream.Collectors;

@WebServlet("/mo/jobs")
public class ManagerJobsServlet extends BaseServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = currentUser(request);
        var jobs = services().getJobService().listJobsForManager(user);
        var applications = services().getApplicationService().listManagerApplications(user);
        Map<String, Long> applicationCounts = applications.stream()
                .collect(Collectors.groupingBy(ApplicationView::getJobId, Collectors.counting()));
        Map<String, Long> pendingCounts = applications.stream()
                .filter(view -> "PENDING".equals(view.getStatus()))
                .collect(Collectors.groupingBy(ApplicationView::getJobId, Collectors.counting()));

        request.setAttribute("jobs", jobs);
        request.setAttribute("applicationCounts", applicationCounts);
        request.setAttribute("pendingCounts", pendingCounts);
        render("mo/jobs.jsp", request, response);
    }
}
