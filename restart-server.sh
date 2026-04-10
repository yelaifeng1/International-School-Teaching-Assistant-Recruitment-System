#!/bin/bash

# ====================================
# TA Recruitment System - 重启脚本
# ====================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "========================================="
echo "  TA Recruitment System 重启脚本"
echo "========================================="
echo ""

# 停止服务
if [ -f "$SCRIPT_DIR/stop-server.sh" ]; then
    echo "步骤 1/2: 停止现有服务"
    echo "-------------------------------------"
    bash "$SCRIPT_DIR/stop-server.sh"
    echo ""
fi

# 启动服务
if [ -f "$SCRIPT_DIR/start-server.sh" ]; then
    echo "步骤 2/2: 启动服务"
    echo "-------------------------------------"
    bash "$SCRIPT_DIR/start-server.sh"
else
    echo "❌ 找不到启动脚本"
    exit 1
fi
