package com.group50.tasystem.controller;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * 退出登录 Servlet
 * 负责处理用户退出登录请求，清空会话和 cookie
 */
@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        // 获取当前会话
        HttpSession session = request.getSession(false);
        
        // 清空会话数据
        if (session != null) {
            session.invalidate();
        }

        // 清空记住我 cookie
        Cookie userCookie = new Cookie("username", "");
        userCookie.setMaxAge(0);
        response.addCookie(userCookie);

        // 设置响应编码
        response.setCharacterEncoding("UTF-8");
        
        // 重定向到登录页或首页
        response.sendRedirect(request.getContextPath() + "/login.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        // 支持 POST 方式退出登录
        doGet(request, response);
    }
}
