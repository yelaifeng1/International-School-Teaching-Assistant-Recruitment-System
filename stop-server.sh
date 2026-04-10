#!/bin/bash

# ====================================
# TA Recruitment System - 停止脚本
# ====================================

PORT=8080
PID_FILE="/tmp/ta-recruitment-server.pid"

echo "========================================="
echo "  TA Recruitment System 停止脚本"
echo "========================================="
echo ""

# 检查是否有服务在运行
if ! lsof -i :$PORT >/dev/null 2>&1; then
    echo "ℹ️  端口 $PORT 上没有运行的服务"
    
    # 清理PID文件
    if [ -f "$PID_FILE" ]; then
        rm "$PID_FILE"
        echo "✅ 已清理PID文件"
    fi
    
    exit 0
fi

echo "📋 当前运行的服务："
lsof -i :$PORT | grep LISTEN
echo ""

# 尝试从PID文件读取
if [ -f "$PID_FILE" ]; then
    PID=$(cat "$PID_FILE")
    echo "🔍 从PID文件读取到进程ID: $PID"
else
    # 从lsof获取PID
    PID=$(lsof -t -i :$PORT)
    echo "🔍 从端口获取到进程ID: $PID"
fi

if [ -z "$PID" ]; then
    echo "❌ 无法获取进程ID"
    exit 1
fi

echo ""
read -p "确认停止服务？(y/n): " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "🛑 正在停止服务..."
    kill $PID
    
    # 等待进程结束
    sleep 3
    
    # 检查是否成功停止
    if lsof -i :$PORT >/dev/null 2>&1; then
        echo "⚠️  进程未能正常停止，尝试强制终止..."
        kill -9 $PID
        sleep 2
    fi
    
    # 最终检查
    if lsof -i :$PORT >/dev/null 2>&1; then
        echo "❌ 服务停止失败"
        exit 1
    else
        echo "✅ 服务已成功停止"
        
        # 清理PID文件
        if [ -f "$PID_FILE" ]; then
            rm "$PID_FILE"
        fi
    fi
else
    echo "❌ 取消操作"
fi
