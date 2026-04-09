<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Post Job</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/app.css">
</head>
<body>
<div class="page-shell">
    <div class="topbar">
        <div class="brand">
            <div class="brand-mark">+</div>
            <div>
                <div class="brand-title">Post a TA Job</div>
                <div class="brand-subtitle">Create a new role for applicants</div>
            </div>
        </div>
        <div class="topbar-actions">
            <a class="btn btn-ghost" href="${pageContext.request.contextPath}/mo/jobs">Back to Job Management</a>
        </div>
    </div>

    <div class="panel">
        <h2>Job Information</h2>
        <c:if test="${not empty error}">
            <div class="info-banner error">${error}</div>
        </c:if>
        <form method="post" action="${pageContext.request.contextPath}/mo/jobs/new" class="form-grid">
            <div class="grid grid-2">
                <div class="field">
                    <label for="courseCode">Course Code</label>
                    <input id="courseCode" name="courseCode" type="text" value="${courseCode}" required>
                </div>
                <div class="field">
                    <label for="courseName">Course Name</label>
                    <input id="courseName" name="courseName" type="text" value="${courseName}" required>
                </div>
            </div>
            <div class="field">
                <label for="deadline">Application Deadline</label>
                <input id="deadline" name="deadline" type="date" value="${deadline}" required>
            </div>
            <div class="field">
                <label for="requirements">Requirements</label>
                <textarea id="requirements" name="requirements" required><c:out value="${requirements}"/></textarea>
            </div>
            <button class="btn btn-primary" type="submit">Post Job</button>
        </form>
    </div>
</div>
</body>
</html>
