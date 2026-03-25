<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>系统登录</title>
    <style>
        body {
            font-family: "Microsoft YaHei", sans-serif;
            background: #f5f7fb;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
        }
        .card {
            width: 360px;
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
            padding: 28px;
        }
        h2 {
            margin-top: 0;
            margin-bottom: 20px;
        }
        .field {
            margin-bottom: 14px;
        }
        input {
            width: 100%;
            height: 38px;
            padding: 0 10px;
            border-radius: 6px;
            border: 1px solid #ced4da;
            box-sizing: border-box;
        }
        button {
            width: 100%;
            height: 40px;
            border: 0;
            border-radius: 6px;
            background: #0069d9;
            color: #fff;
            font-size: 15px;
            cursor: pointer;
        }
        .error {
            color: #d93025;
            margin-bottom: 10px;
            font-size: 14px;
        }
        .success {
            color: #188038;
            margin-bottom: 10px;
            font-size: 14px;
        }
        .hint {
            margin-top: 12px;
            color: #6c757d;
            font-size: 13px;
            line-height: 1.6;
        }
    </style>
</head>
<body>
<div class="card">
    <h2>TA 招聘系统登录</h2>

    <% String error = (String) request.getAttribute("error"); %>
    <% if (error != null) { %>
        <div class="error"><%= error %></div>
    <% } %>

    <% if ("1".equals(request.getParameter("logout"))) { %>
        <div class="success">你已安全退出登录。</div>
    <% } %>

    <form action="<%= request.getContextPath() %>/login" method="post">
        <div class="field">
            <input type="text" name="username" placeholder="用户名" required />
        </div>
        <div class="field">
            <input type="password" name="password" placeholder="密码" required />
        </div>
        <button type="submit">登录</button>
    </form>

    <div class="hint">
        Demo 测试账号：ta01 / 123456，mo01 / 123456，admin01 / admin123
    </div>
</div>
</body>
</html>
