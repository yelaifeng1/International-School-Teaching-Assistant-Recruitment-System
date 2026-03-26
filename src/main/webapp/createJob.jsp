<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%
    // 临时测试代码：如果 session 中没有角色，则设置为 MO 并设置姓名
    if (session.getAttribute("role") == null) {
        session.setAttribute("role", "MO");
        session.setAttribute("name", "测试讲师");
    }
    String role = (String) session.getAttribute("role");
    if (!"MO".equals(role)) {
        response.sendError(403, "只有模块负责人可以发布岗位");
        return;
    }
%>
<html>
<head>
    <title>发布新岗位</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="container mt-4">
<h2>发布新岗位</h2>
<form action="<%= request.getContextPath() %>/jobs" method="post">
    <div class="mb-3">
        <label class="form-label">课程代码</label>
        <input type="text" name="courseCode" class="form-control" required>
    </div>
    <div class="mb-3">
        <label class="form-label">课程名称</label>
        <input type="text" name="courseName" class="form-control" required>
    </div>
    <div class="mb-3">
        <label class="form-label">主讲教师</label>
        <input type="text" class="form-control" value="<%= session.getAttribute("name") %>" disabled>
        <!-- 实际提交时 lecturerName 从 session 获取，无需在表单中填写 -->
    </div>
    <div class="mb-3">
        <label class="form-label">岗位要求</label>
        <textarea name="requirements" rows="4" class="form-control" required></textarea>
    </div>
    <div class="mb-3">
        <label class="form-label">申请截止日期</label>
        <input type="date" name="deadline" class="form-control" required>
    </div>
    <button type="submit" class="btn btn-primary">发布岗位</button>
    <a href="manageJobs.jsp" class="btn btn-secondary">返回</a>
</form>
</body>
</html>