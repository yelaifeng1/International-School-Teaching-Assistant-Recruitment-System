package com.example.servlet;

import com.example.dao.JobRepository;
import com.example.model.Job;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.UUID;

@WebServlet("/jobs")
public class JobServlet extends HttpServlet {
    private JobRepository jobRepository;

    @Override
    public void init() throws ServletException {
        jobRepository = new JobRepository(getServletContext());
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String jobId = req.getParameter("jobId");
        if (jobId != null && !jobId.isEmpty()) {
            Job job = jobRepository.findById(jobId);
            if (job == null) {
                resp.sendError(404, "岗位不存在");
                return;
            }
            req.setAttribute("job", job);
            req.getRequestDispatcher("/jobDetail.jsp").forward(req, resp);
        } else {
            List<Job> jobs = jobRepository.findAll();
            HttpSession session = req.getSession(false);
            String role = (session != null) ? (String) session.getAttribute("role") : null;
            if (!"MO".equals(role)) {
                jobs.removeIf(job -> !"open".equals(job.getStatus()));
            }
            req.setAttribute("jobs", jobs);
            req.getRequestDispatcher("/jobList.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession(false);
        if (session == null || !"MO".equals(session.getAttribute("role"))) {
            resp.sendError(403, "只有模块负责人可以发布岗位");
            return;
        }

        String courseCode = req.getParameter("courseCode");
        String courseName = req.getParameter("courseName");
        String lecturerName = (String) session.getAttribute("name");
        String requirements = req.getParameter("requirements");
        String deadline = req.getParameter("deadline");

        if (courseCode == null || courseName == null || lecturerName == null ||
            requirements == null || deadline == null) {
            resp.sendError(400, "请填写所有字段");
            return;
        }

        Job job = new Job();
        job.setJobId(UUID.randomUUID().toString());
        job.setCourseCode(courseCode);
        job.setCourseName(courseName);
        job.setLecturerName(lecturerName);
        job.setRequirements(requirements);
        job.setDeadline(deadline);
        job.setStatus("open");

        jobRepository.add(job);
        resp.sendRedirect(req.getContextPath() + "/manageJobs.jsp");
    }
}