package com.example.tasystem.controller;

import com.example.tasystem.model.ServiceResult;
import com.example.tasystem.model.User;
import com.example.tasystem.model.Application;
import com.example.tasystem.util.FlashUtil;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/applications")
public class SubmitApplicationServlet extends BaseServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        User user = currentUser(request);
        String jobId = value(request, "jobId");
        ServiceResult<Application> result = services().getApplicationService()
                .submitApplication(user, jobId, request.getParameter("personalStatement"));

        if (result.isSuccess()) {
            FlashUtil.success(request, result.getMessage());
        } else {
            FlashUtil.error(request, result.getMessage());
        }

        redirect(request, response, "/jobs/detail?id=" + jobId);
    }
}
