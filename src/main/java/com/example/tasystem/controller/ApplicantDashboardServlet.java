package com.example.tasystem.controller;

import com.example.tasystem.model.Applicant;
import com.example.tasystem.model.User;
import com.example.tasystem.model.WorkloadView;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/applicant/dashboard")
public class ApplicantDashboardServlet extends BaseServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = currentUser(request);
        Applicant profile = services().getApplicantService().getOrCreateProfile(user);
        List<WorkloadView> assignments = services().getApplicationService().listApplicantAssignments(user);

        request.setAttribute("profile", profile);
        request.setAttribute("openJobsCount", services().getJobService().listOpenJobs().size());
        request.setAttribute("applicationCount", services().getApplicationService().listApplicantApplications(user).size());
        request.setAttribute("assignmentCount", assignments.size());
        request.setAttribute("profileComplete", profile.isComplete());
        request.setAttribute("assignments", assignments);
        render("applicant/dashboard.jsp", request, response);
    }
}
