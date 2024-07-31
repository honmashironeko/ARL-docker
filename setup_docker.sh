systemctl start docker
docker build -t arl -f Dockerfile .
docker run -d --name arl --privileged -p 5003:5003 honmashironeko/arl-docker-all
echo "部署完成"


#!/bin/bash

# 简单介绍
echo "Docker 镜像作者：本间白猫"
echo "公众号：樱花庄的本间白猫"
echo "博客：https://y.shironekosan.cn" 

echo -n "按任意键继续..."
read -n 1 -s
clear

# 换源及安装docker服务
bash main.sh

if command -v yum &> /dev/null; then
    echo "正在使用 yum 安装 Docker..."
    yum install -y docker
elif command -v apt-get &> /dev/null; then
    echo "正在使用 apt 安装 Docker.io..."
    apt-get update && apt-get install -y docker.io
else
    echo "无法确定包管理器。请手动安装 Docker。"
    exit 1
fi

echo "正在启动 Docker 服务..."
systemctl start docker

# 安装ARL
echo "请选择要安装的版本："
echo "1) arl-docker-initial：ARL初始版本，仅去除域名限制。"
echo "2) arl-docker-all：ARL完全指纹版本，去除域名限制，全量 7165 条指纹。"
read -p "请输入选项（1-2）：" version_choice

DOCKERFILE_ALL_PATH="docker-all/Dockerfile"
DOCKERFILE_INITIAL_PATH="docker-initial/Dockerfile"
case $version_choice in
    1)
        echo "正在拉取 Docker 镜像：arl-docker-initial..."
        docker build -t arl -f "DOCKERFILE_INITIAL_PATH" .
        echo "正在运行 Docker 容器..."
        docker run -d --name arl --privileged -p 5003:5003 honmashironeko/arl-docker-initial
        ;;
    2)
        echo "正在拉取 Docker 镜像：arl-docker-all..."
        docker build -t arl -f "DOCKERFILE_ALL_PATH" .
        echo "正在运行 Docker 容器..."
        docker run -d --name arl --privileged -p 5003:5003 honmashironeko/arl-docker-all
        ;;
    *)
        echo "无效的输入，脚本将退出。"
        exit 1
        ;;
esac

echo "部署完成"

# 输出URL
CURRENT_IP=$(hostname -I | awk '{print \$1}')
URL="https://${CURRENT_IP}:5003"
echo $URL