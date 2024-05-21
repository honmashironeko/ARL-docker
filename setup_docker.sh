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
echo "2) arl-docker-portion：ARL部分指纹版本，去除域名限制，并增加5232条指纹。"
echo "3) arl-docker-all：ARL完全指纹版本，去除域名限制，全量七千余指纹。"
read -p "请输入选项（1-3）：" version_choice

case $version_choice in
    1)
        docker_image="honmashironeko/arl-docker-initial"
        ;;
    2)
        docker_image="honmashironeko/arl-docker-portion"
        ;;
    3)
        docker_image="honmashironeko/arl-docker-all"
        ;;
    *)
        echo "无效的输入，脚本将退出。"
        exit 1
        ;;
esac

echo "正在拉取 Docker 镜像：$docker_image..."
docker pull $docker_image

echo "正在运行 Docker 容器..."
docker run -d -p 5003:5003 --name arl --privileged=true $docker_image /usr/sbin/init
