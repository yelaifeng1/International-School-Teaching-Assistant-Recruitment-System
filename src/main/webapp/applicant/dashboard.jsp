<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String role = (String) session.getAttribute("role");
    if (role == null || !"TA".equalsIgnoreCase(role)) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>TA Dashboard</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: "Microsoft YaHei", "Segoe UI", Tahoma, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }
        .navbar {
            background: rgba(0, 0, 0, 0.1);
            backdrop-filter: blur(10px);
            color: #fff;
            padding: 16px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }
        .navbar-title {
            font-size: 22px;
            font-weight: bold;
            letter-spacing: 1px;
        }
        .navbar-role {
            background: rgba(255, 255, 255, 0.2);
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 14px;
        }
        .container {
            flex: 1;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 40px 20px;
        }
        .card {
            background: #fff;
            border-radius: 16px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            padding: 50px;
            text-align: center;
            max-width: 500px;
            width: 100%;
            animation: slideUp 0.6s ease-out;
        }
        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        .avatar {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 40px;
            color: #fff;
            margin: 0 auto 20px;
        }
        h1 {
            color: #333;
            font-size: 28px;
            margin-bottom: 10px;
        }
        .username {
            color: #667eea;
            font-size: 18px;
            font-weight: bold;
            margin-bottom: 30px;
        }
        .info-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
            margin: 30px 0;
            padding: 20px 0;
            border-top: 1px solid #eee;
            border-bottom: 1px solid #eee;
        }
        .info-item {
            padding: 15px;
            background: #f8f9fa;
            border-radius: 10px;
        }
        .info-label {
            font-size: 12px;
            color: #999;
            margin-bottom: 5px;
        }
        .info-value {
            font-size: 16px;
            color: #333;
            font-weight: bold;
        }
        .action-buttons {
            display: flex;
            gap: 10px;
            margin-top: 30px;
        }
        .btn {
            flex: 1;
            padding: 12px 24px;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            cursor: pointer;
            transition: all 0.3s ease;
            font-weight: bold;
        }
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: #fff;
        }
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(102, 126, 234, 0.4);
        }
        .btn-logout {
            background: #f0f0f0;
            color: #666;
        }
        .btn-logout:hover {
            background: #e0e0e0;
            color: #333;
        }
        .footer {
            text-align: center;
            color: rgba(255, 255, 255, 0.7);
            padding: 20px;
            font-size: 12px;
        }
    </style>
</head>
<body>
<div class="navbar">
    <div class="navbar-title">TA 招聘系统</div>
    <div class="navbar-role">👤 TA 角色</div>
</div>

<div class="container">
    <div class="card">
        <div class="avatar">🎓</div>
        <h1>欢迎回来</h1>
        <div class="username"><%= session.getAttribute("displayName") %></div>
        
        <div class="info-grid">
            <div class="info-item">
                <div class="info-label">角色</div>
                <div class="info-value">Teaching Assistant</div>
            </div>
            <div class="info-item">
                <div class="info-label">状态</div>
                <div class="info-value">已登录</div>
            </div>
        </div>
        
        <p style="color: #999; margin: 20px 0; font-size: 14px;">
            你可以在这里管理你的 TA 申请和课程信息。
        </p>
        
        <div class="action-buttons">
            <button class="btn btn-primary">查看申请</button>
            <a href="<%= request.getContextPath() %>/logout" style="text-decoration: none;">
                <button class="btn btn-logout" style="width: 100%;">退出登录</button>
            </a>
        </div>
    </div>
</div>

<div class="footer">
    <p>TA Recruitment System | © 2026 Group 50</p>
</div>
</body>
</html>
