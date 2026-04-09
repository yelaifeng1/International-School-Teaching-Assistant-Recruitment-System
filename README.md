# International School Teaching Assistant Recruitment System

国际学校助教招聘系统，一个基于 Java Web 的轻量级招聘流程演示项目。系统围绕 TA 申请者、课程负责人（MO）和管理员三类角色，覆盖账号注册登录、岗位发布、岗位申请、审核录用和后台总览等核心流程。

本项目采用 `Servlet + JSP + Service + DAO + JSON` 的分层实现

## 1. 项目概览

### 1.1 业务目标

系统用于模拟国际学校教学助理招聘流程，支持以下闭环：

1. 申请者注册账号并完善个人资料。
2. MO 发布助教岗位并查看申请情况。
3. 申请者浏览开放岗位并提交申请。
4. MO 审核申请并录用候选人。
5. 系统自动生成录用记录，并将岗位状态更新为已招满。
6. 管理员查看全局用户、岗位、申请和录用情况。

### 1.2 角色划分

- `TA`：Teaching Assistant Applicant，助教申请者
- `MO`：Module Organiser，课程负责人
- `ADMIN`：管理员

### 1.3 演示账号

- `ta / ta123456`
- `mo / mo123456`
- `admin / admin123456`

这些初始数据由系统启动时自动写入 `data/` 目录。

## 2. 技术栈

### 2.1 后端

- `Java 17`
- `Servlet 4.0.1`
- `JSP 2.3.3`
- `JSTL 1.2`
- `Gson 2.8.9`

### 2.2 构建与运行

- `Maven`
- `Maven WAR Plugin`
- `Cargo Maven Plugin`
- `Tomcat 9.0.115`

### 2.3 前端

- `JSP`
- `HTML5`
- `CSS3`
- 少量基于服务端渲染的数据展示，不依赖前端框架

### 2.4 数据持久化

- 使用本地 `JSON` 文件进行持久化
- 无数据库依赖
- 每次写操作即时落盘

## 3. 架构设计

项目采用典型 MVC 风格分层：

- `Controller`：基于 `@WebServlet` 暴露路由，处理请求分发和页面跳转
- `Service`：封装业务规则、校验逻辑和状态流转
- `DAO`：基于 JSON 文件读写进行持久化
- `Model`：定义用户、岗位、申请、录用等领域对象
- `View`：基于 JSP 展示页面
- `Filter / Listener / Util`：处理鉴权、启动初始化、会话和工具能力

核心调用链如下：

```text
Browser
  -> Servlet Controller
  -> Service
  -> DAO
  -> JSON files
  -> JSP View
```

## 4. 项目结构

```text
International-School-Teaching-Assistant-Recruitment-System/
├─ pom.xml
├─ README.md
├─ data/
│  ├─ applicants.json
│  ├─ applications.json
│  ├─ jobs.json
│  ├─ users.json
│  └─ workload.json
├─ src/
│  └─ main/
│     ├─ java/
│     │  └─ com/example/tasystem/
│     │     ├─ controller/
│     │     │  ├─ AdminDashboardServlet.java
│     │     │  ├─ ApplicantApplicationsServlet.java
│     │     │  ├─ ApplicantDashboardServlet.java
│     │     │  ├─ ApplicantProfileServlet.java
│     │     │  ├─ BaseServlet.java
│     │     │  ├─ JobDetailServlet.java
│     │     │  ├─ JobsServlet.java
│     │     │  ├─ LoginServlet.java
│     │     │  ├─ LogoutServlet.java
│     │     │  ├─ ManagerApplicationsServlet.java
│     │     │  ├─ ManagerDashboardServlet.java
│     │     │  ├─ ManagerJobFormServlet.java
│     │     │  ├─ ManagerJobsServlet.java
│     │     │  ├─ ManagerJobStatusServlet.java
│     │     │  ├─ ManagerReviewServlet.java
│     │     │  ├─ RegisterServlet.java
│     │     │  └─ SubmitApplicationServlet.java
│     │     ├─ dao/
│     │     │  ├─ ApplicantDAO.java
│     │     │  ├─ ApplicationDAO.java
│     │     │  ├─ JobDAO.java
│     │     │  ├─ JsonFileDao.java
│     │     │  ├─ UserDAO.java
│     │     │  └─ WorkloadDAO.java
│     │     ├─ filter/
│     │     │  └─ AuthenticationFilter.java
│     │     ├─ listener/
│     │     │  └─ AppBootstrapListener.java
│     │     ├─ model/
│     │     │  ├─ Applicant.java
│     │     │  ├─ Application.java
│     │     │  ├─ ApplicationView.java
│     │     │  ├─ FlashMessage.java
│     │     │  ├─ Job.java
│     │     │  ├─ ServiceResult.java
│     │     │  ├─ User.java
│     │     │  ├─ Workload.java
│     │     │  └─ WorkloadView.java
│     │     ├─ service/
│     │     │  ├─ AppServices.java
│     │     │  ├─ ApplicantService.java
│     │     │  ├─ ApplicationService.java
│     │     │  ├─ AuthService.java
│     │     │  ├─ JobService.java
│     │     │  └─ SeedDataService.java
│     │     └─ util/
│     │        ├─ FlashUtil.java
│     │        ├─ IdGenerator.java
│     │        ├─ JsonUtil.java
│     │        ├─ Roles.java
│     │        ├─ SessionUtil.java
│     │        └─ StorageResolver.java
│     └─ webapp/
│        ├─ assets/
│        │  ├─ app.css
│        │  └─ auth-bg/
│        ├─ index.jsp
│        └─ WEB-INF/
│           ├─ web.xml
│           └─ views/
│              ├─ admin/dashboard.jsp
│              ├─ applicant/
│              ├─ auth/
│              ├─ jobs/
│              └─ mo/
└─ target/
```

