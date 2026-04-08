package com.example.tasystem.controller;

import com.example.tasystem.model.FlashMessage;
import com.example.tasystem.model.User;
import com.example.tasystem.service.AppServices;
import com.example.tasystem.util.FlashUtil;
import com.example.tasystem.util.Roles;
import com.example.tasystem.util.SessionUtil;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public abstract class BaseServlet extends HttpServlet {
    protected AppServices services() {
        return (AppServices) getServletContext().getAttribute(AppServices.ATTRIBUTE);
    }

    protected User currentUser(HttpServletRequest request) {
        Object currentUser = request.getAttribute("currentUser");
        if (currentUser instanceof User) {
            return (User) currentUser;
        }

        String userId = SessionUtil.currentUserId(request);
        if (userId == null) {
            return null;
        }

        return services().getAuthService().findById(userId).orElse(null);
    }

    protected void render(String view, HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        exposeSharedAttributes(request);
        request.getRequestDispatcher("/WEB-INF/views/" + view).forward(request, response);
    }

    protected void redirect(HttpServletRequest request, HttpServletResponse response, String path) throws IOException {
        response.sendRedirect(request.getContextPath() + path);
    }

    protected String value(HttpServletRequest request, String name) {
        String value = request.getParameter(name);
        return value == null ? "" : value.trim();
    }

    protected String dashboardPath(String role) {
        if (Roles.isApplicant(role)) {
            return "/applicant/dashboard";
        }
        if (Roles.isManager(role)) {
            return "/mo/dashboard";
        }
        return "/admin/dashboard";
    }

    private void exposeSharedAttributes(HttpServletRequest request) {
        FlashMessage flash = FlashUtil.consume(request);
        if (flash != null) {
            request.setAttribute("flash", flash);
        }
        if (currentUser(request) != null) {
            request.setAttribute("roleLabel", Roles.label(currentUser(request).getRole()));
        }
    }
}
