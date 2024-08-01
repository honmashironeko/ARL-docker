#!/bin/bash

# 简单介绍
echo "Docker 镜像作者：本间白猫"
echo "公众号：樱花庄的本间白猫"
echo "博客：https://y.shironekosan.cn" 
echo "Github：https://github.com/honmashironeko/ARL-docker"
echo "感谢您使用本脚本，请仔细阅读脚本内容，根据提示进行操作。"

echo -n "按任意键继续..."
read -n 1 -s
clear

# 换源及安装docker服务

echo "请选择是否需要更换 yum 或 apt 下载源："
echo "1) 不进行更换，使用默认下载源"
echo "2) 运行替换脚本，更换下载源"
read -p "请输入选项（1-2）：" sz

case $sz in
    1)
        echo "不进行更换，使用默认下载源"
        ;;
    2)
        bash main.sh
        ;;
    *)
        echo "无效的输入，脚本将退出。"
        exit 1
        ;;
esac

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

# 创建配置文件
config_file="/etc/docker/daemon.json"
if [ -f "$config_file" ]; then
    mv "$config_file" "$config_file.bak"
fi
cat > "$config_file" <<EOF
{
  "registry-mirrors":
   [
        "https://docker.1panel.live",
        "https://yxzrazem.mirror.aliyuncs.com",
        "http://hub-mirror.c.163.com",
        "https://registry.docker-cn.com",
        "https://docker.mirrors.sjtug.sjtu.edu.cn",
        "https://docker.m.daocloud.io",
        "https://docker.itelyou.cf",
        "https://noohub.ru",
        "https://docker.fxxk.dedyn.io",
        "https://huecker.io",
        "https://dockerhub.timeweb.cloud",
        "https://registry.cn-hangzhou.aliyuncs.com"
   ]
}
EOF
systemctl daemon-reload
systemctl restart docker

echo "正在启动 Docker 服务..."
if ! systemctl start docker; then
    echo "启动 Docker 服务失败。"
    echo "请手动检查 Docker 服务是否成功安装"
    exit 1
fi
echo "Docker 服务启动成功。"

# 安装ARL
echo "请选择要安装的版本："
echo "1) arl-docker-initial：ARL初始版本，仅去除域名限制。"
echo "2) arl-docker-all：ARL完全指纹版本，去除域名限制，全量 7165 条指纹。"
read -p "请输入选项（1-2）：" version_choice

case $version_choice in
    1)
        echo "正在拉取 Docker 镜像：arl-docker-initial..."
        docker build -t arl -f docker-initial/Dockerfile .
        echo "正在运行 Docker 容器..."
        docker run -d --name arl --privileged -p 5003:5003 arl
        ;;
    2)
        echo "正在拉取 Docker 镜像：arl-docker-all..."
        docker build -t arl -f docker-all/Dockerfile .
        echo "正在运行 Docker 容器..."
        docker run -d --name arl --privileged -p 5003:5003 arl
        ;;
    *)
        echo "无效的输入，脚本将退出。"
        exit 1
        ;;
esac

echo "已完成ARL部署，感谢您的使用，如果对您有帮助，请给我们点个赞，谢谢！"
echo "Github：https://github.com/honmashironeko/ARL-docker"

# 输出URL
CURRENT_IP=$(curl ipinfo.io/ip)
URL="https://${CURRENT_IP}:5003"
echo $URL