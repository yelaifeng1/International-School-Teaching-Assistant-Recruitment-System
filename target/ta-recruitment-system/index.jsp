<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>International School TA Recruitment</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/app.css">
</head>
<body>
<div class="hero-shell">
    <div class="topbar" style="margin-bottom: 20px;">
        <div class="brand">
            <div class="brand-mark">IS</div>
            <div>
                <div class="brand-title">International School Teaching Assistant Recruitment</div>
                <div class="brand-subtitle">A single entry point for TA hiring</div>
            </div>
        </div>
        <div class="topbar-actions">
            <a class="btn btn-ghost" href="${pageContext.request.contextPath}/login">Log In</a>
            <a class="btn btn-primary" href="${pageContext.request.contextPath}/register">Register</a>
        </div>
    </div>

    <div class="hero-card">
        <div class="hero-content">
            <div>
                <h1>Manage the full TA recruitment workflow in one place.</h1>
                <p>
                    This system combines registration, role-based access, job publishing,
                    application submission, review, and assignment tracking with a simple
                    Servlet, JSP, and JSON-based architecture.
                </p>
                <div class="stack-inline">
                    <a class="btn btn-secondary" href="${pageContext.request.contextPath}/login">Enter System</a>
                    <a class="btn btn-ghost" href="${pageContext.request.contextPath}/register">Create Account</a>
                </div>
            </div>
            <div class="hero-aside">
                <div class="mini-card">
                    <strong>Demo Accounts</strong>
                    <p>
                        TA: <code>ta / ta123456</code><br>
                        MO: <code>mo / mo123456</code><br>
                        Admin: <code>admin / admin123456</code>
                    </p>
                </div>
                <div class="mini-card">
                    <strong>Included Flows</strong>
                    <ul>
                        <li>Applicants complete profiles and submit applications.</li>
                        <li>Module organisers publish jobs and review candidates.</li>
                        <li>Administrators monitor users, jobs, and assignments.</li>
                    </ul>
                </div>
            </div>
        </div>
    </div>

    <div class="grid grid-4" style="margin-top: 18px;">
        <div class="stat-card">
            <div class="eyebrow">Roles</div>
            <strong>3</strong>
            <p>TA, MO, and Admin</p>
        </div>
        <div class="stat-card">
            <div class="eyebrow">Persistence</div>
            <strong>JSON</strong>
            <p>Lightweight file-based storage for local demos</p>
        </div>
        <div class="stat-card">
            <div class="eyebrow">Workflow</div>
            <strong>End-to-End</strong>
            <p>From posting a role to assigning a TA</p>
        </div>
        <div class="stat-card">
            <div class="eyebrow">Architecture</div>
            <strong>MVC</strong>
            <p>Servlet + Service + DAO + JSP</p>
        </div>
    </div>

    <div class="grid grid-3" style="margin-top: 18px;">
        <div class="feature-card">
            <h2>TA Applicant</h2>
            <p>Maintain a profile, browse open jobs, submit applications, and track results.</p>
        </div>
        <div class="feature-card">
            <h2>Module Organiser</h2>
            <p>Create positions, review incoming applications, and confirm assignments.</p>
        </div>
        <div class="feature-card">
            <h2>Administrator</h2>
            <p>See a system-wide view of accounts, job postings, applications, and workload records.</p>
        </div>
    </div>
</div>
</body>
</html>
