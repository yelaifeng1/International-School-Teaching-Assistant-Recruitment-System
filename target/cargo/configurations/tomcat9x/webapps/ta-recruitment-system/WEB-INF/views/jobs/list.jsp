<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Open Jobs</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/app.css">
</head>
<body>
<div class="page-shell">
    <div class="topbar">
        <div class="brand">
            <div class="brand-mark">TA</div>
            <div>
                <div class="brand-title">Open Teaching Assistant Jobs</div>
                <div class="brand-subtitle">Browse currently available positions</div>
            </div>
        </div>
        <div class="topbar-actions">
            <a class="btn btn-ghost" href="${pageContext.request.contextPath}${currentUser.role == 'TA' ? '/applicant/dashboard' : currentUser.role == 'MO' ? '/mo/dashboard' : '/admin/dashboard'}">Back to Dashboard</a>
            <form method="post" action="${pageContext.request.contextPath}/logout">
                <button class="btn btn-primary" type="submit">Log Out</button>
            </form>
        </div>
    </div>

    <div class="table-panel">
        <h2>Available Roles</h2>
        <p class="muted">Open a job to view the description, deadline, and application form.</p>
        <c:choose>
            <c:when test="${empty jobs}">
                <div class="empty-state">There are no open jobs at the moment.</div>
            </c:when>
            <c:otherwise>
                <table>
                    <thead>
                    <tr>
                        <th>Job ID</th>
                        <th>Course</th>
                        <th>Lecturer</th>
                        <th>Deadline</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="job" items="${jobs}">
                        <tr>
                            <td><c:out value="${job.jobId}"/></td>
                            <td>
                                <strong><c:out value="${job.courseCode}"/></strong><br>
                                <span class="muted"><c:out value="${job.courseName}"/></span>
                            </td>
                            <td><c:out value="${job.lecturerName}"/></td>
                            <td><c:out value="${job.deadline}"/></td>
                            <td><span class="status-pill status-open">OPEN</span></td>
                            <td>
                                <a class="btn btn-secondary btn-small" href="${pageContext.request.contextPath}/jobs/detail?id=${job.jobId}">View Details</a>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </c:otherwise>
        </c:choose>
    </div>
</div>
</body>
</html>
