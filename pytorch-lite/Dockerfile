# syntax=docker/dockerfile:1

# 使用 PyTorch runtime 镜像
ARG BASE_IMAGE
FROM ${BASE_IMAGE}

# 设置构建参数
ARG USERNAME
ARG USER_UID
ARG USER_GID
ARG WORKSPACE=/workspace

# 设置环境变量
ENV TZ=Asia/Shanghai \
    DEBIAN_FRONTEND=noninteractive

# 配置 apt 源为国内镜像源，并安装必要的软件包
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
    libgl1-mesa-glx \
    libglib2.0-0 && \
    # 配置中文语言环境
    locale-gen zh_CN.UTF-8 && \
    update-locale LANG=zh_CN.UTF-8 LANGUAGE=zh_CN:zh LC_ALL=zh_CN.UTF-8 && \
    # 设置时区
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
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
    sed -i 's/#Port 22/Port 22/' /etc/ssh/sshd_config && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# 配置conda环境
RUN ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> /etc/bash.bashrc && \
    echo "conda activate base" >> /etc/bash.bashrc && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> /root/.bashrc && \
    echo "conda activate base" >> /root/.bashrc

# 切换 pip 源为国内镜像源并安装依赖
COPY requirements.txt /tmp/
RUN pip config set global.index-url https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple && \
    pip config set install.trusted-host mirrors.tuna.tsinghua.edu.cn && \
    pip install --no-cache-dir -r /tmp/requirements.txt --timeout 7200

# 设置工作目录并创建必要的目录
WORKDIR ${WORKSPACE}
RUN mkdir -p ${WORKSPACE} && \
    chown ${USER_UID}:${USER_GID} ${WORKSPACE}

# 复制启动脚本
COPY --chown=${USERNAME}:${USERNAME} startup.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/startup.sh

# 暴露必要的端口
EXPOSE 22 8888 6006

# 切换到非 root 用户
USER ${USERNAME}

# 设置容器启动命令
ENTRYPOINT ["/usr/local/bin/startup.sh"]
