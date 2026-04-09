<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Job Details</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/app.css">
</head>
<body>
<div class="page-shell">
    <div class="topbar">
        <div class="brand">
            <div class="brand-mark">JD</div>
            <div>
                <div class="brand-title">Job Details</div>
                <div class="brand-subtitle"><c:out value="${job.courseCode}"/> - <c:out value="${job.courseName}"/></div>
            </div>
        </div>
        <div class="topbar-actions">
            <a class="btn btn-ghost" href="${pageContext.request.contextPath}/jobs">Back to Jobs</a>
            <form method="post" action="${pageContext.request.contextPath}/logout">
                <button class="btn btn-primary" type="submit">Log Out</button>
            </form>
        </div>
    </div>

    <c:if test="${not empty flash}">
        <div class="info-banner ${flash.type}">${flash.text}</div>
    </c:if>

    <div class="split">
        <div class="panel">
            <h2><c:out value="${job.courseName}"/></h2>
            <div class="key-value">
                <div>
                    <strong>Course Code</strong>
                    <c:out value="${job.courseCode}"/>
                </div>
                <div>
                    <strong>Lecturer</strong>
                    <c:out value="${job.lecturerName}"/>
                </div>
                <div>
                    <strong>Deadline</strong>
                    <c:out value="${job.deadline}"/>
                </div>
                <div>
                    <strong>Status</strong>
                    <span class="status-pill ${job.status == 'OPEN' ? 'status-open' : job.status == 'FILLED' ? 'status-filled' : 'status-closed'}">
                        <c:out value="${job.status}"/>
                    </span>
                </div>
            </div>
            <div style="margin-top: 20px;">
                <strong>Requirements</strong>
                <div class="details-box"><c:out value="${job.requirements}"/></div>
            </div>
        </div>

        <div class="panel">
            <h2>Apply for this job</h2>
            <c:choose>
                <c:when test="${canApply}">
                    <form method="post" action="${pageContext.request.contextPath}/applications" class="form-grid">
                        <input type="hidden" name="jobId" value="${job.jobId}">
                        <div class="field">
                            <label for="personalStatement">Personal Statement</label>
                            <textarea id="personalStatement" name="personalStatement" placeholder="Summarize your experience, skills, and fit for the role." required></textarea>
                        </div>
                        <button class="btn btn-primary" type="submit">Submit Application</button>
                    </form>
                </c:when>
                <c:when test="${alreadyApplied}">
                    <div class="empty-state">You have already applied for this job, or it is no longer available for new applications.</div>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">Your current role cannot apply for this job.</div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>
</body>
</html>
