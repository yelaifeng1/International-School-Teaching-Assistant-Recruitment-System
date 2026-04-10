# MO审核申请模块 - 源码结构说明

## 📦 核心源码位置

### 1. Java后端代码

#### 📂 `src/main/java/com/example/tasystem/`

##### ✅ 主要Servlet

| 文件 | 路径 | 功能 | URL映射 |
|------|------|------|---------|
| **ReviewApplicationServlet.java** | `src/main/java/com/example/tasystem/` | 处理申请状态更新（Approve/Reject/Reset） | `/reviewApplication` |
| **MOReviewApplicationsServlet.java** | `src/main/java/com/example/tasystem/controller/` | 路由到MO审核页面 | `/mo/review-applications` |

---

#### 📄 ReviewApplicationServlet.java
**完整路径**: 
```
src/main/java/com/example/tasystem/ReviewApplicationServlet.java
```

**主要功能**:
- ✅ 接收POST请求，处理申请状态更新
- ✅ 读取 `applications.json` 文件
- ✅ 更新指定申请的status字段
- ✅ 回写JSON文件
- ✅ 重定向回审核页面并显示成功/错误消息

**关键代码片段**:
```java
@WebServlet("/reviewApplication")
public class ReviewApplicationServlet extends HttpServlet {
    private Path getDataPath(HttpServletRequest request) {
        return StorageResolver.dataDirectory(getServletContext())
               .resolve("applications.json");
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) {
        // 1. 获取参数 (id, status)
        // 2. 读取JSON文件
        // 3. 更新状态
        // 4. 写回文件
        // 5. 重定向
    }
}
```

---

#### 📄 MOReviewApplicationsServlet.java
**完整路径**: 
```
src/main/java/com/example/tasystem/controller/MOReviewApplicationsServlet.java
```

**主要功能**:
- ✅ 处理GET请求
- ✅ 转发到 `review-applications.jsp` 页面

**关键代码片段**:
```java
@WebServlet("/mo/review-applications")
public class MOReviewApplicationsServlet extends BaseServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) {
        User user = currentUser(request);
        render("mo/review-applications.jsp", request, response);
    }
}
```

---

### 2. JSP前端页面

#### 📂 `src/main/webapp/WEB-INF/views/mo/`

##### ✅ 主要JSP页面

| 文件 | 路径 | 功能 |
|------|------|------|
| **review-applications.jsp** | `src/main/webapp/WEB-INF/views/mo/` | MO审核申请主页面 |
| **dashboard.jsp** | `src/main/webapp/WEB-INF/views/mo/` | MO仪表板（包含审核入口链接） |

---

#### 📄 review-applications.jsp
**完整路径**: 
```
src/main/webapp/WEB-INF/views/mo/review-applications.jsp
```

**主要功能**:
- ✅ 读取 `applications.json` 文件
- ✅ 显示统计面板（Total/Pending/Approved/Rejected）
- ✅ 显示申请列表表格
- ✅ 提供三个操作按钮（Approve/Reject/Reset）
- ✅ 显示成功/错误消息

**关键代码结构**:
```jsp
<%@ page import="com.example.tasystem.util.StorageResolver" %>
<%@ page import="org.json.JSONArray" %>
<%@ page import="org.json.JSONObject" %>

<%
    // 1. 获取数据目录
    Path dataDir = StorageResolver.dataDirectory(pageContext.getServletContext());
    Path jsonFilePath = dataDir.resolve("applications.json");
    
    // 2. 读取并解析JSON
    String jsonContent = new String(Files.readAllBytes(jsonFilePath), StandardCharsets.UTF_8);
    JSONArray applicationArray = new JSONArray(jsonContent);
    
    // 3. 统计各状态数量
    int totalApplications = applicationArray.length();
    int pendingCount = 0;
    int approvedCount = 0;
    int rejectedCount = 0;
    
    // 4. 遍历计数
    for (int i = 0; i < applicationArray.length(); i++) {
        String status = app.getString("status");
        if ("Pending".equals(status)) pendingCount++;
        else if ("Approved".equals(status)) approvedCount++;
        else if ("Rejected".equals(status)) rejectedCount++;
    }
%>

<!-- 统计面板 -->
<div class="stat-grid">
    <div class="stat-item">Total: <%= totalApplications %></div>
    <div class="stat-item">Pending: <%= pendingCount %></div>
    <div class="stat-item">Approved: <%= approvedCount %></div>
    <div class="stat-item">Rejected: <%= rejectedCount %></div>
</div>

<!-- 申请列表表格 -->
<table>
    <% for (int i = 0; i < applicationArray.length(); i++) { %>
    <tr>
        <td><%= app.getInt("id") %></td>
        <td><%= app.getString("name") %></td>
        <td>
            <!-- Approve按钮 -->
            <form action="${pageContext.request.contextPath}/reviewApplication" method="post">
                <input type="hidden" name="id" value="<%= id %>">
                <button type="submit" name="status" value="Approved">Approve</button>
            </form>
            
            <!-- Reject按钮 -->
            <form action="${pageContext.request.contextPath}/reviewApplication" method="post">
                <input type="hidden" name="id" value="<%= id %>">
                <button type="submit" name="status" value="Rejected">Reject</button>
            </form>
            
            <!-- Reset按钮 -->
            <form action="${pageContext.request.contextPath}/reviewApplication" method="post">
                <input type="hidden" name="id" value="<%= id %>">
                <button type="submit" name="status" value="Pending">Reset</button>
            </form>
        </td>
    </tr>
    <% } %>
</table>
```

