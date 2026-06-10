#!/bin/bash
# 企业背调小程序 - 一键启动脚本

echo "=========================================="
echo "  企业背调小程序 - 启动中..."
echo "=========================================="

# 获取脚本所在目录
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# 启动后端服务
echo "[1/2] 启动后端API服务 (端口: 3000)..."
cd "$SCRIPT_DIR/server"
node server.js &
SERVER_PID=$!
echo "  后端PID: $SERVER_PID"

# 等待后端启动
sleep 1

# 启动前端HTTP服务
echo "[2/2] 启动前端HTTP服务 (端口: 8080)..."
cd "$SCRIPT_DIR"
python3 -m http.server 8080 &
FRONT_PID=$!
echo "  前端PID: $FRONT_PID"

echo ""
echo "=========================================="
echo "  启动完成!"
echo "  前端地址: http://localhost:8080"
echo "  后端API:  http://localhost:3000"
echo "=========================================="
echo ""
echo "按 Ctrl+C 停止所有服务"

# 捕获退出信号，清理子进程
trap "kill $SERVER_PID $FRONT_PID 2>/dev/null; echo '服务已停止'; exit" SIGINT SIGTERM

# 等待
wait
