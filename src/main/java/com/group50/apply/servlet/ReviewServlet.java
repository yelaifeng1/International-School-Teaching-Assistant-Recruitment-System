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

@WebServlet("/apply/review")
public class ReviewServlet extends HttpServlet {

    private static final Set<String> VALID_STATUSES = Set.of("APPROVED", "REJECTED", "PENDING");

    private final Gson gson = new Gson();

    /** GET /apply/review — MO 获取全部申请（JSON） */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || !"MO".equalsIgnoreCase((String) session.getAttribute("role"))) {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        // 直接调用 DAO，从 data/applications.json 读取全部申请
        List<Application> all = ApplicationDAO.getAllApplications();

        resp.setContentType("application/json; charset=UTF-8");
        resp.getWriter().write(gson.toJson(all));
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
        String newStatus     = req.getParameter("status");

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

        // 通过 DAO 查找目标申请
        Application app = ApplicationDAO.getByApplicationId(applicationId.trim());

        if (app == null) {
            resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
            resp.getWriter().write("{\"success\":false,\"error\":\"申请记录不存在\"}");
            return;
        }

        // 更新状态并写回 data/applications.json
        app.setStatus(newStatus.toUpperCase());
        boolean updated = ApplicationDAO.update(app);

        if (updated) {
            resp.getWriter().write("{\"success\":true}");
        } else {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("{\"success\":false,\"error\":\"写入失败\"}");
        }
    }
}