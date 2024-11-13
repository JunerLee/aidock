# AI Docker 开发环境

基于 Docker 的 AI 开发环境集成方案，支持 PyTorch、DeepStream 和 C++ 开发，提供了完整的 GPU 支持和 X11 显示功能。

## 主要特性

- 🖥️ 完整的图形界面支持（Windows WSL2 和 Linux）
- 🔄 支持多版本共存（基于版本号区分容器）
- 🚀 预配置 JupyterLab（支持中文）
- 🔒 SSH 远程访问
- 📦 国内镜像加速
- 🌏 完整中文支持
- 🎯 NVIDIA GPU 支持
- 📂 灵活的目录映射

## 快速开始

### 1. 环境准备

1. 安装必要软件：
   - Docker 和 Docker Compose
   - NVIDIA Container Toolkit
   - X11 服务器（Windows 需要 VcXsrv）

2. 配置环境：
   ```bash
   cp .env.example .env
   # 编辑 .env 文件，设置必要的配置
   ```

### 2. 启动服务

```bash
# 启动所有服务
docker-compose up -d

# 启动单个服务
docker-compose up -d pytorch        # 启动完整版 PyTorch
docker-compose up -d pytorch-lite   # 启动轻量版 PyTorch
```

## 环境说明

### PyTorch 环境（完整版）

基于 NVIDIA NGC 容器的完整深度学习环境。

- 基础镜像：`nvcr.io/nvidia/pytorch`
- 功能特点：
  * 完整的 CUDA 开发环境
  * 预装深度学习工具
  * JupyterLab 支持
  * YOLOv8 等模型支持
- 端口配置：
  * SSH: ${PYTORCH_SSH_PORT}（默认 2222）
  * JupyterLab: ${PYTORCH_JUPYTER_PORT}（默认 8888）

### PyTorch Lite 环境（轻量版）

基于 PyTorch 官方 runtime 镜像的轻量级环境。

- 基础镜像：`pytorch/pytorch` (runtime 版本)
- 功能特点：
  * 更小的镜像体积
  * 专注于模型推理
  * JupyterLab 支持
  * YOLOv8 等模型支持
- 端口配置：
  * SSH: ${PYTORCH_SSH_LITE_PORT}（默认 2225）
  * JupyterLab: ${PYTORCH_JUPYTER_LITE_PORT}（默认 8889）

### DeepStream 环境

NVIDIA DeepStream 视频分析环境。

- 功能特点：
  * 实时视频分析
  * RTSP 流支持
  * GStreamer 支持
- 端口配置：
  * SSH: ${DEEPSTREAM_SSH_PORT}（默认 2224）
  * RTSP: ${RTSP_PORT}（默认 8554）

### C++ 环境

C++ 开发基础环境。

- 基于 Ubuntu
- 预装开发工具
- SSH 端口：${CPP_SSH_PORT}（默认 2223）

## 目录映射说明

### 基础映射（必需）

```bash
# 代码目录
CODE_HOST=./workspace   # 宿主机路径
CODE_CONTAINER=/workspace   # 容器内路径

# 数据目录
DATA_HOST=./data       # 宿主机路径
DATA_CONTAINER=/data   # 容器内路径
```

### 添加自定义映射

如需添加其他目录映射，只需在 `.env` 文件中添加新的映射配置：

```bash
# 示例：添加模型目录映射
MODELS_HOST=./models
MODELS_CONTAINER=/models

# 示例：添加输出目录映射
OUTPUT_HOST=./output
OUTPUT_CONTAINER=/output
```

## 版本管理

### PyTorch 完整版
- 环境变量：`NGC_PYTORCH_VERSION`
- 容器名：`pytorch_${NGC_PYTORCH_VERSION}`
- 版本示例：
  * 24.01-py3
  * 23.12-py3

### PyTorch 轻量版
- 环境变量：`PYTORCH_LITE_VERSION`
- 容器名：`pytorch_lite_${PYTORCH_LITE_VERSION}`
- 版本示例：
  * 2.1.2-cuda12.1-cudnn8-runtime
  * 2.1.1-cuda12.1-cudnn8-runtime

### DeepStream
- 环境变量：`DEEPSTREAM_VERSION`
- 容器名：`deepstream_${DEEPSTREAM_VERSION}`
- 当前版本：7.1

### C++
- 环境变量：`CPP_VERSION`
- 容器名：`cpp_${CPP_VERSION}`
- 基于 Ubuntu 版本：22.04

## 图形界面配置

### Windows WSL2 环境

1. 安装 VcXsrv：
   - 下载：https://sourceforge.net/projects/vcxsrv/
   - 配置：
     * Display number: 0
     * Multiple windows
     * Start no client
     * 勾选 "Disable access control"

2. 配置防火墙：
   - 允许 VcXsrv (vcxsrv.exe) 的入站规则
   - 允许公网和私网访问

### Linux 环境

```bash
# 允许本地 X11 连接
xhost +local:

# 或允许所有连接（仅用于开发环境）
xhost +
```

## 常见问题

### 1. 图形界面问题

Windows 环境：
- 确保 VcXsrv 运行中
- 检查防火墙设置
- 确认 DISPLAY 环境变量

Linux 环境：
- 执行 `xhost +` 允许连接
- 检查 /tmp/.X11-unix 挂载

### 2. GPU 相关问题

- 确认 NVIDIA 驱动安装
- 检查 NVIDIA Container Toolkit
- 运行 `nvidia-smi` 验证

### 3. 网络问题

- 检查端口占用
- 确认防火墙设置
- 验证 host.docker.internal 解析

## 开发建议

### 1. 环境选择

- 开发和训练：使用 PyTorch 完整版
- 推理部署：使用 PyTorch 轻量版
- 视频处理：使用 DeepStream
- 底层开发：使用 C++ 环境

### 2. 性能优化

- 合理分配 GPU 资源
- 使用 volume 挂载优化 I/O
- 配置国内镜像源

### 3. 安全建议

- 生产环境限制 X11 访问
- 使用强密码
- 定期更新基础镜像

## 注意事项

1. `.env` 文件包含敏感信息，已添加到 `.gitignore`
2. 代码目录和数据目录为必需映射
3. 可以根据需要在 `.env` 中添加其他目录映射
4. 确保端口号不与其他服务冲突
5. 定期备份重要数据