## 5. 模块化功能实现情况

以下内容基于当前代码实际实现情况整理，不包含尚未落地的设想功能。

### 5.1 认证与权限模块

| 功能 | 实现情况 | 状态 |
|---|---|---|
| 用户注册 | 支持用户名、密码、角色注册 | 已实现 |
| 用户登录 | 支持账号密码登录 | 已实现 |
| 记住用户名 | 通过 Cookie 保存用户名 7 天 | 已实现 |
| 注销登录 | 清理 Session 和 Cookie | 已实现 |
| 角色权限控制 | `AuthenticationFilter` 拦截并限制页面访问 | 已实现 |
| 密码加密存储 | 当前仍为明文密码 | 未实现 |

认证规则摘要：

- 用户名长度限制为 `3-20`
- 用户名不能包含空格
- 密码至少 `8` 位
- 密码必须同时包含字母和数字
- 未登录用户只能访问首页、登录、注册和静态资源

### 5.2 TA 申请者模块

| 功能 | 实现情况 | 状态 |
|---|---|---|
| 申请者首页 | 展示资料完成度、可申请岗位数、申请数、录用数 | 已实现 |
| 个人资料维护 | 支持姓名、学号、邮箱、电话、技能、可用时间、CV 路径 | 已实现 |
| 岗位浏览 | 可查看开放岗位列表和详情 | 已实现 |
| 投递申请 | 可提交个人陈述并投递岗位 | 已实现 |
| 重复申请校验 | 同一申请者不能重复申请同一岗位 | 已实现 |
| 申请记录查看 | 可查看自己的申请状态和审核意见 | 已实现 |
| 录用结果查看 | 可查看自己的 assignment 记录 | 已实现 |
| 简历文件上传 | 当前仅保存 `cvPath` 文本字段，不支持真实上传 | 未实现 |

申请前置规则：

- 仅 `TA` 角色允许投递申请
- 必须先完善个人资料
- 岗位必须处于 `OPEN` 状态
- 岗位截止日期不能早于当前日期

### 5.3 MO 岗位管理模块

| 功能 | 实现情况 | 状态 |
|---|---|---|
| MO 首页 | 展示自己创建的岗位、申请和录用情况 | 已实现 |
| 发布岗位 | 支持课程代码、课程名、要求、截止日期录入 | 已实现 |
| 岗位列表 | 仅查看自己创建的岗位 | 已实现 |
| 岗位状态变更 | 支持 `OPEN / CLOSED / FILLED` | 已实现 |
| 查看岗位申请数 | 列表页汇总每个岗位的申请总数和待审核数 | 已实现 |
| 审核申请 | 支持 `APPROVED / REJECTED` 审核 | 已实现 |
| 权限隔离 | 只能管理自己创建的岗位与其申请 | 已实现 |
| 编辑岗位内容 | 当前不支持修改课程名称、要求、截止日期 | 未实现 |

审核规则：

- 一个岗位最多只能有一个 `APPROVED` 申请
- 审核通过后，系统自动：
  - 生成一条 `workload` 录用记录
  - 将岗位状态改为 `FILLED`
  - 将同岗位其他申请置为 `REJECTED`
- 若取消已通过申请，系统会删除对应录用记录，并根据截止日期重新判定岗位恢复为 `OPEN` 或 `CLOSED`

### 5.4 管理员模块

| 功能 | 实现情况 | 状态 |
|---|---|---|
| 管理员首页 | 查看系统级用户、岗位、申请、录用统计 | 已实现 |
| 用户总览 | 展示全部用户 | 已实现 |
| 岗位总览 | 展示全部岗位 | 已实现 |
| 申请总览 | 展示全部申请 | 已实现 |
| 录用统计 | 展示 assignment 数量 | 已实现 |
| 管理员增删改用户 | 当前未提供页面和接口 | 未实现 |

### 5.5 系统基础设施模块

| 功能 | 实现情况 | 状态 |
|---|---|---|
| 启动初始化 | 监听器自动初始化服务和演示数据 | 已实现 |
| JSON 存储目录自动创建 | `StorageResolver` 自动创建目录 | 已实现 |
| Flash 消息 | 用于成功/失败提示 | 已实现 |
| 旧路由兼容跳转 | 旧 JSP 地址会重定向到新路由 | 已实现 |
| 自动化测试 | `src/test` 目录当前为空 | 未实现 |

