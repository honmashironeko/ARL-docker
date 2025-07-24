#!/bin/bash
if [ "$EUID" -ne 0 ]; then
  echo "请使用 root 用户运行此脚本，或者使用 sudo 执行"
  exit 1
fi
# 简单介绍
echo "Docker 镜像作者：本间白猫"
echo "公众号：樱花庄的本间白猫"
echo "博客：https://y.shironekosan.cn" 
echo "Github：https://github.com/honmashironeko/ARL-docker"
echo "感谢您使用本脚本，请仔细阅读脚本内容，根据提示进行操作。"

echo -n "按回车键继续..."
read -n 1 -s
clear

# 换源及安装docker服务

echo "请选择是否需要更换 yum 或 apt 下载源："
echo "1) 不进行更换，使用默认下载源"
echo "2) 运行替换脚本，更换下载源"
read -p "请输入选项（1-2）[默认1]: " sz
sz=${sz:-1}

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

install_docker(){
    if command -v yum &> /dev/null; then
        echo "正在使用 yum 安装 Docker..."
        yum install -y docker
        setenforce 0
    elif command -v apt-get &> /dev/null; then
        apt-get update
        echo "正在使用 apt 安装 Docker.io..."
        apt-get install -y docker.io
    else
        echo "无法确定包管理器。请手动安装 Docker。"
        exit 1
    fi

    yum-docker(){
        config_file="/etc/docker/daemon.json"
        mkdir -p $(dirname $config_file)
        if [ ! -f "$config_file" ]; then
            echo "{}" > "$config_file"
        fi
        if [ -f "$config_file" ]; then
            mv "$config_file" "$config_file.bak"
        fi
        cat > "$config_file" <<EOF
{
    "registry-mirrors": [
        "hub.msqh.net",
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
}

    apt-docker() {
        config_file="/etc/apt/sources.list.d/docker.list"
        mkdir -p $(dirname $config_file)
        if [ -f "$config_file" ]; then
            mv "$config_file" "$config_file.bak"
        fi
        cat > "$config_file" <<EOF
deb [arch=amd64] https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/ubuntu $(lsb_release -cs) stable
EOF
}

    REGISTRY="https://index.docker.io"
    curl -s --head --request GET $REGISTRY | head -n 1 | grep "200" > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "成功连接到 $REGISTRY"
    else
        if command -v yum &> /dev/null; then
            echo "正在更换 Docker 源..."
            yum-docker
        elif command -v apt-get &> /dev/null; then
            echo "正在更换 Docker.io 源..."
            apt-docker
        else
            echo "无法确定包管理器。请手动更换 Docker 源。"
            exit 1
        fi
    fi


    systemctl daemon-reload
    systemctl restart docker

    echo "正在启动 Docker 服务..."
    if ! systemctl start docker; then
        echo "启动 Docker 服务失败。"
        echo "请手动检查 Docker 服务是否成功安装"
        exit 1
    fi
    echo "Docker 服务启动成功。"

    cp docker-compose /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
}

clear

if command -v docker &> /dev/null; then
    echo "已检测到 Docker 已安装。"
else
    echo "未检测到 Docker，将自动安装。"
    install_docker
fi

# 安装ARL
echo "开始部署"
docker volume create --name=arl_db
docker-compose up -d

read -p  "请确认是否添加指纹：[y/N]" yn
yn=${yn:-N}
case $yn in
    N)
        echo "无效的输入，不添加指纹。"
        ;;
    y)
        echo "检测 Python 和 pip 环境"

        has_python=false
        has_pip=false

        if command -v python3 &> /dev/null; then
            has_python=true
        else
            echo "未检测到 python3"
        fi

        if command -v pip3 &> /dev/null; then
            has_pip=true
        else
            echo "未检测到 pip3"
        fi

        if [ "$has_python" = false ] || [ "$has_pip" = false ]; then
            echo "安装 python3 和 pip3"

            if command -v yum &> /dev/null; then
                yum install -y python3 python3-pip
            elif command -v apt-get &> /dev/null; then
                apt-get update
                apt-get install -y python3 python3-pip
            else
                echo "无法确定包管理器。请手动安装 Python3 和 pip3。"
                exit 1
            fi
        else
            echo "Python3 和 pip3 已安装"
        fi

        # 安装 requests 包
        pip3 install --upgrade requests

        ;;
esac
echo "已完成ARL部署，感谢您的使用，如果对您有帮助，请给我们点个赞，谢谢！"
echo "Github：https://github.com/honmashironeko/ARL-docker"
echo "博客：https://y.shironekosan.cn" 
echo "公众号：樱花庄的本间白猫"
# 输出URL
CURRENT_IP=$(curl -s ipinfo.io/ip)
URL="https://${CURRENT_IP}:5003"
echo "ARL URL: $URL"
