<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TA Workload</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/app.css">
</head>
<body>
<div class="page-shell">
    <div class="topbar">
        <div class="brand">
            <div class="brand-mark">WL</div>
            <div>
                <div class="brand-title">TA Workload</div>
                <div class="brand-subtitle">${currentUser.effectiveDisplayName} - ${roleLabel}</div>
            </div>
        </div>
        <div class="topbar-actions" style="display: flex; gap: 8px;">
            <a class="btn btn-ghost" href="${pageContext.request.contextPath}/admin/dashboard">Back to Admin Dashboard</a>
            <form method="post" action="${pageContext.request.contextPath}/logout">
                <button class="btn btn-primary" type="submit">Log Out</button>
            </form>
        </div>
    </div>

    <div class="table-panel" style="margin-top: 18px;">
        <h2>Workload Details</h2>
        <c:choose>
            <c:when test="${empty applicantUsers}">
                <div class="empty-state">No TA accounts found in the system.</div>
            </c:when>
            <c:otherwise>
                <form method="get" action="${pageContext.request.contextPath}/admin/workload" style="margin-bottom: 14px; display: flex; gap: 10px; align-items: center; flex-wrap: wrap;">
                    <label for="taUserId">Select TA:</label>
                    <select id="taUserId" name="taUserId">
                        <c:forEach var="taUser" items="${applicantUsers}">
                            <option value="${taUser.userId}" ${taUser.userId == selectedTaUserId ? 'selected' : ''}>
                                <c:out value="${taUser.effectiveDisplayName}"/> (<c:out value="${taUser.username}"/>)
                            </option>
                        </c:forEach>
                    </select>
                    <button class="btn btn-primary" type="submit">View</button>
                </form>

                <c:if test="${not empty selectedTaUser}">
                    <p class="muted" style="margin-bottom: 12px;">
                        Current TA: <strong><c:out value="${selectedTaUser.effectiveDisplayName}"/></strong>
                        (<c:out value="${selectedTaUser.username}"/>)
                    </p>
                </c:if>

                <c:choose>
                    <c:when test="${empty selectedTaAssignments}">
                        <div class="empty-state">This TA has no workload records yet.</div>
                    </c:when>
                    <c:otherwise>
                        <table>
                            <thead>
                            <tr>
                                <th>Assignment ID</th>
                                <th>Course</th>
                                <th>Lecturer</th>
                                <th>Assigned At</th>
                                <th>Status</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="assignment" items="${selectedTaAssignments}">
                                <tr>
                                    <td><c:out value="${assignment.assignmentId}"/></td>
                                    <td>
                                        <strong><c:out value="${assignment.courseCode}"/></strong><br>
                                        <span class="muted"><c:out value="${assignment.courseName}"/></span>
                                    </td>
                                    <td><c:out value="${assignment.lecturerName}"/></td>
                                    <td><c:out value="${assignment.assignedAt}"/></td>
                                    <td>
                                        <span class="status-pill ${assignment.status == 'ACTIVE' ? 'status-approved' : 'status-pending'}">
                                            <c:out value="${assignment.status}"/>
                                        </span>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </c:otherwise>
                </c:choose>
            </c:otherwise>
        </c:choose>
    </div>
</div>
</body>
</html>