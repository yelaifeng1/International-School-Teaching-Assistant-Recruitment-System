package com.group50.auth.servlet;

import com.group50.auth.model.User;
import com.group50.auth.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Optional;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("role") != null) {
            redirectByRole(String.valueOf(session.getAttribute("role")), req, resp);
            return;
        }

        req.getRequestDispatcher("/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");

        Optional<User> userOpt = userService.authenticate(username, password);
        if (userOpt.isEmpty()) {
            req.setAttribute("error", "用户名或密码错误，请重试。");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
            return;
        }

        User user = userOpt.get();
        HttpSession session = req.getSession(true);
        session.setAttribute("username", user.getUsername());
        session.setAttribute("displayName", user.getDisplayName());
        session.setAttribute("role", user.getRole());

        redirectByRole(user.getRole(), req, resp);
    }

    private void redirectByRole(String role, HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String normalizedRole = role == null ? "" : role.trim().toUpperCase();
        String contextPath = req.getContextPath();

        switch (normalizedRole) {
            case "TA" -> resp.sendRedirect(contextPath + "/applicant/dashboard.jsp");
            case "MO" -> resp.sendRedirect(contextPath + "/mo/dashboard.jsp");
            case "ADMIN" -> resp.sendRedirect(contextPath + "/admin/dashboard.jsp");
            default -> resp.sendRedirect(contextPath + "/login");
        }
    }
}
