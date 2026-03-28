<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.example.model.Job" %>
<%@ page import="com.example.dao.JobRepository" %>
<%
    // 临时测试代码：确保 session 中有角色
    if (session.getAttribute("role") == null) {
        session.setAttribute("role", "MO");
        session.setAttribute("name", "测试讲师");
    }
    String role = (String) session.getAttribute("role");
    if (!"MO".equals(role)) {
        response.sendError(403);
        return;
    }
    String lecturerName = (String) session.getAttribute("name");
    JobRepository repo = new JobRepository(application);
    List<Job> allJobs = repo.findAll();
    List<Job> myJobs = allJobs.stream()
            .filter(job -> job.getLecturerName().equals(lecturerName))
            .toList();
%>
<html>
<head>
    <title>我发布的岗位</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="container mt-4">
<h2>我发布的岗位</h2>
<a href="createJob.jsp" class="btn btn-success mb-3">发布新岗位</a>
<table class="table table-bordered">
    <thead>
        <tr>
            <th>课程代码</th>
            <th>课程名称</th>
            <th>截止日期</th>
            <th>状态</th>
            <th>操作</th>
        </tr>
    </thead>
    <tbody>
        <%
            for (Job job : myJobs) {
        %>
         <tr>
             <td><%= job.getCourseCode() %></td>
             <td><%= job.getCourseName() %></td>
             <td><%= job.getDeadline() %></td>
             <td><%= "open".equals(job.getStatus()) ? "开放中" : "已关闭" %></td>
             <td>
                <a href="<%= request.getContextPath() %>/jobs?jobId=<%= job.getJobId() %>" class="btn btn-sm btn-primary">查看详情</a>
                <!-- 后续可添加编辑、关闭按钮 -->
             </td>
         </tr>
        <%
            }
            if (myJobs.isEmpty()) {
        %>
         <tr><td colspan="5" class="text-center">您还没有发布任何岗位</td></tr>
        <% } %>
    </tbody>
</table>
</body>
</html>