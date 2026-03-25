# 用户登录与角色模块 - 测试说明文档

## 📋 功能完成清单

### ✅ 已完成的功能

1. **前端表单 (login.jsp)**
   - ✅ 用户名和密码输入框
   - ✅ 记住我功能
   - ✅ 客户端表单验证
   - ✅ 美观的紫色渐变主题设计
   - ✅ 服务器错误信息显示
   - ✅ 登录失败时保留用户名

2. **后端登录服务 (LoginServlet)**
   - ✅ 接收用户名和密码
   - ✅ 调用 UserDAO 验证用户身份
   - ✅ 创建 HTTP Session 存储用户信息
   - ✅ 支持"记住我"功能的 Cookie 设置
   - ✅ 登录成功后按角色自动跳转
   - ✅ 登录失败时显示错误提示
   - ✅ 字符编码设置为 UTF-8

3. **数据访问层 (UserDAO.java)**
   - ✅ 从 users.json 读取用户数据
   - ✅ 验证用户名和密码
   - ✅ 按用户名查找用户
   - ✅ 按用户 ID 查找用户
   - ✅ 使用 Gson 解析 JSON

4. **退出登录功能 (LogoutServlet)**
   - ✅ 使 HTTP Session 失效
   - ✅ 清除"记住我" Cookie
   - ✅ 重定向回登录页面

---

## 🧪 测试账号信息

### 测试账号 1 - TA（教学助手）
```
用户名: ta
密码: 123
角色: TA
期望跳转页面: applicant/dashboard.jsp
```

### 测试账号 2 - MO（招聘主管）
```
用户名: mo
密码: 123
角色: MO
期望跳转页面: mo/dashboard.jsp
```

### 测试账号 3 - ADMIN（管理员）
```
用户名: admin
密码: 123
角色: ADMIN
期望跳转页面: admin/dashboard.jsp
```

---

## 🧪 测试用例

### 测试 1：成功登录 - TA 角色
**步骤：**
1. 打开登录页面 `http://localhost:8080/ta-recruitment-system/login.jsp`
2. 输入用户名：`ta`
3. 输入密码：`123`
4. 点击"登录"按钮

**预期结果：**
- ✅ 页面自动跳转到 `applicant/dashboard.jsp`
- ✅ Session 中存储了用户信息（username=ta, role=TA）

---

### 测试 2：成功登录 - MO 角色
**步骤：**
1. 打开登录页面 `http://localhost:8080/ta-recruitment-system/login.jsp`
2. 输入用户名：`mo`
3. 输入密码：`123`
4. 点击"登录"按钮

**预期结果：**
- ✅ 页面自动跳转到 `mo/dashboard.jsp`
- ✅ Session 中存储了用户信息（username=mo, role=MO）

---

### 测试 3：成功登录 - ADMIN 角色
**步骤：**
1. 打开登录页面 `http://localhost:8080/ta-recruitment-system/login.jsp`
2. 输入用户名：`admin`
3. 输入密码：`123`
4. 点击"登录"按钮

**预期结果：**
- ✅ 页面自动跳转到 `admin/dashboard.jsp`
- ✅ Session 中存储了用户信息（username=admin, role=ADMIN）

---

### 测试 4：登录失败 - 错误的用户名
**步骤：**
1. 打开登录页面
2. 输入用户名：`invalid_user`
3. 输入密码：`123`
4. 点击"登录"按钮

**预期结果：**
- ✅ 页面留在登录页面
- ✅ 显示错误提示："用户名或密码错误，请重试"
- ✅ 用户输入的用户名保留在输入框中

---

### 测试 5：登录失败 - 错误的密码
**步骤：**
1. 打开登录页面
2. 输入用户名：`ta`
3. 输入密码：`wrong_password`
4. 点击"登录"按钮

**预期结果：**
- ✅ 页面留在登录页面
- ✅ 显示错误提示："用户名或密码错误，请重试"
- ✅ 用户输入的用户名保留在输入框中

---

### 测试 6：客户端验证 - 空用户名
**步骤：**
1. 打开登录页面
2. 不填写用户名
3. 点击"登录"按钮

**预期结果：**
- ✅ 显示客户端验证错误："用户名和密码不能为空！"
- ✅ 表单不提交到服务器

---

