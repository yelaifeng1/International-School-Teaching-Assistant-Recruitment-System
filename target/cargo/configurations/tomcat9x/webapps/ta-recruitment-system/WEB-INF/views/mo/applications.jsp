<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Review Applications</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/app.css">
</head>
<body>
<div class="page-shell">
    <div class="topbar">
        <div class="brand">
            <div class="brand-mark">RV</div>
            <div>
                <div class="brand-title">Review Applications</div>
                <div class="brand-subtitle">Assess candidates for your posted jobs</div>
            </div>
        </div>
        <div class="topbar-actions">
            <a class="btn btn-ghost" href="${pageContext.request.contextPath}/mo/dashboard">Back to Dashboard</a>
        </div>
    </div>

    <c:if test="${not empty flash}">
        <div class="info-banner ${flash.type}">${flash.text}</div>
    </c:if>

    <div class="table-panel">
        <h2>Application Queue</h2>
        <c:choose>
            <c:when test="${empty applications}">
                <div class="empty-state">There are no applications to review right now.</div>
            </c:when>
            <c:otherwise>
                <table>
                    <thead>
                    <tr>
                        <th>Applicant</th>
                        <th>Job</th>
                        <th>Statement</th>
                        <th>Status</th>
                        <th>Review</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="application" items="${applications}">
                        <tr>
                            <td>
                                <strong><c:out value="${application.applicantName}"/></strong><br>
                                <span class="muted"><c:out value="${application.studentId}"/></span>
                            </td>
                            <td>
                                <strong><c:out value="${application.courseCode}"/></strong><br>
                                <span class="muted"><c:out value="${application.courseName}"/></span>
                            </td>
                            <td><div class="details-box"><c:out value="${application.personalStatement}"/></div></td>
                            <td>
                                <span class="status-pill ${application.status == 'APPROVED' ? 'status-approved' : application.status == 'REJECTED' ? 'status-rejected' : 'status-pending'}">
                                    <c:out value="${application.status}"/>
                                </span>
                            </td>
                            <td>
                                <form method="post" action="${pageContext.request.contextPath}/mo/applications/review" class="form-grid">
                                    <input type="hidden" name="applicationId" value="${application.applicationId}">
                                    <div class="field">
                                        <label for="status-${application.applicationId}">Decision</label>
                                        <select id="status-${application.applicationId}" name="status">
                                            <option value="PENDING" ${application.status == 'PENDING' ? 'selected' : ''}>Pending</option>
                                            <option value="APPROVED" ${application.status == 'APPROVED' ? 'selected' : ''}>Approve</option>
                                            <option value="REJECTED" ${application.status == 'REJECTED' ? 'selected' : ''}>Reject</option>
                                        </select>
                                    </div>
                                    <div class="field">
                                        <label for="comment-${application.applicationId}">Comment</label>
                                        <textarea id="comment-${application.applicationId}" name="reviewerComment" placeholder="Optional feedback for the applicant."><c:out value="${application.reviewerComment}"/></textarea>
                                    </div>
                                    <button class="btn btn-primary btn-small" type="submit">Save Review</button>
                                </form>
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
