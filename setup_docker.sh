#!/bin/bash

# 显示作者信息
echo "docker镜像作者：本间白猫"
echo "公众号：樱花庄的本间白猫"
echo "博客：https://y.shironekosan.cn"

# 安装Docker
echo "正在安装Docker..."
yum -y install docker

# 启动Docker服务
echo "正在启动Docker服务..."
systemctl start docker

# 拉取Docker镜像
echo "正在拉取Docker镜像..."
docker pull honmashironeko/arl-docker

# 运行Docker容器
echo "正在运行Docker容器..."
docker run -d -p 5003:5003 --name arl --privileged=true honmashironeko/arl-docker /usr/sbin/init

