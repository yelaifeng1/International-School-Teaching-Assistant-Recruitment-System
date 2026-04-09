package com.example.tasystem.filter;

import com.example.tasystem.model.User;
import com.example.tasystem.service.AppServices;
import com.example.tasystem.util.Roles;
import com.example.tasystem.util.SessionUtil;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@WebFilter("/*")
public class AuthenticationFilter implements Filter {
    @Override
    public void init(FilterConfig filterConfig) {
        // No-op.
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        httpRequest.setCharacterEncoding("UTF-8");
        httpResponse.setCharacterEncoding("UTF-8");

        String contextPath = httpRequest.getContextPath();
        String path = httpRequest.getRequestURI().substring(contextPath.length());

        String legacyRedirect = legacyRedirect(path, httpRequest);
        if (legacyRedirect != null) {
            httpResponse.sendRedirect(contextPath + legacyRedirect);
            return;
        }

        if (isPublicPath(path)) {
            chain.doFilter(request, response);
            return;
        }

        AppServices services = (AppServices) httpRequest.getServletContext().getAttribute(AppServices.ATTRIBUTE);
        String userId = SessionUtil.currentUserId(httpRequest);
        if (userId == null) {
            httpResponse.sendRedirect(contextPath + "/login");
            return;
        }

        User currentUser = services.getAuthService().findById(userId).orElse(null);
        if (currentUser == null) {
            SessionUtil.signOut(httpRequest, httpResponse);
            httpResponse.sendRedirect(contextPath + "/login");
            return;
        }

        if (path.startsWith("/applicant/") && !Roles.isApplicant(currentUser.getRole())) {
            httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        if (path.startsWith("/mo/") && !Roles.isManager(currentUser.getRole())) {
            httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        if (path.startsWith("/admin/") && !Roles.isAdmin(currentUser.getRole())) {
            httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        if (path.startsWith("/applications") && !Roles.isApplicant(currentUser.getRole())) {
            httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        request.setAttribute("currentUser", currentUser);
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // No-op.
    }

    private boolean isPublicPath(String path) {
        return "/".equals(path)
                || "/index.jsp".equals(path)
                || "/login".equals(path)
                || "/register".equals(path)
                || path.startsWith("/assets/");
    }

    private String legacyRedirect(String path, HttpServletRequest request) {
        switch (path) {
            case "/login.jsp":
                return "/login";
            case "/register.jsp":
                return "/register";
            case "/jobList.jsp":
                return "/jobs";
            case "/jobDetail.jsp":
                String jobId = trim(request.getParameter("id"));
                if (jobId == null) {
                    jobId = trim(request.getParameter("jobId"));
                }
                return jobId == null
                        ? "/jobs"
                        : "/jobs/detail?id=" + URLEncoder.encode(jobId, StandardCharsets.UTF_8);
            case "/createJob.jsp":
                return "/mo/jobs/new";
            case "/manageJobs.jsp":
                return "/mo/jobs";
            case "/admin/dashboard.jsp":
                return "/admin/dashboard";
            case "/applicant/dashboard.jsp":
                return "/applicant/dashboard";
            case "/applicant/profile.jsp":
            case "/applicant/editProfile.jsp":
                return "/applicant/profile";
            case "/applicant/applications.jsp":
                return "/applicant/applications";
            case "/mo/dashboard.jsp":
                return "/mo/dashboard";
            default:
                return null;
        }
    }

    private String trim(String value) {
        if (value == null) {
            return null;
        }
        String trimmed = value.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }
}
