<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Jobs</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/app.css">
</head>
<body>
<div class="page-shell">
    <div class="topbar">
        <div class="brand">
            <div class="brand-mark">JB</div>
            <div>
                <div class="brand-title">Manage Posted Jobs</div>
                <div class="brand-subtitle">Review status and application volume</div>
            </div>
        </div>
        <div class="topbar-actions">
            <a class="btn btn-secondary" href="${pageContext.request.contextPath}/mo/jobs/new">Post New Job</a>
            <a class="btn btn-ghost" href="${pageContext.request.contextPath}/mo/dashboard">Back to Dashboard</a>
        </div>
    </div>

    <c:if test="${not empty flash}">
        <div class="info-banner ${flash.type}">${flash.text}</div>
    </c:if>

    <div class="table-panel">
        <h2>My Jobs</h2>
        <c:choose>
            <c:when test="${empty jobs}">
                <div class="empty-state">You have not posted any jobs yet.</div>
            </c:when>
            <c:otherwise>
                <table>
                    <thead>
                    <tr>
                        <th>Course</th>
                        <th>Deadline</th>
                        <th>Status</th>
                        <th>Applications</th>
                        <th>Pending</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="job" items="${jobs}">
                        <tr>
                            <td>
                                <strong><c:out value="${job.courseCode}"/></strong><br>
                                <span class="muted"><c:out value="${job.courseName}"/></span>
                            </td>
                            <td><c:out value="${job.deadline}"/></td>
                            <td>
                                <span class="status-pill ${job.status == 'OPEN' ? 'status-open' : job.status == 'FILLED' ? 'status-filled' : 'status-closed'}">
                                    <c:out value="${job.status}"/>
                                </span>
                            </td>
                            <td>${applicationCounts[job.jobId] != null ? applicationCounts[job.jobId] : 0}</td>
                            <td>${pendingCounts[job.jobId] != null ? pendingCounts[job.jobId] : 0}</td>
                            <td>
                                <div class="stack-inline">
                                    <a class="btn btn-ghost btn-small" href="${pageContext.request.contextPath}/jobs/detail?id=${job.jobId}">Details</a>
                                    <form method="post" action="${pageContext.request.contextPath}/mo/jobs/status">
                                        <input type="hidden" name="jobId" value="${job.jobId}">
                                        <input type="hidden" name="status" value="${job.status == 'OPEN' ? 'CLOSED' : 'OPEN'}">
                                        <button class="btn ${job.status == 'OPEN' ? 'btn-danger' : 'btn-success'} btn-small" type="submit">${job.status == 'OPEN' ? 'Close' : 'Reopen'}</button>
                                    </form>
                                </div>
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
