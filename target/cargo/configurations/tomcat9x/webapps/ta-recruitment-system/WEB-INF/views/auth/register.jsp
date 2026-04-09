<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/app.css">
</head>
<body>
<div class="auth-wrap">
    <div class="auth-card">
        <div class="brand">
            <div class="brand-mark">IS</div>
            <div>
                <div class="brand-title">Create Access</div>
                <div class="brand-subtitle">Set up a role-based account</div>
            </div>
        </div>

        <h1>Create an account</h1>
        <p class="muted">Register as an applicant, module organiser, or administrator.</p>

        <c:if test="${not empty error}">
            <div class="info-banner error">${error}</div>
        </c:if>

        <c:if test="${not empty flash}">
            <div class="info-banner ${flash.type}">${flash.text}</div>
        </c:if>

        <form method="post" action="${pageContext.request.contextPath}/register" class="form-grid">
            <div class="field">
                <label for="username">Username</label>
                <input id="username" name="username" type="text" value="${username}" required>
            </div>
            <div class="field">
                <label for="email">Email</label>
                <input id="email" name="email" type="email" value="${email}" required>
            </div>
            <div class="field">
                <label for="password">Password</label>
                <input id="password" name="password" type="password" required>
                <div class="help">Use at least 8 characters and include both letters and numbers.</div>
            </div>
            <div class="field">
                <label for="role">Role</label>
                <select id="role" name="role" required>
                    <option value="">Select a role</option>
                    <option value="TA" ${role == 'TA' ? 'selected' : ''}>TA Applicant</option>
                    <option value="MO" ${role == 'MO' ? 'selected' : ''}>Module Organiser</option>
                    <option value="ADMIN" ${role == 'ADMIN' ? 'selected' : ''}>Administrator</option>
                </select>
            </div>
            <button type="submit" class="btn btn-primary">Create Account</button>
        </form>

        <p class="footer-note">Already registered? <a href="${pageContext.request.contextPath}/login">Back to login</a></p>
    </div>
</div>
</body>
</html>
