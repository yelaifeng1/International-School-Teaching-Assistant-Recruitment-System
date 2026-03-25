<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>教学助手招聘系统 - 注册</title>
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
            display: flex;
            justify-content: center;
            align-items: flex-start;
            position: relative;
            overflow-y: auto;
            padding: 40px 20px;
        }

        /* 背景装饰 */
        body::before {
            content: '';
            position: absolute;
            width: 300px;
            height: 300px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 50%;
            top: -100px;
            right: -100px;
            animation: float 6s ease-in-out infinite;
        }

        body::after {
            content: '';
            position: absolute;
            width: 200px;
            height: 200px;
            background: rgba(255, 255, 255, 0.08);
            border-radius: 50%;
            bottom: -50px;
            left: -50px;
            animation: float 8s ease-in-out infinite reverse;
        }

        @keyframes float {
            0%, 100% { transform: translateY(0px); }
            50% { transform: translateY(20px); }
        }

        .register-container {
            width: 100%;
            max-width: 500px;
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            padding: 50px 40px;
            position: relative;
            z-index: 1;
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

        .register-header {
            text-align: center;
            margin-bottom: 30px;
        }

        .register-header h1 {
            font-size: 28px;
            color: #333;
            margin-bottom: 8px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .register-header p {
            color: #999;
            font-size: 14px;
        }

        .icon {
            width: 80px;
            height: 80px;
            margin: 0 auto 15px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 40px;
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr;
            gap: 15px;
        }

        .form-row-two {
            grid-template-columns: 1fr 1fr;
        }

        .form-group {
            margin-bottom: 15px;
            position: relative;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #333;
            font-weight: 600;
            font-size: 14px;
        }

        .form-group input,
        .form-group select {
            width: 100%;
            padding: 12px 16px;
            border: 2px solid #e0e0e0;
            border-radius: 10px;
            font-size: 14px;
            transition: all 0.3s ease;
            background: #f9f9f9;
            font-family: inherit;
        }

        .form-group input:focus,
        .form-group select:focus {
            outline: none;
            border-color: #667eea;
            background: white;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        .form-group input::placeholder {
            color: #bbb;
        }

        .password-requirement {
            margin-top: 8px;
            font-size: 12px;
            color: #999;
        }

        .requirement-item {
            display: flex;
            align-items: center;
            margin: 4px 0;
        }

        .requirement-item::before {
            content: '○';
            margin-right: 6px;
            color: #ddd;
        }

        .requirement-item.met::before {
            content: '✓';
            color: #4CAF50;
        }

        .terms-checkbox {
            display: flex;
            align-items: flex-start;
            margin: 20px 0;
            gap: 8px;
        }

        .terms-checkbox input[type="checkbox"] {
            width: 18px;
            height: 18px;
            margin-top: 2px;
            cursor: pointer;
            accent-color: #667eea;
            flex-shrink: 0;
        }

        .terms-checkbox label {
            margin: 0;
            font-size: 13px;
            color: #666;
            cursor: pointer;
            line-height: 1.5;
        }

        .terms-checkbox a {
            color: #667eea;
            text-decoration: none;
        }

        .terms-checkbox a:hover {
            text-decoration: underline;
        }

        .register-btn {
            width: 100%;
            padding: 14px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-top: 20px;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
        }

        .register-btn:hover:not(:disabled) {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(102, 126, 234, 0.6);
        }

        .register-btn:disabled {
            opacity: 0.6;
            cursor: not-allowed;
        }

        .login-link {
            text-align: center;
            margin-top: 20px;
            padding-top: 20px;
            border-top: 1px solid #e0e0e0;
        }

        .login-link p {
            color: #666;
            font-size: 14px;
        }

        .login-link a {
            color: #667eea;
            text-decoration: none;
            font-weight: 600;
        }

        .login-link a:hover {
            color: #764ba2;
        }

        .error-message {
            display: none;
            background: #fee;
            border: 1px solid #fcc;
            color: #c33;
            padding: 12px;
            border-radius: 8px;
            margin-bottom: 15px;
            font-size: 14px;
            animation: slideDown 0.3s ease-out;
        }

        .success-message {
            display: none;
            background: #efe;
            border: 1px solid #cfc;
            color: #3c3;
            padding: 12px;
            border-radius: 8px;
            margin-bottom: 15px;
            font-size: 14px;
            animation: slideDown 0.3s ease-out;
        }

        @keyframes slideDown {
            from {
                opacity: 0;
                transform: translateY(-10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @media (max-width: 480px) {
            .register-container {
                max-width: 100%;
                padding: 35px 20px;
            }

            .register-header h1 {
                font-size: 24px;
            }

            .icon {
                width: 60px;
                height: 60px;
                font-size: 32px;
            }

            .form-row-two {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
<div class="register-container">
    <div class="register-header">
        <div class="icon">📝</div>
        <h1>创建账户</h1>
        <p>加入教学助手招聘系统</p>
    </div>

    <div id="errorMessage" class="error-message"></div>
    <div id="successMessage" class="success-message"></div>

    <%-- 显示服务器端错误信息 --%>
    <% 
        String error = (String) request.getAttribute("error");
        if (error != null) {
    %>
        <div class="error-message" style="display: block;">
            <%= error %>
        </div>
    <% 
        }
    %>

    <form action="${pageContext.request.contextPath}/register" method="post" onsubmit="return validateForm()">
        <div class="form-group">
            <label for="fullname">真实姓名 <span style="color: #e74c3c;">*</span></label>
            <input type="text" id="fullname" name="fullname" placeholder="请输入您的真实姓名" value="<%= (request.getAttribute("fullname") != null) ? request.getAttribute("fullname") : "" %>" required>
        </div>

        <div class="form-group">
            <label for="email">电子邮箱 <span style="color: #e74c3c;">*</span></label>
            <input type="email" id="email" name="email" placeholder="请输入有效的电子邮箱" value="<%= (request.getAttribute("email") != null) ? request.getAttribute("email") : "" %>" required>
        </div>

        <div class="form-row form-row-two">
            <div class="form-group">
                <label for="username">用户名 <span style="color: #e74c3c;">*</span></label>
                <input type="text" id="username" name="username" placeholder="3-20个字符" value="<%= (request.getAttribute("username") != null) ? request.getAttribute("username") : "" %>" required>
            </div>
            <div class="form-group">
                <label for="role">身份 <span style="color: #e74c3c;">*</span></label>
                <select id="role" name="role" required>
                    <option value="">--请选择--</option>
                    <option value="applicant" <%= "applicant".equals(request.getAttribute("role")) ? "selected" : "" %>>申请者</option>
                    <option value="admin" <%= "admin".equals(request.getAttribute("role")) ? "selected" : "" %>>管理员</option>
                    <option value="manager" <%= "manager".equals(request.getAttribute("role")) ? "selected" : "" %>>经理</option>
                </select>
            </div>
        </div>

        <div class="form-group">
            <label for="password">密码 <span style="color: #e74c3c;">*</span></label>
            <input type="password" id="password" name="password" placeholder="请输入安全密码" required oninput="checkPassword()">
            <div class="password-requirement">
                <div class="requirement-item" id="req-length">至少8个字符</div>
                <div class="requirement-item" id="req-number">包含数字</div>
                <div class="requirement-item" id="req-letter">包含字母</div>
            </div>
        </div>

        <div class="form-group">
            <label for="confirm-password">确认密码 <span style="color: #e74c3c;">*</span></label>
            <input type="password" id="confirm-password" name="confirm-password" placeholder="请再次输入密码" required>
        </div>

        <div class="terms-checkbox">
            <input type="checkbox" id="terms" name="terms" required>
            <label for="terms">我已阅读并同意<a href="#terms">服务条款</a>和<a href="#policy">隐私政策</a></label>
        </div>

        <button type="submit" class="register-btn">创建账户</button>
    </form>

    <div class="login-link">
        <p>已有账户? <a href="login.jsp">立即登录</a></p>
    </div>
</div>

<script>
    function checkPassword() {
        const password = document.getElementById('password').value;
        
        // 检查长度
        const lengthReq = document.getElementById('req-length');
        if (password.length >= 8) {
            lengthReq.classList.add('met');
        } else {
            lengthReq.classList.remove('met');
        }

        // 检查数字
        const numberReq = document.getElementById('req-number');
        if (/\d/.test(password)) {
            numberReq.classList.add('met');
        } else {
            numberReq.classList.remove('met');
        }

        // 检查字母
        const letterReq = document.getElementById('req-letter');
        if (/[a-zA-Z]/.test(password)) {
            letterReq.classList.add('met');
        } else {
            letterReq.classList.remove('met');
        }
    }

    function validateForm() {
        const fullname = document.getElementById('fullname').value.trim();
        const email = document.getElementById('email').value.trim();
        const username = document.getElementById('username').value.trim();
        const password = document.getElementById('password').value;
        const confirmPassword = document.getElementById('confirm-password').value;
        const role = document.getElementById('role').value;
        const terms = document.getElementById('terms').checked;
        const errorMessage = document.getElementById('errorMessage');

        // 清除之前的错误信息
        errorMessage.style.display = 'none';

        if (!fullname || fullname.length < 2) {
            errorMessage.textContent = '请输入有效的真实姓名（至少2个字符）！';
            errorMessage.style.display = 'block';
            return false;
        }

        if (!email || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
            errorMessage.textContent = '请输入有效的电子邮箱地址！';
            errorMessage.style.display = 'block';
            return false;
        }

        if (!username || username.length < 3 || username.length > 20) {
            errorMessage.textContent = '用户名需要3-20个字符！';
            errorMessage.style.display = 'block';
            return false;
        }

        if (!role) {
            errorMessage.textContent = '请选择您的身份！';
            errorMessage.style.display = 'block';
            return false;
        }

        if (!password || password.length < 8) {
            errorMessage.textContent = '密码至少需要8个字符！';
            errorMessage.style.display = 'block';
            return false;
        }

        if (!/\d/.test(password) || !/[a-zA-Z]/.test(password)) {
            errorMessage.textContent = '密码必须包含字母和数字！';
            errorMessage.style.display = 'block';
            return false;
        }

        if (password !== confirmPassword) {
            errorMessage.textContent = '两次输入的密码不一致！';
            errorMessage.style.display = 'block';
            return false;
        }

        if (!terms) {
            errorMessage.textContent = '请同意服务条款和隐私政策！';
            errorMessage.style.display = 'block';
            return false;
        }

        return true;
    }

    // 输入框获得焦点时隐藏错误信息
    document.querySelectorAll('input, select').forEach(el => {
        el.addEventListener('focus', () => {
            document.getElementById('errorMessage').style.display = 'none';
        });
    });
</script>
</body>
</html>
