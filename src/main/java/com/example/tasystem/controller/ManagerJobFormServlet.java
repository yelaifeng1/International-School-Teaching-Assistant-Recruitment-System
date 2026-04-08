package com.example.tasystem.controller;

import com.example.tasystem.model.ServiceResult;
import com.example.tasystem.model.Job;
import com.example.tasystem.util.FlashUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/mo/jobs/new")
public class ManagerJobFormServlet extends BaseServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        render("mo/job-form.jsp", request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        ServiceResult<Job> result = services().getJobService().createJob(
                currentUser(request),
                value(request, "courseCode"),
                value(request, "courseName"),
                value(request, "requirements"),
                value(request, "deadline")
        );

        if (!result.isSuccess()) {
            request.setAttribute("error", result.getMessage());
            request.setAttribute("courseCode", value(request, "courseCode"));
            request.setAttribute("courseName", value(request, "courseName"));
            request.setAttribute("requirements", value(request, "requirements"));
            request.setAttribute("deadline", value(request, "deadline"));
            render("mo/job-form.jsp", request, response);
            return;
        }

        FlashUtil.success(request, result.getMessage());
        redirect(request, response, "/mo/jobs");
    }
}
