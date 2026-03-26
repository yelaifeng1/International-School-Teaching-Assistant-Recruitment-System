package com.group50.apply.servlet;

import com.google.gson.Gson;
import com.group50.apply.dao.ApplicationDAO;
import com.group50.apply.model.Application;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;
import java.util.Set;

@WebServlet("/apply/admin")
public class AdminApplicationServlet extends HttpServlet {

    private static final Set<String> VALID_STATUSES = Set.of("PENDING", "APPROVED", "REJECTED");

    private final Gson gson = new Gson();

    private boolean isAdmin(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        return session != null && "ADMIN".equalsIgnoreCase((String) session.getAttribute("role"));
    }

    /** GET /apply/admin — 返回全部申请 */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (!isAdmin(req)) { resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED); return; }

        List<Application> all = ApplicationDAO.getAllApplications();
        resp.setContentType("application/json; charset=UTF-8");
        resp.getWriter().write(gson.toJson(all));
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

        Application existing = ApplicationDAO.getByApplicationId(applicationId.trim());
        if (existing == null) {
            resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
            resp.getWriter().write("{\"success\":false,\"error\":\"申请记录不存在\"}");
            return;
        }

        boolean ok = ApplicationDAO.delete(applicationId.trim());
        if (ok) {
            resp.getWriter().write("{\"success\":true}");
        } else {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("{\"success\":false,\"error\":\"删除写入失败\"}");
        }
    }

    private void handleUpdate(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String applicationId     = req.getParameter("applicationId");
        String applicantId       = req.getParameter("applicantId");
        String jobId             = req.getParameter("jobId");
        String applyDate         = req.getParameter("applyDate");
        String personalStatement = req.getParameter("personalStatement");
        String status            = req.getParameter("status");

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

        Application existing = ApplicationDAO.getByApplicationId(applicationId.trim());
        if (existing == null) {
            resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
            resp.getWriter().write("{\"success\":false,\"error\":\"申请记录不存在\"}");
            return;
        }

        // 在已有对象上逐字段覆盖，保留未传入字段的原值
        if (applicantId       != null) existing.setApplicantId(applicantId.trim());
        if (jobId             != null) existing.setJobId(jobId.trim());
        if (applyDate         != null) existing.setApplyDate(applyDate.trim());
        if (personalStatement != null) existing.setPersonalStatement(personalStatement.trim());
        if (status            != null) existing.setStatus(status.toUpperCase());

        boolean ok = ApplicationDAO.update(existing);
        if (ok) {
            resp.getWriter().write("{\"success\":true}");
        } else {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("{\"success\":false,\"error\":\"更新写入失败\"}");
        }
    }
}