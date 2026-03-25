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

@WebServlet("/apply/admin")
public class AdminApplicationServlet extends HttpServlet {

    private static final Set<String> VALID_STATUSES = Set.of("PENDING", "APPROVED", "REJECTED");

    private final ApplicationService service = new ApplicationService();
    private final ObjectMapper mapper = new ObjectMapper();

    private boolean isAdmin(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        return session != null && "ADMIN".equalsIgnoreCase((String) session.getAttribute("role"));
    }

    /** GET /apply/admin — 返回全部申请 */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (!isAdmin(req)) { resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED); return; }

        List<Application> all = service.getAll();
        resp.setContentType("application/json; charset=UTF-8");
        mapper.writeValue(resp.getWriter(), all);
    }

    /**
     * POST /apply/admin
     *   action=update  → 全字段更新
     *   action=delete  → 删除
     */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        if (!isAdmin(req)) { resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED); return; }

        resp.setContentType("application/json; charset=UTF-8");
        String action = req.getParameter("action");

        if ("delete".equals(action)) {
            handleDelete(req, resp);
        } else if ("update".equals(action)) {
            handleUpdate(req, resp);
        } else {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"success\":false,\"error\":\"未知操作\"}");
        }
    }

    private void handleDelete(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String applicationId = req.getParameter("applicationId");
        if (applicationId == null || applicationId.isBlank()) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"success\":false,\"error\":\"缺少 applicationId\"}");
            return;
        }
        boolean ok = service.deleteApplication(applicationId.trim());
        if (ok) {
            resp.getWriter().write("{\"success\":true}");
        } else {
            resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
            resp.getWriter().write("{\"success\":false,\"error\":\"申请记录不存在\"}");
        }
    }

    private void handleUpdate(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String applicationId  = req.getParameter("applicationId");
        String applicantId    = req.getParameter("applicantId");
        String jobId          = req.getParameter("jobId");
        String applyDate      = req.getParameter("applyDate");
        String personalStatement = req.getParameter("personalStatement");
        String status         = req.getParameter("status");

        if (applicationId == null || applicationId.isBlank()) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"success\":false,\"error\":\"缺少 applicationId\"}");
            return;
        }
        if (status != null && !VALID_STATUSES.contains(status.toUpperCase())) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"success\":false,\"error\":\"无效的状态值\"}");
            return;
        }

        Application app = new Application();
        app.setApplicationId(applicationId.trim());
        app.setApplicantId(applicantId  != null ? applicantId.trim()          : "");
        app.setJobId(jobId              != null ? jobId.trim()                 : "");
        app.setApplyDate(applyDate      != null ? applyDate.trim()             : "");
        app.setPersonalStatement(personalStatement != null ? personalStatement.trim() : "");
        app.setStatus(status            != null ? status.toUpperCase()         : "PENDING");

        boolean ok = service.updateApplication(app);
        if (ok) {
            resp.getWriter().write("{\"success\":true}");
        } else {
            resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
            resp.getWriter().write("{\"success\":false,\"error\":\"申请记录不存在\"}");
        }
    }
}
