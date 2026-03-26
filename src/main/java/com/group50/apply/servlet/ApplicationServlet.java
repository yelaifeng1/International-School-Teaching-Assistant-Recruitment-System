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
import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

@WebServlet("/apply/applications")
public class ApplicationServlet extends HttpServlet {

    private final Gson gson = new Gson();

    /** GET /apply/applications — 返回当前 TA 的所有申请（JSON） */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || !"TA".equalsIgnoreCase((String) session.getAttribute("role"))) {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        String applicantId = (String) session.getAttribute("username");

        // 直接调用 DAO 层，从 data/applications.json 读取
        List<Application> apps = ApplicationDAO.getByApplicantId(applicantId);

        resp.setContentType("application/json; charset=UTF-8");
        resp.getWriter().write(gson.toJson(apps));
    }

    /** POST /apply/applications — 提交新申请，存入 data/applications.json */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession(false);
        if (session == null || !"TA".equalsIgnoreCase((String) session.getAttribute("role"))) {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        String jobId = req.getParameter("jobId");
        String personalStatement = req.getParameter("personalStatement");

        if (jobId == null || jobId.isBlank()
                || personalStatement == null || personalStatement.isBlank()) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.setContentType("application/json; charset=UTF-8");
            resp.getWriter().write(
                "{\"success\":false,\"error\":\"jobId 和 personalStatement 不能为空\"}");
            return;
        }

        Application app = new Application();
        app.setApplicationId(UUID.randomUUID().toString());
        app.setApplicantId((String) session.getAttribute("username"));
        app.setJobId(jobId.trim());
        app.setApplyDate(LocalDate.now().toString());
        app.setPersonalStatement(personalStatement.trim());
        app.setStatus("PENDING");

        // 直接调用 DAO 层，写入 data/applications.json
        ApplicationDAO.save(app);

        resp.setContentType("application/json; charset=UTF-8");
        resp.getWriter().write(
            "{\"success\":true,\"applicationId\":\"" + app.getApplicationId() + "\"}");
    }
}