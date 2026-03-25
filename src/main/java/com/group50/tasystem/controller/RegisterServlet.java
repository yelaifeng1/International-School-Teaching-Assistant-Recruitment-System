package com.group50.tasystem.controller;

import com.group50.tasystem.dao.UserDAO;
import com.group50.tasystem.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.Optional;

/**
 * 用户注册 Servlet
 * 负责处理用户注册请求，验证数据并保存新用户
 */
@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 设置请求和响应编码
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        // 获取表单参数
        String fullname = request.getParameter("fullname");
        String email = request.getParameter("email");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm-password");
        String role = request.getParameter("role");
        String terms = request.getParameter("terms");

        // 服务端验证数据
        String error = validateRegistrationData(fullname, email, username, password, confirmPassword, role, terms);

        if (error != null) {
            // 验证失败，返回错误信息并保留用户输入
            request.setAttribute("error", error);
            request.setAttribute("fullname", fullname);
            request.setAttribute("email", email);
            request.setAttribute("username", username);
            request.setAttribute("role", role);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        // 尝试创建新用户
        Optional<User> newUser = UserDAO.addUser(fullname, email, username, password, normalizeRole(role));

        if (newUser.isPresent()) {
            // 注册成功，自动登录
            User user = newUser.get();
            
            // 创建会话并存储用户信息
            HttpSession session = request.getSession();
            session.setAttribute("userId", user.getUserId());
            session.setAttribute("username", user.getUsername());
            session.setAttribute("role", user.getRole());
            session.setAttribute("email", user.getEmail());
            session.setAttribute("registrationSuccess", true);  // 注册成功标记

            // 根据角色进行跳转
            String userRole = user.getRole();
            switch (userRole) {
                case "TA":
                case "applicant":
                    response.sendRedirect(request.getContextPath() + "/applicant/dashboard.jsp");
                    break;
                case "MO":
                case "manager":
                    response.sendRedirect(request.getContextPath() + "/mo/dashboard.jsp");
                    break;
                case "ADMIN":
                case "admin":
                    response.sendRedirect(request.getContextPath() + "/admin/dashboard.jsp");
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/index.jsp");
            }
        } else {
            // 注册失败（通常是用户名已存在）
            request.setAttribute("error", "用户名已存在，请选择其他用户名！");
            request.setAttribute("fullname", fullname);
            request.setAttribute("email", email);
            request.setAttribute("username", username);
            request.setAttribute("role", role);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 重定向到注册页面
        response.sendRedirect(request.getContextPath() + "/register.jsp");
    }

    /**
     * 验证注册数据
     * @return 如果数据有效返回 null，否则返回错误信息
     */
    private String validateRegistrationData(String fullname, String email, String username, 
                                           String password, String confirmPassword, String role, String terms) {
        
        // 验证真实姓名
        if (fullname == null || fullname.trim().isEmpty() || fullname.trim().length() < 2) {
            return "请输入有效的真实姓名（至少2个字符）！";
        }

        // 验证邮箱
        if (email == null || email.trim().isEmpty() || !isValidEmail(email.trim())) {
            return "请输入有效的电子邮箱地址！";
        }

        // 验证用户名
        if (username == null || username.trim().isEmpty() || username.trim().length() < 3 || username.trim().length() > 20) {
            return "用户名需要3-20个字符！";
        }

        // 检查用户名是否已存在
        if (UserDAO.isUsernameExists(username.trim())) {
            return "用户名已存在，请选择其他用户名！";
        }

        // 验证角色
        if (role == null || role.trim().isEmpty()) {
            return "请选择您的身份！";
        }

        // 验证密码
        if (password == null || password.length() < 8) {
            return "密码至少需要8个字符！";
        }

        if (!password.matches(".*[0-9].*") || !password.matches(".*[a-zA-Z].*")) {
            return "密码必须包含字母和数字！";
        }

        // 验证密码确认
        if (confirmPassword == null || !password.equals(confirmPassword)) {
            return "两次输入的密码不一致！";
        }

        // 验证服务条款
        if (terms == null || terms.isEmpty()) {
            return "请同意服务条款和隐私政策！";
        }

        return null;
    }

    /**
     * 验证电子邮箱格式
     */
    private boolean isValidEmail(String email) {
        String emailRegex = "^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$";
        return email.matches(emailRegex);
    }

    /**
     * 将表单中的角色值转换为系统中的角色值
     */
    private String normalizeRole(String role) {
        if (role == null) {
            return "TA";
        }
        
        switch (role.toLowerCase()) {
            case "applicant":
                return "TA";
            case "manager":
                return "MO";
            case "admin":
                return "ADMIN";
            default:
                return "TA";
        }
    }
}
