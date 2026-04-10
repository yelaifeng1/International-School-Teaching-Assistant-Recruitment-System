#!/bin/bash

# ====================================
# TA Recruitment System - 状态查看脚本
# ====================================

PORT=8080
LOG_FILE="/tmp/ta-recruitment-server.log"
PID_FILE="/tmp/ta-recruitment-server.pid"

echo "========================================="
echo "  TA Recruitment System 状态"
echo "========================================="
echo ""

# 检查服务是否运行
if lsof -i :$PORT >/dev/null 2>&1; then
    echo "✅ 服务状态: 运行中"
    echo ""
    echo "📋 进程信息:"
    lsof -i :$PORT | grep LISTEN
    echo ""
    
    PID=$(lsof -t -i :$PORT)
    echo "🔍 进程ID: $PID"
    
    if [ -f "$PID_FILE" ]; then
        SAVED_PID=$(cat "$PID_FILE")
        echo "📄 保存的PID: $SAVED_PID"
    fi
    
    echo ""
    echo "🌐 访问地址:"
    echo "   主页: http://localhost:$PORT/ta-recruitment-system/"
    echo "   MO审核: http://localhost:$PORT/ta-recruitment-system/mo/review-applications"
    echo ""
    echo "📝 日志文件: $LOG_FILE"
    echo ""
    echo "💾 内存使用:"
    ps -p $PID -o pid,vsz,rss,pmem,comm | tail -1
    echo ""
    
    # 检查最近的日志
    if [ -f "$LOG_FILE" ]; then
        echo "📄 最近日志 (最后10行):"
        echo "-------------------------------------"
        tail -10 "$LOG_FILE"
    fi
else
    echo "❌ 服务状态: 未运行"
    echo ""
    echo "ℹ️  使用以下命令启动服务:"
    echo "   ./start-server.sh"
fi

echo ""
echo "========================================="
