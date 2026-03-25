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
import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

@WebServlet("/apply/applications")
public class ApplicationServlet extends HttpServlet {

    private final ApplicationService service = new ApplicationService();
    private final ObjectMapper mapper = new ObjectMapper();

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
        List<Application> apps = service.getByApplicantId(applicantId);

        resp.setContentType("application/json; charset=UTF-8");
        mapper.writeValue(resp.getWriter(), apps);
    }

    /** POST /apply/applications — 提交新申请，存入 applications.json */
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

        if (jobId == null || jobId.isBlank() || personalStatement == null || personalStatement.isBlank()) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.setContentType("application/json; charset=UTF-8");
            resp.getWriter().write("{\"success\":false,\"error\":\"jobId 和 personalStatement 不能为空\"}");
            return;
        }

        Application app = new Application();
        app.setApplicationId(UUID.randomUUID().toString());
        app.setApplicantId((String) session.getAttribute("username"));
        app.setJobId(jobId.trim());
        app.setApplyDate(LocalDate.now().toString());
        app.setPersonalStatement(personalStatement.trim());
        app.setStatus("PENDING");

        service.save(app);

        resp.setContentType("application/json; charset=UTF-8");
        resp.getWriter().write(
            "{\"success\":true,\"applicationId\":\"" + app.getApplicationId() + "\"}"
        );
    }
}
