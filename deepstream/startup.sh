#!/bin/bash
set -e

# 启动 SSH 服务
sudo service ssh start

# 创建运行时目录
sudo mkdir -p /tmp/runtime-root
sudo chmod 700 /tmp/runtime-root
sudo chown ${USER}:${USER} /tmp/runtime-root

# 显示环境信息
echo "环境信息："
echo "DISPLAY=$DISPLAY"
echo "XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR"
echo "NVIDIA_VISIBLE_DEVICES=$NVIDIA_VISIBLE_DEVICES"
echo "NVIDIA_DRIVER_CAPABILITIES=$NVIDIA_DRIVER_CAPABILITIES"

# 保持容器运行
tail -f /dev/null
