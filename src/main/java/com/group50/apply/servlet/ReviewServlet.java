package com.group50.apply.servlet;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.group50.apply.model.Application;
import com.group50.apply.service.ApplicationService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;
import java.util.Set;

@WebServlet("/apply/review")
public class ReviewServlet extends HttpServlet {

    private static final Set<String> VALID_STATUSES = Set.of("APPROVED", "REJECTED", "PENDING");

    private final ApplicationService service = new ApplicationService();
    private final ObjectMapper mapper = new ObjectMapper();

    /** GET /apply/review — MO 获取全部申请（JSON） */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || !"MO".equalsIgnoreCase((String) session.getAttribute("role"))) {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        List<Application> all = service.getAll();
        resp.setContentType("application/json; charset=UTF-8");
        mapper.writeValue(resp.getWriter(), all);
    }

    /** POST /apply/review — MO 修改某条申请的审核状态 */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession(false);
        if (session == null || !"MO".equalsIgnoreCase((String) session.getAttribute("role"))) {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        String applicationId = req.getParameter("applicationId");
        String newStatus = req.getParameter("status");

        resp.setContentType("application/json; charset=UTF-8");

        if (applicationId == null || applicationId.isBlank()) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"success\":false,\"error\":\"缺少 applicationId\"}");
            return;
        }
        if (newStatus == null || !VALID_STATUSES.contains(newStatus.toUpperCase())) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"success\":false,\"error\":\"无效的状态值\"}");
            return;
        }

        boolean updated = service.updateStatus(applicationId.trim(), newStatus.toUpperCase());

        if (updated) {
            resp.getWriter().write("{\"success\":true}");
        } else {
            resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
            resp.getWriter().write("{\"success\":false,\"error\":\"申请记录不存在\"}");
        }
    }
}
