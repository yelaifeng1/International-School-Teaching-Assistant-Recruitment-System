package com.example.tasystem.controller;

import com.example.tasystem.model.User;
import com.example.tasystem.util.Roles;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends BaseServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<User> users = services().getAuthService().findAllUsers();
        request.setAttribute("users", users);
        request.setAttribute("jobs", services().getJobService().listAllJobs());
        request.setAttribute("applications", services().getApplicationService().listAllApplications());
        request.setAttribute("userCount", users.size());
        request.setAttribute("applicantCount", users.stream().filter(user -> Roles.isApplicant(user.getRole())).count());
        request.setAttribute("managerCount", users.stream().filter(user -> Roles.isManager(user.getRole())).count());
        request.setAttribute("adminCount", users.stream().filter(user -> Roles.isAdmin(user.getRole())).count());
        request.setAttribute("assignmentCount", services().getWorkloadDAO().findAll().size());
        render("admin/dashboard.jsp", request, response);
    }
}