## 6. 关键业务状态流转

### 6.1 岗位状态

- `OPEN`：开放申请
- `CLOSED`：停止申请
- `FILLED`：已录用，岗位招满

### 6.2 申请状态

- `PENDING`：待审核
- `APPROVED`：已通过
- `REJECTED`：已拒绝

### 6.3 录用状态

- `ACTIVE`：当前有效录用记录

### 6.4 招聘流程

```text
注册/登录
  -> 完善申请者资料
  -> 浏览开放岗位
  -> 提交申请
  -> MO 审核
      -> APPROVED -> 生成 workload -> Job = FILLED
      -> REJECTED -> 保留申请记录
  -> 申请者查看结果
```

## 7. 数据结构设计

当前系统使用 5 个 JSON 文件作为“表”。

### 7.1 `users.json`

用户基础信息表。

| 字段 | 类型 | 说明 |
|---|---|---|
| `userId` | String | 用户主键，如 `U001` |
| `username` | String | 登录用户名 |
| `password` | String | 登录密码，当前明文存储 |
| `role` | String | 角色：`TA` / `MO` / `ADMIN` |
| `email` | String | 邮箱 |
| `displayName` | String | 展示名称 |
| `createdAt` | String | 创建日期，格式 `yyyy-MM-dd` |

### 7.2 `applicants.json`

申请者扩展资料表，与 `users.json` 通过 `userId` 关联。

| 字段 | 类型 | 说明 |
|---|---|---|
| `applicantId` | String | 申请者主键，如 `AP001` |
| `userId` | String | 对应用户 ID |
| `fullName` | String | 真实姓名 |
| `studentId` | String | 学号 |
| `email` | String | 联系邮箱 |
| `phone` | String | 联系电话 |
| `skills` | String | 技能说明 |
| `availability` | String | 可用时间 |
| `cvPath` | String | 简历路径或说明文本 |

### 7.3 `jobs.json`

岗位信息表。

| 字段 | 类型 | 说明 |
|---|---|---|
| `jobId` | String | 岗位主键，如 `J001` |
| `courseCode` | String | 课程代码 |
| `courseName` | String | 课程名称 |
| `lecturerName` | String | 任课教师或负责人名称 |
| `requirements` | String | 招聘要求 |
| `deadline` | String | 截止日期 |
| `status` | String | 岗位状态：`OPEN` / `CLOSED` / `FILLED` |
| `createdByUserId` | String | 创建岗位的 MO 用户 ID |
| `createdAt` | String | 创建日期 |

### 7.4 `applications.json`

岗位申请记录表。

| 字段 | 类型 | 说明 |
|---|---|---|
| `applicationId` | String | 申请主键，如 `APP001` |
| `applicantId` | String | 申请者 ID |
| `jobId` | String | 岗位 ID |
| `applyDate` | String | 申请日期 |
| `personalStatement` | String | 个人陈述 |
| `status` | String | 申请状态：`PENDING` / `APPROVED` / `REJECTED` |
| `reviewerComment` | String | MO 审核意见 |

### 7.5 `workload.json`

录用结果或工作量分配记录表。

| 字段 | 类型 | 说明 |
|---|---|---|
| `assignmentId` | String | 录用记录主键，如 `WL001` |
| `applicationId` | String | 对应申请 ID |
| `applicantId` | String | 被录用申请者 ID |
| `jobId` | String | 对应岗位 ID |
| `assignedAt` | String | 录用日期 |
| `status` | String | 当前状态，现阶段使用 `ACTIVE` |

### 7.6 视图模型

系统还定义了两类仅用于页面展示的聚合对象，不直接持久化：

- `ApplicationView`
  - 将 `Application + Applicant + Job` 聚合成可直接展示的申请信息
- `WorkloadView`
  - 将 `Workload + Job` 聚合成录用展示信息

### 7.7 数据关系

```text
User (1) ---- (0..1) Applicant
Applicant (1) ---- (N) Application
Job (1) ---- (N) Application
Application (1) ---- (0..1) Workload
MO User (1) ---- (N) Job
```

## 8. 主要访问路径

### 8.1 公共页面

- `/`
- `/login`
- `/register`
- `/jobs`
- `/jobs/detail?id=J001`

### 8.2 TA 页面

- `/applicant/dashboard`
- `/applicant/profile`
- `/applicant/applications`
- `POST /applications`

### 8.3 MO 页面

- `/mo/dashboard`
- `/mo/jobs`
- `/mo/jobs/new`
- `POST /mo/jobs/status`
- `/mo/applications`
- `POST /mo/applications/review`

### 8.4 管理员页面

- `/admin/dashboard`

> 本系统基于传统 Java Web 技术栈实现，采用 MVC 分层结构和 JSON 文件持久化方式，完成了国际学校助教招聘场景下的注册登录、岗位发布、申请投递、审核录用和后台总览等核心业务流程，具备较完整的角色权限控制、状态流转和数据组织能力。
