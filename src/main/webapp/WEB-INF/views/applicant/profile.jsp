<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Applicant Profile</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/app.css">
</head>
<body>
<div class="page-shell">
    <div class="topbar">
        <div class="brand">
            <div class="brand-mark">PF</div>
            <div>
                <div class="brand-title">Applicant Profile</div>
                <div class="brand-subtitle">Maintain the information used for applications</div>
            </div>
        </div>
        <div class="topbar-actions">
            <a class="btn btn-ghost" href="${pageContext.request.contextPath}/applicant/dashboard">Back to Dashboard</a>
            <form method="post" action="${pageContext.request.contextPath}/logout">
                <button class="btn btn-primary" type="submit">Log Out</button>
            </form>
        </div>
    </div>

    <c:if test="${not empty flash}">
        <div class="info-banner ${flash.type}">${flash.text}</div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="info-banner error">${error}</div>
    </c:if>

    <div class="panel">
        <h2>Edit Profile</h2>
        <form method="post" action="${pageContext.request.contextPath}/applicant/profile" class="form-grid">
            <div class="grid grid-2">
                <div class="field">
                    <label for="fullName">Full Name</label>
                    <input id="fullName" name="fullName" type="text" value="${profile.fullName}" required>
                </div>
                <div class="field">
                    <label for="studentId">Student ID</label>
                    <input id="studentId" name="studentId" type="text" value="${profile.studentId}" required>
                </div>
            </div>
            <div class="grid grid-2">
                <div class="field">
                    <label for="email">Email</label>
                    <input id="email" name="email" type="email" value="${profile.email}" required>
                </div>
                <div class="field">
                    <label for="phone">Phone</label>
                    <input id="phone" name="phone" type="text" value="${profile.phone}">
                </div>
            </div>
            <div class="field">
                <label for="skills">Skills</label>
                <textarea id="skills" name="skills"><c:out value="${profile.skills}"/></textarea>
            </div>
            <div class="field">
                <label for="availability">Availability</label>
                <input id="availability" name="availability" type="text" value="${profile.availability}">
            </div>
            <div class="field">
                <label for="cvPath">CV Notes or Link</label>
                <input id="cvPath" name="cvPath" type="text" value="${profile.cvPath}">
            </div>
            <button class="btn btn-primary" type="submit">Save Profile</button>
        </form>
    </div>
</div>
</body>
</html>