### 测试 7：客户端验证 - 短用户名
**步骤：**
1. 打开登录页面
2. 输入用户名：`ab`（少于 3 个字符）
3. 输入密码：`123456`
4. 点击"登录"按钮

**预期结果：**
- ✅ 显示客户端验证错误："用户名至少需要3个字符！"
- ✅ 表单不提交到服务器

---

### 测试 8：客户端验证 - 短密码
**步骤：**
1. 打开登录页面
2. 输入用户名：`ta`
3. 输入密码：`123`（少于 6 个字符）
4. 点击"登录"按钮

**预期结果：**
- ✅ 显示客户端验证错误："密码至少需要6个字符！"
- ✅ 表单不提交到服务器

---

### 测试 9：记住我功能
**步骤：**
1. 打开登录页面
2. 输入用户名：`ta`
3. 输入密码：`123`
4. 勾选"记住我"
5. 点击"登录"按钮
6. 登录成功后，关闭浏览器
7. 打开浏览器开发者工具（F12），查看 Cookies

**预期结果：**
- ✅ 成功登录后，浏览器 Cookies 中存储了 `username=ta`
- ✅ Cookie 过期时间为 7 天

---

### 测试 10：退出登录
**步骤：**
1. 使用账号 `ta/123` 成功登录
2. 访问 `http://localhost:8080/ta-recruitment-system/logout`
3. 检查是否返回到登录页面

**预期结果：**
- ✅ Session 被清空
- ✅ 记住我 Cookie 被删除
- ✅ 页面重定向到登录页面
- ✅ 无法通过浏览器后退按钮访问原来的受保护页面

---

## 🏗️ 架构说明

### 项目结构
```
src/main/java/com/group50/tasystem/
├── controller/
│   ├── LoginServlet.java      # 处理登录请求
│   └── LogoutServlet.java     # 处理退出登录请求
├── dao/
│   └── UserDAO.java           # 用户数据访问对象
└── model/
    └── User.java              # 用户实体类

src/main/webapp/
├── login.jsp                  # 登录表单页面
└── WEB-INF/
    └── web.xml                # Web 应用配置

data/
└── users.json                 # 用户数据存储文件
```

### 登录流程图
```
登录页面 (login.jsp)
    ↓
用户填写账号密码 → 客户端验证 (JavaScript)
    ↓
表单提交 POST /login
    ↓
LoginServlet.doPost()
    ↓
UserDAO.validateLogin()
    ↓
读取 users.json 验证身份
    ↓
验证成功?
├─ 是 → 创建 Session → 检查记住我 → 设置 Cookie → 按角色跳转
└─ 否 → 返回错误信息 → 转发回 login.jsp
```

---

## 🚀 运行和测试

### 编译项目
```bash
mvn clean compile
```

### 生成 WAR 包
```bash
mvn package
```

### 在 Jetty 中运行（开发模式）
```bash
mvn jetty:run
```

然后在浏览器中访问：`http://localhost:8080/ta-recruitment-system/`

### 部署到 Tomcat 9（生产模式）
1. 生成 WAR 包：`mvn package`
2. 将 `target/ta-recruitment-system.war` 复制到 Tomcat 的 `webapps` 目录
3. 启动 Tomcat
4. 访问：`http://localhost:8080/ta-recruitment-system/`

---

## ⚠️ 注意事项

1. **数据持久化**：用户数据现在从 `data/users.json` 文件读取，重启应用后数据不会丢失
2. **密码安全**：目前密码以明文存储在 JSON 文件中。在生产环境中应该使用密码加密存储
3. **会话超时**：默认会话超时时间为 30 分钟（可在 web.xml 中配置）
4. **并发访问**：Java Servlet 天生支持多用户并发访问
5. **字符编码**：所有页面和 Servlet 都设置了 UTF-8 编码，支持中文

---

## 📝 完成交付清单

- ✅ 3 个测试账号能够登录（ta, mo, admin）
- ✅ 不同角色进入不同的仪表板页面
- ✅ 登录失败时显示错误提示
- ✅ 支持"记住我"功能
- ✅ 支持退出登录
- ✅ 所有代码使用 UTF-8 编码，支持中文
- ✅ 项目可以编译并生成 WAR 包

---

**模块负责人**: 用户  
**完成日期**: 2026 年 3 月 25 日  
**状态**: ✅ 已完成
