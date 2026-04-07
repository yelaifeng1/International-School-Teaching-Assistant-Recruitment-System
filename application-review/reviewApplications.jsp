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
            font-family: Arial;
            background-color: #f5f5f5;
            text-align: center;
        }
        h1 {
            color: #333;
        }
        .msg {
            color: #28a745;
            margin: 10px 0;
        }
        .error {
            color: #dc3545;
            margin: 10px 0;
        }
        table {
            margin: 20px auto;
            border-collapse: collapse;
            width: 80%;
            background: white;
        }
        th, td {
            border: 1px solid #ccc;
            padding: 10px;
        }
        th {
            background-color: #007BFF;
            color: white;
        }
        button {
            padding: 6px 12px;
            margin: 2px;
            border: none;
            cursor: pointer;
        }
        .approve {
            background-color: #28a745;
            color: white;
        }
        .reject {
            background-color: #dc3545;
            color: white;
        }
        .pending {
            background-color: #ffc107;
            color: #333;
        }
    </style>
</head>
<body>
    <h1>Application Review System</h1>
    <p>MO can review applications below</p>

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
            // 和Servlet里的路径保持一致
            String JSON_FILE_PATH = "/your/project/path/application-review/applications.json";
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
        %>
                    <tr>
                        <td><%= id %></td>
                        <td><%= name %></td>
                        <td><%= jobTitle %></td>
                        <td><%= reason %></td>
                        <td><%= status %></td>
                        <td>
                            <!-- 每条申请对应独立的表单，id动态生成，完全匹配需求的3种状态 -->
                            <form action="reviewApplication" method="post" style="display: inline;">
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
</body>
</html>
