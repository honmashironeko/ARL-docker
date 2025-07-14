#!/bin/bash

echo "Docker 镜像作者：本间白猫"
echo "❗️ 本脚本完全基于 <Docker 镜像作者：本间白猫> 的 setup_docker.sh 适配macOS"
echo "🎉 欢迎使用 ARL Mac 快速部署脚本 by lixiasky & 本间白猫"
echo "🌐 项目地址：https://github.com/honmashironeko/ARL-docker"
echo ""

echo "🌐 国内用户建议提前安装并配置 ClashX 或其他代理工具，确保网络畅通。"
read -p "已安装并配置好代理节点？[Y/n]: " proxy_confirm
proxy_confirm=${proxy_confirm:-Y}

if [[ "$proxy_confirm" != "Y" && "$proxy_confirm" != "y" ]]; then
  echo "🔧 自动设置 http_proxy 环境变量为 http://127.0.0.1:7890"
  export http_proxy=http://127.0.0.1:7890
  export https_proxy=http://127.0.0.1:7890
  echo "如需自定义端口，请手动修改 http_proxy/https_proxy 环境变量。"
else
  echo "✅ 已配置好代理，继续执行..."
fi

# 提醒用户已经准备好了 Docker（由 OrbStack 或 Docker Desktop 提供）
echo "✅ 请确保你已正确安装 Docker，并在运行状态"
docker -v || { echo "❌ 未检测到 Docker，请先安装 Docker 后再运行本脚本"; exit 1; }

echo ""
read -p "是否继续部署 ARL？[Y/n]: " confirm
confirm=${confirm:-Y}

if [[ "$confirm" != "Y" && "$confirm" != "y" ]]; then
  echo "🚫 已取消部署。"
  exit 0
fi

echo "📦 开始创建数据库卷..."
docker volume create --name=arl_db

echo "🚀 启动 ARL 容器..."
docker-compose up -d || {
  echo "❌ Docker Compose 启动失败，请检查是否安装 docker-compose 工具"
  exit 1
}

echo ""
read -p "是否添加指纹测试数据？[Y/n]: " addfinger
addfinger=${addfinger:-Y}

if [[ "$addfinger" == "Y" || "$addfinger" == "y" ]]; then
  echo "🐍 检测 Python3 安装状态..."
  if ! command -v python3 >/dev/null 2>&1; then
    echo "❌ 未检测到 Python3，请先安装 Python3"
    exit 1
  fi

  echo "📦 正在安装 requests 库（如已安装会跳过）..."
  pip3 install requests --user

  echo "⏳ 检查 ARL 服务是否已启动..."
  for i in {1..10}; do
    if curl -s http://localhost:5003 >/dev/null; then
      echo "✅ ARL 服务已启动，准备添加指纹"
      break
    else
      echo "等待 ARL 服务启动中...($i/10)"
      sleep 10
    fi
    if [ $i -eq 10 ]; then
      echo "❌ ARL 服务启动超时，无法添加指纹"
      exit 1
    fi
  done

  echo "📥 运行指纹添加脚本..."
  python3 ARL-Finger-ADD.py https://127.0.0.1:5003/ admin honmashironeko
else
  echo "🚫 跳过指纹添加"
fi

echo ""
echo "🎉 ARL 部署完成，请访问："
echo "🔗 http://localhost:5003"
echo "🔐 默认账号：admin / honmashironeko"
echo ""
echo "✨ 感谢你的使用，记得 Star 一下原项目支持作者鸭~"
echo "🔗 原作者信息:"
echo "已完成ARL部署，感谢您的使用，如果对您有帮助，请给我们点个赞，谢谢！"
echo "Github：https://github.com/honmashironeko/ARL-docker"
echo "博客：https://y.shironekosan.cn" 
echo "公众号：樱花庄的本间白猫"
