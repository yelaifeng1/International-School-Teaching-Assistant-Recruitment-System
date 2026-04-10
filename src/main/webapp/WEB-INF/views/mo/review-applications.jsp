<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.nio.file.Files" %>
<%@ page import="java.nio.file.Paths" %>
<%@ page import="java.nio.charset.StandardCharsets" %>
<%@ page import="org.json.JSONArray" %>
<%@ page import="org.json.JSONObject" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Review Applications - Module Organiser</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/app.css">
    <style>
        .table-wrapper {
            overflow-x: auto;
            margin-top: 18px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            background: white;
        }
        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #e0e0e0;
        }
        th {
            background-color: #f5f5f5;
            font-weight: 600;
            color: #333;
            border-bottom: 2px solid #ddd;
        }
        tr:hover {
            background-color: #fafafa;
        }
        .status-badge {
            display: inline-block;
            padding: 4px 8px;
            border-radius: 4px;
            font-weight: 600;
            font-size: 12px;
        }
        .status-pending {
            background-color: #fff3cd;
            color: #856404;
        }
        .status-approved {
            background-color: #d4edda;
            color: #155724;
        }
        .status-rejected {
            background-color: #f8d7da;
            color: #721c24;
        }
        .action-buttons {
            display: flex;
            gap: 6px;
            flex-wrap: wrap;
        }
        .action-buttons form {
            display: inline;
        }
        .btn-small {
            padding: 6px 10px;
            font-size: 12px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            transition: all 0.2s;
        }
        .btn-approve {
            background-color: #28a745;
            color: white;
        }
        .btn-approve:hover {
            background-color: #218838;
        }
        .btn-reject {
            background-color: #dc3545;
            color: white;
        }
        .btn-reject:hover {
            background-color: #c82333;
        }
        .btn-pending {
            background-color: #6c757d;
            color: white;
        }
        .btn-pending:hover {
            background-color: #5a6268;
        }
        .empty-state {
            text-align: center;
            padding: 40px;
            color: #999;
        }
        .info-banner {
            padding: 12px 16px;
            border-radius: 4px;
            margin-bottom: 16px;
            display: none;
        }
        .info-banner.success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
            display: block;
        }
        .info-banner.error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
            display: block;
        }
        .stat-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 16px;
            margin-bottom: 24px;
        }
        .stat-item {
            background: white;
            padding: 16px;
            border-radius: 4px;
            border-left: 4px solid #007bff;
        }
        .stat-label {
            font-size: 12px;
            color: #999;
            text-transform: uppercase;
            margin-bottom: 8px;
        }
        .stat-value {
            font-size: 24px;
            font-weight: 600;
            color: #333;
        }
    </style>
