package com.example.tasystem.controller;

import com.example.tasystem.model.Applicant;
import com.example.tasystem.model.ServiceResult;
import com.example.tasystem.model.User;
import com.example.tasystem.util.FlashUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/applicant/profile")
public class ApplicantProfileServlet extends BaseServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("profile", services().getApplicantService().getOrCreateProfile(currentUser(request)));
        render("applicant/profile.jsp", request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = currentUser(request);
        ServiceResult<Applicant> result = services().getApplicantService().saveProfile(
                user,
                value(request, "fullName"),
                value(request, "studentId"),
                value(request, "email"),
                value(request, "phone"),
                value(request, "skills"),
                value(request, "availability"),
                value(request, "cvPath")
        );

        if (!result.isSuccess()) {
            Applicant profile = services().getApplicantService().getOrCreateProfile(user);
            profile.setFullName(value(request, "fullName"));
            profile.setStudentId(value(request, "studentId"));
            profile.setEmail(value(request, "email"));
            profile.setPhone(value(request, "phone"));
            profile.setSkills(value(request, "skills"));
            profile.setAvailability(value(request, "availability"));
            profile.setCvPath(value(request, "cvPath"));
            request.setAttribute("profile", profile);
            request.setAttribute("error", result.getMessage());
            render("applicant/profile.jsp", request, response);
            return;
        }

        FlashUtil.success(request, result.getMessage());
        redirect(request, response, "/applicant/profile");
    }
}
