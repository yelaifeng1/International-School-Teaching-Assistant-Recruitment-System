# TA Recruitment System - Login Module Demo

这是一个围绕“系统入口”实现的 V1 Demo，覆盖以下功能：

- `login.jsp` 登录页
- `LoginServlet` 登录处理
- 从 `users.json` 读取账号
- 登录校验（用户名 + 密码）
- 按角色跳转页面
	- `TA` -> applicant dashboard
	- `MO` -> mo dashboard
	- `Admin` -> admin dashboard
- `LogoutServlet` 基础退出登录
- 登录失败提示

## 项目结构

```text
src/
	main/
		java/com/group50/auth/
			model/User.java
			service/UserService.java
			servlet/LoginServlet.java
			servlet/LogoutServlet.java
		resources/
			users.json
		webapp/
			index.jsp
			login.jsp
			applicant/dashboard.jsp
			mo/dashboard.jsp
			admin/dashboard.jsp
pom.xml
```

## 测试账号（至少 3 个）

1. `ta01 / 123456`（TA）
2. `mo01 / 123456`（MO）
3. `admin01 / admin123`（Admin）

账号定义文件：`src/main/resources/users.json`

## 本地运行方式

1. 构建项目：

```bash
mvn clean package
```

2. 将生成的 `target/ta-recruitment-demo.war` 部署到 Tomcat 10+。

3. 访问：

```text
http://localhost:8080/ta-recruitment-demo/
```

系统会自动跳转到登录页。

## 验收点对应

- 3 个测试账号可登录：已实现（`users.json`）
- 不同角色进入不同页面：已实现（`LoginServlet`）
- 登录失败有提示：已实现（`login.jsp` 中显示错误消息）