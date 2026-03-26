<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.example.model.Job" %>
<%
    List<Job> jobs = (List<Job>) request.getAttribute("jobs");
    if (jobs == null) {
        response.sendRedirect(request.getContextPath() + "/jobs");
        return;
    }
%>
<html>
<head>
    <title>岗位列表</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="container mt-4">
<h2>助教岗位列表</h2>
<table class="table table-bordered">
    <thead>
        <tr>
            <th>课程代码</th>
            <th>课程名称</th>
            <th>主讲教师</th>
            <th>截止日期</th>
            <th>状态</th>
            <th>操作</th>
        </tr>
    </thead>
    <tbody>
        <%
            for (Job job : jobs) {
        %>
         <tr>
             <td><%= job.getCourseCode() %></td>
             <td><%= job.getCourseName() %></td>
             <td><%= job.getLecturerName() %></td>
             <td><%= job.getDeadline() %></td>
             <td><%= "open".equals(job.getStatus()) ? "开放中" : "已关闭" %></td>
             <td><a href="<%= request.getContextPath() %>/jobs?jobId=<%= job.getJobId() %>" class="btn btn-sm btn-primary">查看详情</a></td>
         </tr>
        <%
            }
            if (jobs.isEmpty()) {
        %>
         <tr><td colspan="6" class="text-center">暂无岗位</td></tr>
        <% } %>
    </tbody>
</table>
</body>
</html>