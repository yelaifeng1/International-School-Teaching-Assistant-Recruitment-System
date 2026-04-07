<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.model.Job" %>
<%
    Job job = (Job) request.getAttribute("job");
    if (job == null) {
        response.sendError(404);
        return;
    }
%>
<html>
<head>
    <title>岗位详情</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="container mt-4">
<h2>岗位详情</h2>
<div class="card">
    <div class="card-body">
        <p><strong>课程代码：</strong> <%= job.getCourseCode() %></p>
        <p><strong>课程名称：</strong> <%= job.getCourseName() %></p>
        <p><strong>主讲教师：</strong> <%= job.getLecturerName() %></p>
        <p><strong>岗位要求：</strong></p>
        <p><%= job.getRequirements().replace("\n", "<br>") %></p>
        <p><strong>申请截止日期：</strong> <%= job.getDeadline() %></p>
        <p><strong>状态：</strong> <%= "open".equals(job.getStatus()) ? "开放中" : "已关闭" %></p>
        <a href="<%= request.getContextPath() %>/jobs" class="btn btn-secondary">返回列表</a>
    </div>
</div>
</body>
</html>