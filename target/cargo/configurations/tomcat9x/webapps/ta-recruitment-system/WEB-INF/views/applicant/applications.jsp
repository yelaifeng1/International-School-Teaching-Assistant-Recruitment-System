<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Applications</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/app.css">
</head>
<body>
<div class="page-shell">
    <div class="topbar">
        <div class="brand">
            <div class="brand-mark">AP</div>
            <div>
                <div class="brand-title">My Applications</div>
                <div class="brand-subtitle">Track application outcomes and assignments</div>
            </div>
        </div>
        <div class="topbar-actions">
            <a class="btn btn-ghost" href="${pageContext.request.contextPath}/applicant/dashboard">Back to Dashboard</a>
            <a class="btn btn-secondary" href="${pageContext.request.contextPath}/jobs">Browse Jobs</a>
        </div>
    </div>

    <div class="table-panel">
        <h2>Submitted Applications</h2>
        <c:choose>
            <c:when test="${empty applications}">
                <div class="empty-state">You have not submitted any applications yet.</div>
            </c:when>
            <c:otherwise>
                <table>
                    <thead>
                    <tr>
                        <th>Course</th>
                        <th>Applied At</th>
                        <th>Status</th>
                        <th>Reviewer Comment</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="application" items="${applications}">
                        <tr>
                            <td>
                                <strong><c:out value="${application.courseCode}"/></strong><br>
                                <span class="muted"><c:out value="${application.courseName}"/></span>
                            </td>
                            <td><c:out value="${application.applyDate}"/></td>
                            <td>
                                <span class="status-pill ${application.status == 'APPROVED' ? 'status-approved' : application.status == 'REJECTED' ? 'status-rejected' : 'status-pending'}">
                                    <c:out value="${application.status}"/>
                                </span>
                            </td>
                            <td><c:out value="${application.reviewerComment}"/></td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </c:otherwise>
        </c:choose>
    </div>

    <div class="table-panel" style="margin-top: 18px;">
        <h2>Confirmed Assignments</h2>
        <c:choose>
            <c:when test="${empty assignments}">
                <div class="empty-state">You do not have any confirmed assignments yet.</div>
            </c:when>
            <c:otherwise>
                <table>
                    <thead>
                    <tr>
                        <th>Course</th>
                        <th>Lecturer</th>
                        <th>Assigned At</th>
                        <th>Status</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="assignment" items="${assignments}">
                        <tr>
                            <td>
                                <strong><c:out value="${assignment.courseCode}"/></strong><br>
                                <span class="muted"><c:out value="${assignment.courseName}"/></span>
                            </td>
                            <td><c:out value="${assignment.lecturerName}"/></td>
                            <td><c:out value="${assignment.assignedAt}"/></td>
                            <td><span class="status-pill status-active"><c:out value="${assignment.status}"/></span></td>
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
