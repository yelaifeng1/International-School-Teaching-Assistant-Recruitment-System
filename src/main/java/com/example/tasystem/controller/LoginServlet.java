package com.example.tasystem.controller;

import com.example.tasystem.model.User;
import com.example.tasystem.util.SessionUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Optional;

@WebServlet("/login")
public class LoginServlet extends BaseServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = currentUser(request);
        if (user != null) {
            redirect(request, response, dashboardPath(user.getRole()));
            return;
        }

        request.setAttribute("rememberedUsername", SessionUtil.rememberedUsername(request));
        render("auth/login.jsp", request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = value(request, "username");
        String password = request.getParameter("password");
        boolean remember = "on".equalsIgnoreCase(request.getParameter("remember"));

        Optional<User> user = services().getAuthService().authenticate(username, password);
        if (user.isEmpty()) {
            request.setAttribute("error", "Incorrect username or password.");
            request.setAttribute("rememberedUsername", username);
            render("auth/login.jsp", request, response);
            return;
        }

        SessionUtil.signIn(request, response, user.get(), remember);
        redirect(request, response, dashboardPath(user.get().getRole()));
    }
}
