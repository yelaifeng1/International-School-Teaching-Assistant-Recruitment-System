<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Applicant Dashboard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/app.css">
</head>
<body>
<div class="page-shell">
    <div class="topbar">
        <div class="brand">
            <div class="brand-mark">TA</div>
            <div>
                <div class="brand-title">Applicant Dashboard</div>
                <div class="brand-subtitle">${currentUser.effectiveDisplayName} - ${roleLabel}</div>
            </div>
        </div>
        <div class="topbar-actions">
            <a class="btn btn-ghost" href="${pageContext.request.contextPath}/jobs">Browse Jobs</a>
            <a class="btn btn-ghost" href="${pageContext.request.contextPath}/applicant/profile">Profile</a>
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
            <div class="eyebrow">Open Jobs</div>
            <strong>${openJobsCount}</strong>
            <p>Positions currently accepting applications</p>
        </div>
        <div class="stat-card">
            <div class="eyebrow">Applications</div>
            <strong>${applicationCount}</strong>
            <p>Applications you have submitted</p>
        </div>
        <div class="stat-card">
            <div class="eyebrow">Assignments</div>
            <strong>${assignmentCount}</strong>
            <p>Confirmed TA assignments</p>
        </div>
        <div class="stat-card">
            <div class="eyebrow">Profile</div>
            <strong>${profileComplete ? 'Ready' : 'Pending'}</strong>
            <p>Complete your profile before applying</p>
        </div>
    </div>

    <div class="grid grid-2" style="margin-top: 18px;">
        <div class="panel">
            <h2>Quick Actions</h2>
            <div class="stack-inline">
                <a class="btn btn-primary" href="${pageContext.request.contextPath}/jobs">View Jobs</a>
                <a class="btn btn-secondary" href="${pageContext.request.contextPath}/applicant/applications">My Applications</a>
            </div>
            <p class="muted" style="margin-top: 14px;">A complete profile improves your chance of applying smoothly.</p>
        </div>
        <div class="panel">
            <h2>Profile Status</h2>
            <p><strong>Full Name:</strong> <c:out value="${profile.fullName}"/></p>
            <p><strong>Student ID:</strong> <c:out value="${profile.studentId}"/></p>
            <p><strong>Email:</strong> <c:out value="${profile.email}"/></p>
            <p class="muted">${profileComplete ? 'Your profile is ready for job applications.' : 'Please add your full name, student ID, and email before applying.'}</p>
        </div>
    </div>

    <div class="table-panel" style="margin-top: 18px;">
        <h2>Current Assignments</h2>
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