---

#### 📄 dashboard.jsp
**完整路径**: 
```
src/main/webapp/WEB-INF/views/mo/dashboard.jsp
```

**相关代码**:
```html
<!-- 顶部导航栏 -->
<div class="topbar-actions">
    <a href="${pageContext.request.contextPath}/mo/review-applications">Review Applications</a>
</div>

<!-- 快速操作按钮 -->
<div class="quick-actions">
    <a href="${pageContext.request.contextPath}/mo/review-applications">📋 Review Applications</a>
</div>
```

---

### 3. 工具类

#### 📂 `src/main/java/com/example/tasystem/util/`

##### ✅ StorageResolver.java
**完整路径**: 
```
src/main/java/com/example/tasystem/util/StorageResolver.java
```

**功能**: 
- ✅ 解析数据文件存储路径
- ✅ 提供统一的文件访问接口

**关键方法**:
```java
public static Path dataDirectory(ServletContext context) {
    return resolveDirectory(context, "ta.data.dir", "data", "/WEB-INF/data");
}
```

**解析优先级**:
1. 系统属性 `ta.data.dir`
2. 开发模式下的 `data/` 目录
3. **部署模式下的 `/WEB-INF/data/` 目录** ⭐ (当前使用)
4. 回退到工作目录下的 `data/`

---

### 4. 数据文件

#### 📂 数据文件位置

| 位置 | 路径 | 用途 |
|------|------|------|
| **源代码** | `data/applications.json` | Git版本控制 |
| **Web资源** | `src/main/webapp/WEB-INF/data/applications.json` | 打包到WAR |
| **运行时** ⭐ | `target/cargo/.../WEB-INF/data/applications.json` | **实际读写的文件** |
| **编译输出** | `target/classes/data/applications.json` | Maven编译输出 |

**JSON数据结构**:
```json
[
  {
    "id": 1,
    "jobId": 1,
    "applicantId": 1,
    "name": "John Doe",
    "jobTitle": "EBU6304 Software Engineering - Java TA",
    "reason": "I have experience in Java and teamwork.",
    "status": "Pending",
    "applyDate": "2026-04-01"
  }
]
```

---

## 🔄 工作流程

### 用户操作流程

```
1. MO登录系统 (mo / password123)
   ↓
2. 访问 /mo/dashboard
   ↓
3. 点击 "Review Applications" 链接
   ↓
4. MOReviewApplicationsServlet 处理请求
   ↓
5. 转发到 review-applications.jsp
   ↓
6. JSP读取 applications.json 并显示
   ↓
7. MO点击 Approve/Reject/Reset 按钮
   ↓
8. 表单POST到 /reviewApplication
   ↓
9. ReviewApplicationServlet 处理
   ↓
10. 读取JSON → 更新status → 写回JSON
    ↓
11. 重定向回 /mo/review-applications?success=...
    ↓
12. 页面刷新，显示更新后的状态
```

---

## 📊 文件依赖关系

```
MOReviewApplicationsServlet.java
  ↓ (路由)
review-applications.jsp
  ↓ (使用)
StorageResolver.java
  ↓ (解析路径)
applications.json (读取)
  ↑ (表单提交)
ReviewApplicationServlet.java
  ↓ (更新)
applications.json (写入)
```

---

## 🎯 关键文件清单

### 必需文件（MO审核模块核心）

1. ✅ `src/main/java/com/example/tasystem/ReviewApplicationServlet.java`
2. ✅ `src/main/java/com/example/tasystem/controller/MOReviewApplicationsServlet.java`
3. ✅ `src/main/webapp/WEB-INF/views/mo/review-applications.jsp`
4. ✅ `src/main/java/com/example/tasystem/util/StorageResolver.java`
5. ✅ `src/main/webapp/WEB-INF/data/applications.json`

### 相关文件

6. ✅ `src/main/webapp/WEB-INF/views/mo/dashboard.jsp` (入口链接)
7. ✅ `src/main/java/com/example/tasystem/controller/BaseServlet.java` (基类)

---

## 📦 Maven依赖

```xml
<!-- pom.xml -->
<dependency>
    <groupId>org.json</groupId>
    <artifactId>json</artifactId>
    <version>20240303</version>
</dependency>
```

---

## 🔧 配置文件

### web.xml
```xml
<!-- 字符编码过滤器 -->
<filter>
    <filter-name>CharacterEncodingFilter</filter-name>
    <filter-class>com.example.tasystem.CharacterEncodingFilter</filter-class>
</filter>
```

---

## 📝 总结

**核心包结构**:
```
com.example.tasystem
├── ReviewApplicationServlet.java          (状态更新处理)
├── controller/
│   └── MOReviewApplicationsServlet.java   (页面路由)
└── util/
    └── StorageResolver.java               (路径解析)

src/main/webapp/WEB-INF/views/mo/
├── review-applications.jsp                (审核页面)
└── dashboard.jsp                          (仪表板)

src/main/webapp/WEB-INF/data/
└── applications.json                      (数据文件)
```

**总共涉及**:
- 3个Java类
- 2个JSP页面  
- 1个JSON数据文件
- 1个工具类

所有源码都在 `com.example.tasystem` 包及其子包下。
