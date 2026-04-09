package com.example.tasystem.controller;

import com.example.tasystem.model.Job;
import com.example.tasystem.model.User;
import com.example.tasystem.util.Roles;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Optional;

@WebServlet("/jobs/detail")
public class JobDetailServlet extends BaseServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String jobId = value(request, "id");
        Optional<Job> job = services().getJobService().findById(jobId);
        if (job.isEmpty()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        User user = currentUser(request);
        boolean canApply = Roles.isApplicant(user.getRole())
                && services().getJobService().isOpenForApplications(job.get())
                && !services().getApplicationService().hasApplied(user, jobId);

        request.setAttribute("job", job.get());
        request.setAttribute("canApply", canApply);
        request.setAttribute("alreadyApplied", Roles.isApplicant(user.getRole()) && !canApply);
        render("jobs/detail.jsp", request, response);
    }
}
