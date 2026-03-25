# Tomcat 部署指南

## 项目信息
- **项目名称**: 教学助手招聘系统 (International School Teaching Assistant Recruitment System)
- **项目类型**: Maven Web 应用 (WAR)
- **打包方式**: Apache Tomcat

## 编译项目

执行以下命令编译项目并生成 WAR 包：

```bash
mvn clean package
```

编译完成后，WAR 文件位置：
```
target/ta-recruitment-system.war
```

## 在 Apache Tomcat 中部署

### 方案 1: 自动部署（复制 WAR 文件）

1. **下载并安装 Apache Tomcat**
   - 下载 Tomcat 9.x 或 Tomcat 10.x 版本
   - 下载地址: https://tomcat.apache.org/download-90.cgi

2. **部署 WAR 文件**
   - 将编译生成的 `target/ta-recruitment-system.war` 文件复制到 Tomcat 安装目录下的 `webapps` 文件夹
   - 例如: `C:\tomcat\webapps\ta-recruitment-system.war`

3. **启动 Tomcat**
   - Windows: 双击 `bin\startup.bat`
   - Linux/Mac: 执行 `bin/startup.sh`

4. **访问应用**
   - 打开浏览器访问: http://localhost:8080/ta-recruitment-system/

### 方案 2: 手动部署（解压 WAR 文件）

1. 创建应用目录: `webapps/ta-recruitment-system/`

2. 解压 WAR 文件到该目录：
   ```bash
   unzip target/ta-recruitment-system.war -d webapps/ta-recruitment-system/
   ```

3. 启动 Tomcat

4. 访问应用: http://localhost:8080/ta-recruitment-system/

## 快速开发运行

如果仅用于开发，可以使用 Maven Jetty 插件快速启动：

```bash
mvn jetty:run
```

然后访问: http://localhost:8080/ta-recruitment-system/

## 项目配置

### pom.xml 关键配置
- **Java 版本**: 17
- **Web 容器**: Tomcat 9.x+ / Jetty 11.x+
- **打包格式**: WAR (Web Application Archive)
- **字符编码**: UTF-8

### 项目依赖
- Servlet API 4.0.1
- JSP API 2.3.3
- JSTL 1.2
- Gson 2.10.1 (JSON 处理)
- JUnit 5.10.2 (单元测试)

## 系统要求

- Java Development Kit (JDK) 17 或以上
- Apache Maven 3.6 或以上
- Apache Tomcat 9.x 或以上

## 常见问题

### Q: 部署后提示 404 错误？
A: 检查以下几点：
1. WAR 文件是否正确复制到 `webapps` 文件夹
2. Tomcat 是否成功启动（查看 `logs/catalina.out` 或 `logs/catalina.log`）
3. 访问 URL 是否正确: `http://localhost:8080/ta-recruitment-system/`

### Q: JSP 页面无法正常显示？
A: 确保：
1. 使用 Tomcat 9.x 或以上版本
2. Java 版本不低于 17
3. 清除浏览器缓存并进行硬刷新 (Ctrl+Shift+Delete)

### Q: 如何修改 Tomcat 端口？
A: 编辑 Tomcat 的 `conf/server.xml` 文件，找到以下行并修改端口号：
```xml
<Connector port="8080" protocol="HTTP/1.1" .../>
```

## 优化建议

1. **内存配置**（可选）
   - 编辑 `bin/catalina.sh` (Linux/Mac) 或 `bin/catalina.bat` (Windows)
   - 添加 JVM 参数：`JAVA_OPTS="-Xms512m -Xmx1024m"`

2. **日志配置**
   - Tomcat 日志位置: `logs/catalina.out`
   - 应用日志可以在此查看错误信息

## 生成新 WAR 包

如果修改了代码，需要重新生成 WAR 包：

```bash
mvn clean package
```

然后将新的 WAR 文件复制到 Tomcat 的 `webapps` 文件夹，Tomcat 会自动检测并重新部署。

---

**项目已满足使用 Apache Tomcat 的要求！** ✅
