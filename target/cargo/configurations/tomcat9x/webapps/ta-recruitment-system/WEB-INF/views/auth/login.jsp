<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Log In</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/app.css">
</head>
<body>
<div class="auth-wrap">
    <div class="auth-card">
        <div class="brand">
            <div class="brand-mark">TA</div>
            <div>
                <div class="brand-title">International School TA Recruitment</div>
                <div class="brand-subtitle">Secure sign-in for all roles</div>
            </div>
        </div>

        <h1>Log in</h1>
        <p class="muted">Sign in to manage applications, jobs, and recruitment workflows.</p>

        <c:if test="${not empty error}">
            <div class="info-banner error">${error}</div>
        </c:if>

        <c:if test="${not empty flash}">
            <div class="info-banner ${flash.type}">${flash.text}</div>
        </c:if>

        <form method="post" action="${pageContext.request.contextPath}/login" class="form-grid">
            <div class="field">
                <label for="username">Username</label>
                <input id="username" name="username" type="text" value="${rememberedUsername}" placeholder="ta / mo / admin" required>
            </div>
            <div class="field">
                <label for="password">Password</label>
                <input id="password" name="password" type="password" placeholder="Enter your password" required>
            </div>
            <div class="stack-inline">
                <label class="muted">
                    <input type="checkbox" name="remember"> Remember username
                </label>
            </div>
            <button type="submit" class="btn btn-primary">Log In</button>
        </form>

        <div class="panel" style="margin-top: 22px;">
            <h2>Demo Accounts</h2>
            <ul class="list-reset">
                <li><strong>TA:</strong> <code>ta / ta123456</code></li>
                <li><strong>MO:</strong> <code>mo / mo123456</code></li>
                <li><strong>Admin:</strong> <code>admin / admin123456</code></li>
            </ul>
        </div>

        <p class="footer-note">Need an account? <a href="${pageContext.request.contextPath}/register">Register here</a></p>
    </div>
</div>
</body>
</html>
