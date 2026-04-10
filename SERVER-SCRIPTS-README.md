# TA Recruitment System - 服务器管理脚本

## 📋 脚本列表

| 脚本文件 | 功能 | 说明 |
|---------|------|------|
| `start-server.sh` | 启动服务器 | 自动编译并启动，检测端口占用 |
| `stop-server.sh` | 停止服务器 | 安全停止运行中的服务 |
| `restart-server.sh` | 重启服务器 | 先停止再启动 |
| `status-server.sh` | 查看状态 | 显示服务器运行状态和日志 |

---

## 🚀 使用方法

### 启动服务器

```bash
cd /Users/jiangruyue01/Desktop/wjx/International-School-Teaching-Assistant-Recruitment-System
./start-server.sh
```

**功能**:
- ✅ 自动检测端口占用
- ✅ 自动编译项目
- ✅ 后台启动服务器
- ✅ 显示访问地址和登录信息

---

### 停止服务器

```bash
./stop-server.sh
```

**功能**:
- ✅ 安全停止服务器进程
- ✅ 自动清理PID文件
- ✅ 失败时尝试强制终止

---

### 重启服务器

```bash
./restart-server.sh
```

**功能**:
- ✅ 自动停止现有服务
- ✅ 重新编译并启动
- ✅ 适合代码修改后重启

---

### 查看服务器状态

```bash
./status-server.sh
```

**功能**:
- ✅ 显示服务运行状态
- ✅ 显示进程信息和内存使用
- ✅ 显示最近日志（最后10行）
- ✅ 显示访问地址

---

## 📝 日志文件

**日志位置**: `/tmp/ta-recruitment-server.log`

**查看实时日志**:
```bash
tail -f /tmp/ta-recruitment-server.log
```

---

## 🌐 访问地址

启动成功后，可以访问：

- **主页**: http://localhost:8080/ta-recruitment-system/
- **MO审核页面**: http://localhost:8080/ta-recruitment-system/mo/review-applications

---

## 🔐 登录信息

### MO账户
- 用户名: `mo`
- 密码: `password123`

### 备用MO账户
- 用户名: `test04`
- 密码: `test041234`

---

## 🛠️ 故障排查

### 问题1: 端口被占用

**解决方法**:
```bash
# 查看占用端口的进程
lsof -i :8080

# 手动终止进程
kill <PID>

# 或使用停止脚本
./stop-server.sh
```

---

### 问题2: 编译失败

**解决方法**:
```bash
# 手动清理并编译
/Users/jiangruyue01/Desktop/wjx/apache-maven-3.9.6/bin/mvn clean install

# 查看详细错误
/Users/jiangruyue01/Desktop/wjx/apache-maven-3.9.6/bin/mvn clean package
```

---

### 问题3: 服务器无法访问

**检查步骤**:
1. 查看服务器状态
   ```bash
   ./status-server.sh
   ```

2. 查看日志
   ```bash
   tail -50 /tmp/ta-recruitment-server.log
   ```

3. 重启服务器
   ```bash
   ./restart-server.sh
   ```

---

## 📦 手动启动（不使用脚本）

如果脚本无法使用，可以手动启动：

```bash
# 1. 进入项目目录
cd /Users/jiangruyue01/Desktop/wjx/International-School-Teaching-Assistant-Recruitment-System

# 2. 编译项目
/Users/jiangruyue01/Desktop/wjx/apache-maven-3.9.6/bin/mvn clean package -DskipTests

# 3. 启动服务器（前台运行）
/Users/jiangruyue01/Desktop/wjx/apache-maven-3.9.6/bin/mvn cargo:run

# 或后台运行
/Users/jiangruyue01/Desktop/wjx/apache-maven-3.9.6/bin/mvn cargo:run > /tmp/server.log 2>&1 &
```

---

## 📌 注意事项

1. **数据持久化**: 重启服务器会重新部署WAR包，运行时修改的JSON数据会丢失
2. **端口冲突**: 确保8080端口没有被其他应用占用
3. **Java版本**: 需要Java 17或更高版本
4. **内存要求**: 建议至少512MB可用内存

---

## 📞 技术支持

如有问题，请查看：
- 项目文档: `/Users/jiangruyue01/Desktop/wjx/EBU6304_GroupProjectHandout.pdf`
- 服务器日志: `/tmp/ta-recruitment-server.log`
