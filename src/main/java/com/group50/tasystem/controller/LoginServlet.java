package com.group50.tasystem.controller;

import com.group50.tasystem.dao.UserDAO;
import com.group50.tasystem.model.User;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.Optional;

/**
 * 登录 Servlet
 * 负责处理用户登录请求，验证用户身份并按角色进行跳转
 */
@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 设置响应编码
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String rememberMe = request.getParameter("remember");

        // 验证登录
        Optional<User> user = UserDAO.validateLogin(username, password);

        if (user.isPresent()) {
            // 登录成功
            User loginUser = user.get();
            
            // 创建会话并存储用户信息
            HttpSession session = request.getSession();
            session.setAttribute("userId", loginUser.getUserId());
            session.setAttribute("username", loginUser.getUsername());
            session.setAttribute("role", loginUser.getRole());
            session.setAttribute("email", loginUser.getEmail());

            // 设置记住我功能（如果选中）
            if ("on".equals(rememberMe)) {
                // 创建 cookie，保存 7 天
                Cookie userCookie = new Cookie("username", username);
                userCookie.setMaxAge(7 * 24 * 60 * 60);
                response.addCookie(userCookie);
            }

            // 根据角色进行跳转
            String role = loginUser.getRole();
            switch (role) {
                case "TA":
                    response.sendRedirect(request.getContextPath() + "/applicant/dashboard.jsp");
                    break;
                case "MO":
                    response.sendRedirect(request.getContextPath() + "/mo/dashboard.jsp");
                    break;
                case "ADMIN":
                    response.sendRedirect(request.getContextPath() + "/admin/dashboard.jsp");
                    break;
                default:
                    // 未知角色，重定向到首页
                    response.sendRedirect(request.getContextPath() + "/index.jsp");
            }
        } else {
            // 登录失败，设置错误信息并转发回登录页面
            request.setAttribute("error", "用户名或密码错误，请重试");
            request.setAttribute("username", username);
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 重定向到登录页面
        response.sendRedirect(request.getContextPath() + "/login.jsp");
    }
}