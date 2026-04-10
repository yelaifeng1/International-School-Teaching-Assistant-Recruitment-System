#!/bin/bash

# ====================================
# TA Recruitment System - 启动脚本
# ====================================

PROJECT_DIR="/Users/jiangruyue01/Desktop/wjx/International-School-Teaching-Assistant-Recruitment-System"
MAVEN_HOME="/Users/jiangruyue01/Desktop/wjx/apache-maven-3.9.6"
LOG_FILE="/tmp/ta-recruitment-server.log"
PORT=8080

echo "========================================="
echo "  TA Recruitment System 启动脚本"
echo "========================================="
echo ""

# 检查端口是否被占用
if lsof -i :$PORT >/dev/null 2>&1; then
    echo "⚠️  端口 $PORT 已被占用"
    echo ""
    echo "当前占用进程："
    lsof -i :$PORT | grep LISTEN
    echo ""
    read -p "是否停止现有服务并重启？(y/n): " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "正在停止现有服务..."
        PID=$(lsof -t -i :$PORT)
        kill $PID
        sleep 3
        echo "✅ 现有服务已停止"
    else
        echo "❌ 取消启动"
        exit 1
    fi
fi

# 进入项目目录
cd "$PROJECT_DIR" || exit 1

echo ""
echo "📦 正在编译项目..."
$MAVEN_HOME/bin/mvn clean package -DskipTests -q

if [ $? -ne 0 ]; then
    echo "❌ 编译失败，请检查错误信息"
    exit 1
fi

echo "✅ 编译成功"
echo ""
echo "🚀 正在启动服务器..."
echo "   日志文件: $LOG_FILE"
echo ""

# 后台启动服务器
$MAVEN_HOME/bin/mvn cargo:run > "$LOG_FILE" 2>&1 &
SERVER_PID=$!

echo "   进程ID: $SERVER_PID"
echo ""
echo "⏳ 等待服务器启动（约15秒）..."

# 等待服务器启动
sleep 15

# 检查服务器是否成功启动
if lsof -i :$PORT >/dev/null 2>&1; then
    echo ""
    echo "========================================="
    echo "✅ 服务器启动成功！"
    echo "========================================="
    echo ""
    echo "📌 访问地址："
    echo "   主页: http://localhost:$PORT/ta-recruitment-system/"
    echo "   MO审核页面: http://localhost:$PORT/ta-recruitment-system/mo/review-applications"
    echo ""
    echo "🔐 登录信息："
    echo "   MO账户: mo / password123"
    echo ""
    echo "📝 查看日志："
    echo "   tail -f $LOG_FILE"
    echo ""
    echo "🛑 停止服务器："
    echo "   kill $SERVER_PID"
    echo "   或运行: ./stop-server.sh"
    echo ""
    echo "========================================="
    
    # 保存PID到文件
    echo $SERVER_PID > /tmp/ta-recruitment-server.pid
else
    echo ""
    echo "❌ 服务器启动失败"
    echo ""
    echo "查看日志获取详细信息："
    echo "   tail -50 $LOG_FILE"
    exit 1
fi