</head>
<body>
<div class="page-shell">
    <div class="topbar">
        <div class="brand">
            <div class="brand-mark">MO</div>
            <div>
                <div class="brand-title">Review Applications</div>
                <div class="brand-subtitle">Manage and approve candidate submissions</div>
            </div>
        </div>
        <div class="topbar-actions">
            <a class="btn btn-ghost" href="${pageContext.request.contextPath}/mo/dashboard">Back to Dashboard</a>
            <a class="btn btn-ghost" href="${pageContext.request.contextPath}/mo/jobs">Manage Jobs</a>
            <form method="post" action="${pageContext.request.contextPath}/logout">
                <button class="btn btn-primary" type="submit">Log Out</button>
            </form>
        </div>
    </div>

    <%
        String successMsg = request.getParameter("success");
        String errorMsg = request.getParameter("error");
    %>

    <c:if test="${not empty param.success}">
        <div class="info-banner success">${param.success}</div>
    </c:if>
    <c:if test="${not empty param.error}">
        <div class="info-banner error">${param.error}</div>
    </c:if>

    <%
        String JSON_FILE_PATH = System.getProperty("user.dir") + "/target/classes/data/applications.json";
        int totalApplications = 0;
        int pendingCount = 0;
        int approvedCount = 0;
        int rejectedCount = 0;

        System.out.println("=== MO Review Applications JSP Loaded ===");
        System.out.println("JSON_FILE_PATH: " + JSON_FILE_PATH);
        System.out.println("File exists: " + new java.io.File(JSON_FILE_PATH).exists());

        try {
            String jsonContent = new String(Files.readAllBytes(Paths.get(JSON_FILE_PATH)), StandardCharsets.UTF_8);
            System.out.println("JSON Content length: " + jsonContent.length());
            JSONArray applicationArray = new JSONArray(jsonContent);
            totalApplications = applicationArray.length();
            System.out.println("Total applications: " + totalApplications);

            for (int i = 0; i < applicationArray.length(); i++) {
                JSONObject app = applicationArray.getJSONObject(i);
                String status = app.getString("status");
                System.out.println("App " + i + ": " + app.getString("name") + " - " + status);
                if ("Pending".equals(status)) pendingCount++;
                else if ("Approved".equals(status)) approvedCount++;
                else if ("Rejected".equals(status)) rejectedCount++;
            }
        } catch (Exception e) {
            System.out.println("ERROR loading applications: " + e.getMessage());
            e.printStackTrace();
        }
    %>

    <!-- Statistics -->
    <div class="stat-grid">
        <div class="stat-item">
            <div class="stat-label">Total Applications</div>
            <div class="stat-value"><%= totalApplications %></div>
        </div>
        <div class="stat-item" style="border-left-color: #ffc107;">
            <div class="stat-label">Pending Review</div>
            <div class="stat-value"><%= pendingCount %></div>
        </div>
        <div class="stat-item" style="border-left-color: #28a745;">
            <div class="stat-label">Approved</div>
            <div class="stat-value"><%= approvedCount %></div>
        </div>
        <div class="stat-item" style="border-left-color: #dc3545;">
            <div class="stat-label">Rejected</div>
            <div class="stat-value"><%= rejectedCount %></div>
        </div>
    </div>

    <!-- Applications Table -->
    <div class="panel">
        <h2>Applications Queue</h2>
        
        <%
            try {
                String jsonContent = new String(Files.readAllBytes(Paths.get(JSON_FILE_PATH)), StandardCharsets.UTF_8);
                JSONArray applicationArray = new JSONArray(jsonContent);

                if (applicationArray.length() == 0) {
        %>
                    <div class="empty-state">
                        <p>No applications yet</p>
                    </div>
        <%
                } else {
        %>
                    <div class="table-wrapper">
                        <table>
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Applicant Name</th>
                                    <th>Job Position</th>
                                    <th>Application Reason</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
        <%
                            for (int i = 0; i < applicationArray.length(); i++) {
                                JSONObject app = applicationArray.getJSONObject(i);
                                int id = app.getInt("id");
                                String name = app.getString("name");
                                String jobTitle = app.getString("jobTitle");
                                String reason = app.getString("reason");
                                String status = app.getString("status");
                                String statusClass = "status-pending";
                                if ("Approved".equals(status)) statusClass = "status-approved";
                                else if ("Rejected".equals(status)) statusClass = "status-rejected";
        %>
                                <tr>
                                    <td><strong>#<%= id %></strong></td>
                                    <td><%= name %></td>
                                    <td><%= jobTitle %></td>
                                    <td><%= reason %></td>
                                    <td>
                                        <span class="status-badge <%= statusClass %>"><%= status %></span>
                                    </td>
                                    <td>
                                        <div class="action-buttons">
                                            <form action="${pageContext.request.contextPath}/reviewApplication" method="post">
                                                <input type="hidden" name="id" value="<%= id %>">
                                                <button class="btn-small btn-approve" type="submit" name="status" value="Approved">Approve</button>
                                            </form>
                                            <form action="${pageContext.request.contextPath}/reviewApplication" method="post">
                                                <input type="hidden" name="id" value="<%= id %>">
                                                <button class="btn-small btn-reject" type="submit" name="status" value="Rejected">Reject</button>
                                            </form>
                                            <form action="${pageContext.request.contextPath}/reviewApplication" method="post">
                                                <input type="hidden" name="id" value="<%= id %>">
                                                <button class="btn-small btn-pending" type="submit" name="status" value="Pending">Reset</button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
        <%
                            }
        %>
                            </tbody>
                        </table>
                    </div>
        <%
                }
            } catch (Exception e) {
        %>
                <div class="info-banner error">Failed to load applications data</div>
        <%
            }
        %>
    </div>
</div>
</body>
</html>
