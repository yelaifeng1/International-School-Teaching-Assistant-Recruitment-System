<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    // 检查用户是否已登录
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");
    Boolean registrationSuccess = (Boolean) session.getAttribute("registrationSuccess");
    
    if (username == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    // 清除注册成功标记（只显示一次）
    session.removeAttribute("registrationSuccess");
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>教学助手招聘系统 - 仪表板</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }
        
        .navbar {
            background: white;
            padding: 20px 40px;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }
        
        .navbar h2 {
            color: #333;
            font-size: 24px;
            margin: 0;
        }
        
        .navbar-right {
            display: flex;
            align-items: center;
            gap: 20px;
        }
        
        .user-info {
            color: #666;
            font-size: 14px;
        }
        
        .user-info strong {
            color: #333;
        }
        
        .logout-btn {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 6px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .logout-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(102, 126, 234, 0.4);
        }
        
        .container {
            max-width: 1000px;
            margin: 0 auto;
            background: white;
            border-radius: 10px;
            padding: 40px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1);
        }
        
        .welcome-section {
            text-align: center;
            margin-bottom: 40px;
        }
        
        .welcome-section h1 {
            color: #333;
            font-size: 32px;
            margin-bottom: 10px;
        }
        
        .welcome-section p {
            color: #666;
            font-size: 16px;
        }
        
        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-top: 30px;
        }
        
        .info-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            border-radius: 10px;
            text-align: center;
        }
        
        .info-card h3 {
            font-size: 14px;
            opacity: 0.8;
            margin-bottom: 10px;
        }
        
        .info-card p {
            font-size: 18px;
            font-weight: 600;
        }
        
        .success-alert {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
            padding: 15px 20px;
            border-radius: 6px;
            margin-bottom: 20px;
            animation: slideDown 0.4s ease-out;
        }
        
        @keyframes slideDown {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
    </style>
</head>
<body>
    <div class="navbar">
        <h2>😊 教学助手仪表板</h2>
        <div class="navbar-right">
            <div class="user-info">
                欢迎 <strong><%= username %></strong> | 角色: <strong>教学助手</strong>
            </div>
            <form action="<%= request.getContextPath() %>/logout" method="get" style="margin: 0;">
                <button type="submit" class="logout-btn">退出登录</button>
            </form>
        </div>
    </div>
    
    <div class="container">
        <% if (registrationSuccess != null && registrationSuccess) { %>
            <div class="success-alert">
                ✅ 恭喜！注册成功！现在您已自动登录。
            </div>
        <% } %>
        
        <div class="welcome-section">
            <h1>欢迎回来，<%= username %>！</h1>
            <p>这是您的个人仪表板，管理您的申请和档案。</p>
        </div>
        
        <div class="info-grid">
    <div class="info-card">
        <h3>我的申请</h3>
        <p>--</p>
    </div>
    <div class="info-card">
        <h3>申请状态</h3>
        <p>待审核</p>
    </div>
    <div class="info-card">
        <h3>消息通知</h3>
        <p>0</p>
    </div>

    <!-- 你添加的个人资料入口 -->
    <div class="info-card" onclick="window.location.href='applicant/profile.jsp'" style="cursor:pointer;">
        <h3>我的个人资料</h3>
        <p>点击查看</p>
    </div>
</div>
    </div>
</body>
</html>