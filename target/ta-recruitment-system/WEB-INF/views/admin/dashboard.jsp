<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Administrator Dashboard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/app.css">
</head>
<body>
<div class="page-shell">
    <div class="topbar">
        <div class="brand">
            <div class="brand-mark">AD</div>
            <div>
                <div class="brand-title">Administrator Dashboard</div>
                <div class="brand-subtitle">${currentUser.effectiveDisplayName} - ${roleLabel}</div>
            </div>
        </div>
        <div class="topbar-actions">
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
            <div class="eyebrow">Users</div>
            <strong>${userCount}</strong>
            <p>Total accounts in the system</p>
        </div>
        <div class="stat-card">
            <div class="eyebrow">Applicants</div>
            <strong>${applicantCount}</strong>
            <p>Teaching assistant applicant accounts</p>
        </div>
        <div class="stat-card">
            <div class="eyebrow">Managers</div>
            <strong>${managerCount}</strong>
            <p>Module organiser accounts</p>
        </div>
        <div class="stat-card">
            <div class="eyebrow">Assignments</div>
            <strong>${assignmentCount}</strong>
            <p>Confirmed workload records</p>
        </div>
    </div>

    <div class="table-panel" style="margin-top: 18px;">
        <h2>User Directory</h2>
        <table>
            <thead>
            <tr>
                <th>User ID</th>
                <th>Username</th>
                <th>Role</th>
                <th>Email</th>
                <th>Created At</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="user" items="${users}">
                <tr>
                    <td><c:out value="${user.userId}"/></td>
                    <td>
                        <strong><c:out value="${user.username}"/></strong><br>
                        <span class="muted"><c:out value="${user.effectiveDisplayName}"/></span>
                    </td>
                    <td>
                        <span class="status-pill ${user.role == 'ADMIN' ? 'status-filled' : user.role == 'MO' ? 'status-open' : 'status-pending'}">
                            <c:out value="${user.role}"/>
                        </span>
                    </td>
                    <td><c:out value="${user.email}"/></td>
                    <td><c:out value="${user.createdAt}"/></td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>

    <div class="grid grid-2" style="margin-top: 18px;">
        <div class="table-panel">
            <h2>Recent Jobs</h2>
            <c:choose>
                <c:when test="${empty jobs}">
                    <div class="empty-state">No jobs have been posted yet.</div>
                </c:when>
                <c:otherwise>
                    <table>
                        <thead>
                        <tr>
                            <th>Course</th>
                            <th>Lecturer</th>
                            <th>Status</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="job" items="${jobs}" end="4">
                            <tr>
                                <td>
                                    <strong><c:out value="${job.courseCode}"/></strong><br>
                                    <span class="muted"><c:out value="${job.courseName}"/></span>
                                </td>
                                <td><c:out value="${job.lecturerName}"/></td>
                                <td>
                                    <span class="status-pill ${job.status == 'OPEN' ? 'status-open' : job.status == 'FILLED' ? 'status-approved' : 'status-rejected'}">
                                        <c:out value="${job.status}"/>
                                    </span>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </c:otherwise>
            </c:choose>
        </div>

        <div class="table-panel">
            <h2>Recent Applications</h2>
            <c:choose>
                <c:when test="${empty applications}">
                    <div class="empty-state">No applications have been submitted yet.</div>
                </c:when>
                <c:otherwise>
                    <table>
                        <thead>
                        <tr>
                            <th>Applicant</th>
                            <th>Course</th>
                            <th>Status</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="application" items="${applications}" end="4">
                            <tr>
                                <td><c:out value="${application.applicantName}"/></td>
                                <td>
                                    <strong><c:out value="${application.courseCode}"/></strong><br>
                                    <span class="muted"><c:out value="${application.courseName}"/></span>
                                </td>
                                <td>
                                    <span class="status-pill ${application.status == 'APPROVED' ? 'status-approved' : application.status == 'REJECTED' ? 'status-rejected' : 'status-pending'}">
                                        <c:out value="${application.status}"/>
                                    </span>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>
</body>
</html>
