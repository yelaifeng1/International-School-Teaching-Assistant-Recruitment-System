package com.example.tasystem.controller;

import com.example.tasystem.model.ServiceResult;
import com.example.tasystem.model.User;
import com.example.tasystem.util.FlashUtil;
import com.example.tasystem.util.SessionUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends BaseServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        render("auth/register.jsp", request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = value(request, "username");
        String email = value(request, "email");
        String role = value(request, "role");
        String password = request.getParameter("password");

        ServiceResult<User> result = services().getAuthService().register(username, password, role, email);
        if (!result.isSuccess()) {
            request.setAttribute("error", result.getMessage());
            request.setAttribute("username", username);
            request.setAttribute("email", email);
            request.setAttribute("role", role);
            render("auth/register.jsp", request, response);
            return;
        }

        SessionUtil.signIn(request, response, result.getData(), false);
        FlashUtil.success(request, "Registration successful. Your account is ready.");
        redirect(request, response, dashboardPath(result.getData().getRole()));
    }
}
