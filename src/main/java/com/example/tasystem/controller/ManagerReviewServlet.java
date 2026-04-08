package com.example.tasystem.controller;

import com.example.tasystem.model.Application;
import com.example.tasystem.model.ServiceResult;
import com.example.tasystem.util.FlashUtil;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/mo/applications/review")
public class ManagerReviewServlet extends BaseServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        ServiceResult<Application> result = services().getApplicationService().reviewApplication(
                currentUser(request),
                value(request, "applicationId"),
                value(request, "status"),
                value(request, "reviewerComment")
        );

        if (result.isSuccess()) {
            FlashUtil.success(request, result.getMessage());
        } else {
            FlashUtil.error(request, result.getMessage());
        }

        redirect(request, response, "/mo/applications");
    }
}
