# International School Teaching Assistant Recruitment System

一个基于 Java Web 的教学助理招聘系统，支持申请者、课程负责人（MO）和管理员三类角色，覆盖岗位发布、申请提交、审核管理等核心流程。

## 1. 项目简介

本项目采用 Servlet + JSP + Maven + Tomcat 的经典 Java Web 架构，面向课程作业场景，具备以下特点：

- 角色清晰：TA 申请者、MO、Admin
- 页面完整：登录、注册、岗位浏览、申请管理、后台看板
- 数据持久化：使用 JSON 文件落盘，方便演示与调试
- 可快速启动：通过 Maven Cargo 一键启动内置 Tomcat

## 2. 技术栈

- Java 17
- Maven
- Servlet 4.0
- JSP + JSTL
- Gson
- Tomcat 9（由 Cargo 插件管理）

## 3. 目录结构

```text
International-School-Teaching-Assistant-Recruitment-System/
  pom.xml
  README.md
  data/
    users.json
    jobs.json
    applicants.json
    applications.json
    workload.json
  src/
    main/
      java/com/example/tasystem/
      webapp/
        assets/
        WEB-INF/views/
```

## 4. 角色与演示账号

- TA: ta / ta123456
- MO: mo / mo123456
- Admin: admin / admin123456

## 5. 快速启动

### 5.1 构建

```bash
mvn -f pom.xml clean package
```

### 5.2 运行（前台）

```bash
mvn -f pom.xml cargo:run
```

启动后访问：

- http://localhost:8080/ta-recruitment-system

### 5.3 后台启动与停止

```bash
mvn -f pom.xml cargo:start
mvn -f pom.xml cargo:stop
```

## 6. 常用页面路由

- /
- /login
- /register
- /jobs
- /jobs/detail?id=J001
- /applications
- /applicant/dashboard
- /applicant/profile
- /applicant/applications
- /mo/dashboard
- /mo/jobs
- /mo/jobs/new
- /mo/applications
- /admin/dashboard

完整访问时请带上应用上下文：

- http://localhost:8080/ta-recruitment-system/login

## 7. 数据说明

项目数据默认存储在根目录 data 下，写入后会立即持久化。

如需指定自定义数据目录，可启动时传参：

```bash
-Dta.data.dir=<your_data_path>
```

## 8. 前端资源说明

- 通用样式：src/main/webapp/assets/app.css
- 登录/注册背景图：src/main/webapp/assets/auth-bg/

说明：登录/注册页会读取 auth-bg 中的图片作为背景素材，并进行动态排布。

## 9. 常见问题

### 9.1 端口被占用

如果启动时报端口占用（如 8080 或 Cargo 相关端口），请先结束占用进程，再启动。

### 9.2 页面样式未更新

如果页面看起来还是旧样式：

- 先执行一次 redeploy
- 浏览器使用强制刷新（Ctrl + F5）

```bash
mvn -f pom.xml -DskipTests package cargo:redeploy
```

### 9.3 target/cargo 文件被占用

Windows 下偶发文件锁问题，可先停止运行中的 Java/Tomcat 进程，再重新启动 Cargo。

## 10. 开发建议

- 提交前先执行 package，保证可构建
- 修改前端资源后建议 redeploy 验证
- data 目录建议纳入备份，避免演示数据丢失

---

如需扩展功能（邮件通知、审批流、统计报表、权限细化、数据库替换），可在现有 MVC 分层基础上逐步演进。
