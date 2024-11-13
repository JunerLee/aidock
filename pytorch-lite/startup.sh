#!/bin/bash
set -e

# 启动 SSH 服务
sudo service ssh start

# 启动 JupyterLab
echo "启动 JupyterLab..."
jupyter lab \
    --ip=0.0.0.0 \
    --port=${PYTORCH_LITE_JUPYTER_PORT} \
    --NotebookApp.token=${JUPYTER_TOKEN} \
    --notebook-dir=${WORKSPACE} \
    --allow-root \
    --no-browser
