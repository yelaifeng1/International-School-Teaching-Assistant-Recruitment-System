<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Module Organiser Dashboard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/app.css">
</head>
<body>
<div class="page-shell">
    <div class="topbar">
        <div class="brand">
            <div class="brand-mark">MO</div>
            <div>
                <div class="brand-title">Module Organiser Dashboard</div>
                <div class="brand-subtitle">${currentUser.effectiveDisplayName} - ${roleLabel}</div>
            </div>
        </div>
        <div class="topbar-actions">
            <a class="btn btn-ghost" href="${pageContext.request.contextPath}/mo/jobs">Manage Jobs</a>
            <a class="btn btn-ghost" href="${pageContext.request.contextPath}/mo/applications">Review Applications</a>
            <form method="post" action="${pageContext.request.contextPath}/logout">
                <button class="btn btn-primary" type="submit">Log Out</button>
            </form>
        </div>
    </div>

    <c:if test="${not empty flash}">
        <div class="info-banner ${flash.type}">${flash.text}</div>
    </c:if>

    <div class="grid grid-4">
        <div class="stat-card">
            <div class="eyebrow">My Jobs</div>
            <strong>${jobs.size()}</strong>
            <p>Total jobs created by you</p>
        </div>
        <div class="stat-card">
            <div class="eyebrow">Open Jobs</div>
            <strong>${openJobCount}</strong>
            <p>Jobs still open for applications</p>
        </div>
        <div class="stat-card">
            <div class="eyebrow">Applications</div>
            <strong>${applications.size()}</strong>
            <p>Applications received for your jobs</p>
        </div>
        <div class="stat-card">
            <div class="eyebrow">Pending</div>
            <strong>${pendingCount}</strong>
            <p>Applications waiting for review</p>
        </div>
    </div>

    <div class="grid grid-2" style="margin-top: 18px;">
        <div class="panel">
            <h2>Quick Actions</h2>
            <div class="stack-inline">
                <a class="btn btn-primary" href="${pageContext.request.contextPath}/mo/jobs/new">Post Job</a>
                <a class="btn btn-secondary" href="${pageContext.request.contextPath}/mo/applications">Review Queue</a>
            </div>
            <p class="muted" style="margin-top: 14px;">Approving an application creates an assignment and fills the job automatically.</p>
        </div>
        <div class="panel">
            <h2>Recent Assignments</h2>
            <c:choose>
                <c:when test="${empty assignments}">
                    <div class="empty-state">No assignments have been confirmed yet.</div>
                </c:when>
                <c:otherwise>
                    <ul class="list-reset">
                        <c:forEach var="assignment" items="${assignments}" end="2">
                            <li>
                                <strong><c:out value="${assignment.courseCode}"/></strong>
                                - <c:out value="${assignment.courseName}"/>
                                - <span class="muted"><c:out value="${assignment.assignedAt}"/></span>
                            </li>
                        </c:forEach>
                    </ul>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>
</body>
</html>
