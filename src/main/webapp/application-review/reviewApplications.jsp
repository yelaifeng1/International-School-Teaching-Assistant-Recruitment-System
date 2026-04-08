<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.nio.file.Files" %>
<%@ page import="java.nio.file.Paths" %>
<%@ page import="java.nio.charset.StandardCharsets" %>
<%@ page import="org.json.JSONArray" %>
<%@ page import="org.json.JSONObject" %>
<!DOCTYPE html>
<html>
<head>
    <title>Application Review</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f5f5f5;
            margin: 0;
            padding: 20px;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        h1 {
            color: #333;
            text-align: center;
        }
        .nav {
            text-align: center;
            margin-bottom: 20px;
        }
        .nav a {
            margin: 0 10px;
            text-decoration: none;
            color: #007BFF;
        }
        .nav a:hover {
            text-decoration: underline;
        }
        .msg {
            color: #28a745;
            text-align: center;
            padding: 10px;
            background: #d4edda;
            border-radius: 4px;
            margin-bottom: 15px;
        }
        .error {
            color: #dc3545;
            text-align: center;
            padding: 10px;
            background: #f8d7da;
            border-radius: 4px;
            margin-bottom: 15px;
        }
        table {
            margin: 20px auto;
            border-collapse: collapse;
            width: 100%;
            background: white;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 12px;
            text-align: left;
        }
        th {
            background-color: #007BFF;
            color: white;
        }
        tr:nth-child(even) {
            background-color: #f9f9f9;
        }
        button {
            padding: 6px 12px;
            margin: 2px;
            border: none;
            cursor: pointer;
            border-radius: 4px;
        }
        .approve {
            background-color: #28a745;
            color: white;
        }
        .approve:hover {
            background-color: #218838;
        }
        .reject {
            background-color: #dc3545;
            color: white;
        }
        .reject:hover {
            background-color: #c82333;
        }
        .pending {
            background-color: #ffc107;
            color: #333;
        }
        .pending:hover {
            background-color: #e0a800;
        }
        .status-pending {
            color: #ffc107;
            font-weight: bold;
        }
        .status-approved {
            color: #28a745;
            font-weight: bold;
        }
        .status-rejected {
            color: #dc3545;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <div class="container">
    <h1>Application Review System</h1>
    <p style="text-align: center; color: #666;">Module Organisers can review and manage applications here</p>
    
    <div class="nav">
        <a href="../index.jsp">Home</a> |
        <a href="../mo-module/postJob.jsp">Post Job</a> |
        <a href="reviewApplications.jsp">Review Applications</a> |
        <a href="../admin">Admin Dashboard</a>
    </div>

    <!-- 提示信息 -->
    <% if (request.getParameter("success") != null) { %>
        <div class="msg"><%= request.getParameter("success") %></div>
    <% } %>
    <% if (request.getParameter("error") != null) { %>
        <div class="error"><%= request.getParameter("error") %></div>
    <% } %>

    <table>
        <tr>
            <th>ID</th>
            <th>TA Name</th>
            <th>Job Title</th>
            <th>Application Reason</th>
            <th>Current Status</th>
            <th>Review Action</th>
        </tr>

        <%
            // 使用统一的数据目录
            String JSON_FILE_PATH = System.getProperty("user.dir") + "/target/classes/data/applications.json";
            try {
                // 动态读取JSON文件
                String jsonContent = new String(Files.readAllBytes(Paths.get(JSON_FILE_PATH)), StandardCharsets.UTF_8);
                JSONArray applicationArray = new JSONArray(jsonContent);

                // 循环生成表格行，每条申请对应一行
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
                        <td><%= id %></td>
                        <td><%= name %></td>
                        <td><%= jobTitle %></td>
                        <td><%= reason %></td>
                        <td class="<%= statusClass %>"><%= status %></td>
                        <td>
                            <!-- 每条申请对应独立的表单，id动态生成，完全匹配需求的3种状态 -->
                            <form action="/reviewApplication" method="post" style="display: inline;">
                                <input type="hidden" name="id" value="<%= id %>">
                                <button class="approve" type="submit" name="status" value="Approved">Approve</button>
                                <button class="reject" type="submit" name="status" value="Rejected">Reject</button>
                                <button class="pending" type="submit" name="status" value="Pending">Reset to Pending</button>
                            </form>
                        </td>
                    </tr>
        <%
                }
            } catch (Exception e) {
                e.printStackTrace();
        %>
                <tr>
                    <td colspan="6" class="error">Failed to load application data</td>
                </tr>
        <%
            }
        %>
    </table>
    </div>
</body>
</html>
