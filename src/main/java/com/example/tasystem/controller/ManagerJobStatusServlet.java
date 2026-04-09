package com.example.tasystem.controller;

import com.example.tasystem.model.Job;
import com.example.tasystem.model.ServiceResult;
import com.example.tasystem.util.FlashUtil;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/mo/jobs/status")
public class ManagerJobStatusServlet extends BaseServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        ServiceResult<Job> result = services().getJobService()
                .updateStatus(currentUser(request), value(request, "jobId"), value(request, "status"));

        if (result.isSuccess()) {
            FlashUtil.success(request, result.getMessage());
        } else {
            FlashUtil.error(request, result.getMessage());
        }

        redirect(request, response, "/mo/jobs");
    }
}
