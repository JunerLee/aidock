# 使用 NVIDIA DeepStream 基础镜像
ARG DEEPSTREAM_VERSION=7.1
FROM nvcr.io/nvidia/deepstream:${DEEPSTREAM_VERSION}-gc-triton-devel

# 设置构建参数
ARG USERNAME
ARG USER_UID
ARG USER_GID

# 设置环境变量
ENV TZ=Asia/Shanghai \
    DEBIAN_FRONTEND=noninteractive \
    NVIDIA_DRIVER_CAPABILITIES=all \
    # DeepStream 特定配置
    RTSP_PORT=8554 \
    GST_DEBUG=2

# 配置apt源为国内镜像并安装必要的软件包
RUN cp /etc/apt/sources.list /etc/apt/sources.list.bak && \
    sed -i 's|http://archive.ubuntu.com|http://mirrors.aliyun.com|g' /etc/apt/sources.list && \
    sed -i 's|http://security.ubuntu.com|http://mirrors.aliyun.com|g' /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
    openssh-server \
    sudo \
    vim \
    wget \
    git \
    curl \
    locales \
    language-pack-zh-hans \
    ffmpeg \
    gstreamer1.0-libav \
    gstreamer1.0-plugins-good \
    gstreamer1.0-plugins-bad \
    gstreamer1.0-plugins-ugly && \
    # 配置中文语言环境
    locale-gen zh_CN.UTF-8 && \
    update-locale LANG=zh_CN.UTF-8 LANGUAGE=zh_CN:zh LC_ALL=zh_CN.UTF-8 && \
    # 设置时区
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
    # 运行 DeepStream 附加安装脚本
    /opt/nvidia/deepstream/deepstream/user_additional_install.sh && \
    # 清理apt缓存
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 设置语言环境变量
ENV LANG=zh_CN.UTF-8 \
    LANGUAGE=zh_CN:zh \
    LC_ALL=zh_CN.UTF-8

# 创建与宿主机用户一致的非 root 用户
RUN groupadd -g ${USER_GID} ${USERNAME} && \
    useradd -m -u ${USER_UID} -g ${USER_GID} ${USERNAME} && \
    usermod -aG sudo ${USERNAME} && \
    echo "${USERNAME}:${USERNAME}" | chpasswd && \
    echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# 配置 SSH 服务
RUN mkdir /var/run/sshd && \
    sed -i "s/#Port 22/Port 22/" /etc/ssh/sshd_config && \
    sed -i "s/#PermitRootLogin prohibit-password/PermitRootLogin no/" /etc/ssh/sshd_config && \
    sed -i "s/#PasswordAuthentication yes/PasswordAuthentication yes/" /etc/ssh/sshd_config

# 设置工作目录并创建必要的目录
WORKDIR /workspace
RUN mkdir -p /workspace && \
    chown ${USER_UID}:${USER_GID} /workspace

# 复制启动脚本
COPY --chown=${USERNAME}:${USERNAME} startup.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/startup.sh

# 暴露端口
EXPOSE 22 8554

# 切换到非 root 用户
USER ${USERNAME}

# 设置容器启动命令
ENTRYPOINT ["/usr/local/bin/startup.sh"]
