package com.group50.tasystem.profile.controller

import com.group50.dao.ApplicantDAO;
import com.group50.model.Applicant;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/applicant/profile")
public class ProfileServlet extends HttpServlet {
    private final ApplicantDAO dao = new ApplicantDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String studentId = "S2026001"; // 模拟当前登录用户
        Applicant applicant = dao.getByStudentId(studentId);

        if (applicant == null) {
            applicant = new Applicant();
            applicant.setStudentId(studentId);
        }

        req.setAttribute("applicant", applicant);
        req.getRequestDispatcher("/applicant/profile.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String studentId = req.getParameter("studentId");
        String name = req.getParameter("name");
        String email = req.getParameter("email");
        String phone = req.getParameter("phone");
        String skills = req.getParameter("skills");
        String availability = req.getParameter("availability");

        Applicant a = new Applicant();
        a.setStudentId(studentId);
        a.setName(name);
        a.setEmail(email);
        a.setPhone(phone);
        a.setSkills(skills);
        a.setAvailability(availability);

        dao.save(a);
        resp.sendRedirect("profile");
    }
}