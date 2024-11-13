#!/bin/bash
set -e

# 启动 SSH 服务
sudo service ssh start

# 保持容器运行
tail -f /dev/null
