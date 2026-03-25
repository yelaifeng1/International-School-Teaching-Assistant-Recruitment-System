# 🚀 快速启动指南 - 登录模块

## ⚡ 5 分钟快速启动

### 1️⃣ 编译项目
```bash
mvn clean compile
```

### 2️⃣ 启动开发服务器
```bash
mvn jetty:run
```

### 3️⃣ 打开浏览器
访问：**http://localhost:8080/ta-recruitment-system/**

---

## 🧪 快速测试

### 测试账号速查表

| 角色 | 用户名 | 密码 | 跳转页面 |
|------|--------|------|---------|
| 教学助手 | `ta` | `123` | applicant/dashboard |
| 招聘主管 | `mo` | `123` | mo/dashboard |
| 系统管理员 | `admin` | `123` | admin/dashboard |

### 快速测试步骤
1. 点击首页的"立即登录"或"创建账户"按钮
2. 输入上表中的任一账号
3. 输入密码：`123`
4. 勾选"记住我"（可选）
5. 点击"登录"按钮
6. 验证是否跳转到对应的仪表板

---

## 📁 核心文件清单

### 新增文件
- `src/main/java/com/group50/tasystem/dao/UserDAO.java` - 用户数据访问层
- `src/main/java/com/group50/tasystem/controller/LogoutServlet.java` - 退出登录处理

### 修改文件
- `src/main/java/com/group50/tasystem/controller/LoginServlet.java` - 登录处理（完全重写）
- `src/main/webapp/login.jsp` - 登录页面（添加错误处理）

### 数据文件
- `data/users.json` - 用户数据（3 个测试账号）

---

## ✅ 功能验证

### 成功登录流程
```
输入账号密码
    ↓
客户端验证（至少 3 字符用户名，6 字符密码）
    ↓
提交到后端
    ↓
UserDAO 从 users.json 验证
    ↓
✅ 验证成功 → 创建 Session → 按角色跳转
❌ 验证失败 → 显示错误信息 → 保留用户名 → 留在登录页
```

### 功能检查清单
- ✅ 3 个测试账号可登录
- ✅ 不同角色跳转到不同页面
- ✅ 错误账号显示错误提示
- ✅ 登录失败保留用户名
- ✅ 支持"记住我"功能（7 天 Cookie）
- ✅ 支持退出登录（`/logout`）

---

## 🐛 常见问题

### Q: 提示"用户名或密码错误"
**A:** 检查 users.json 中的用户名和密码是否匹配。测试账号仅限：ta/123, mo/123, admin/123

### Q: 登录后显示 404
**A:** 确保 dashboard.jsp 文件存在于对应目录：
- TA 用户：`src/main/webapp/applicant/dashboard.jsp`
- MO 用户：`src/main/webapp/mo/dashboard.jsp`
- Admin 用户：`src/main/webapp/admin/dashboard.jsp`

### Q: 如何重新编译后立即测试？
**A:** 使用一个命令完成编译和启动：
```bash
mvn clean compile && mvn jetty:run
```

### Q: 如何生成部署用的 WAR 包？
**A:** 
```bash
mvn clean package
```
然后在 `target/` 目录中找到 `ta-recruitment-system.war`，复制到 Tomcat 的 `webapps` 目录即可

---

## 📞 关键 URL

- 登录页面：`http://localhost:8080/ta-recruitment-system/login.jsp`
- 首页：`http://localhost:8080/ta-recruitment-system/`
- 注册页面：`http://localhost:8080/ta-recruitment-system/register.jsp`
- 退出登录：`http://localhost:8080/ta-recruitment-system/logout`
- TA 仪表板：`http://localhost:8080/ta-recruitment-system/applicant/dashboard.jsp`
- MO 仪表板：`http://localhost:8080/ta-recruitment-system/mo/dashboard.jsp`
- Admin 仪表板：`http://localhost:8080/ta-recruitment-system/admin/dashboard.jsp`

---

## 🎯 下一步

1. 测试登录功能是否正常工作
2. 验证不同角色的角色跳转
3. 测试错误提示是否显示
4. 检查"记住我"功能是否工作
5. 测试退出登录功能

完成后，可以开始开发注册模块、工作管理等其他功能模块。

---

**Ready to test? 🧪 Click login and give it a try!**
