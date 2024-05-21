#!/bin/bash

echo "Docker 镜像作者：本间白猫"
echo "公众号：樱花庄的本间白猫"
echo "博客：https://y.shironekosan.cn" 

echo "正在安装 Docker ..."
yum -y install docker

echo "正在启动 Docker 服务..."
systemctl start docker

echo "请选择要安装的版本："
echo "1) arl-docker-initial：ARL初始版本，仅去除域名限制。"
echo "2) arl-docker-portion：ARL部分指纹版本，去除域名限制，并增加 5232 条指纹。"
echo "3) arl-docker-all：ARL完全指纹版本，去除域名限制，全量 6990 条指纹。"
read -p "请输入选项（1-3）：" version_choice

case $version_choice in
    1)
        echo "正在拉取 Docker 镜像：arl-docker-initial..."
        docker pull honmashironeko/arl-docker-initial
        echo "正在运行 Docker 容器..."
        docker run -d -p 5003:5003 --name arl --privileged=true honmashironeko/arl-docker-initial /usr/sbin/init
        ;;
    2)
        echo "正在拉取 Docker 镜像：arl-docker-portion..."
        docker pull honmashironeko/arl-docker-portion
        echo "正在运行 Docker 容器..."
        docker run -d -p 5003:5003 --name arl --privileged=true honmashironeko/arl-docker-portion /usr/sbin/init
        ;;
    3)
        echo "正在拉取 Docker 镜像：arl-docker-all..."
        docker pull honmashironeko/arl-docker-all
        echo "正在运行 Docker 容器..."
        docker run -d -p 5003:5003 --name arl --privileged=true honmashironeko/arl-docker-all /usr/sbin/init
        ;;
    *)
        echo "无效的输入，脚本将退出。"
        exit 1
        ;;
esac

