# ARL(灯塔）-docker版

本项目基于ARL v2.6.2版本源码，制作成docker镜像进行快速部署，并提供三种指纹规格的镜像。

1.  arl-docker-initial：ARL初始版本，仅去除域名限制。

2.  arl-docker-portion：ARL部分指纹版本，去除域名限制，并增加 <span style="color: #333333;">5232 条</span>指纹。

3.  arl-docker-all：ARL完全指纹版本，去除域名限制，全量 <span style="color: #333333;">6990 条</span>指纹。

# 使用教程

## 一键部署脚本：

下载部署脚本项目：`git clone https://github.com/honmashironeko/ARL-docker.git`

进入项目文件夹：`cd ARL-docker/`

添加运行权限： `chmod +x setup_docker.sh`

执行部署脚本：`bash setup_docker.sh`

![图片](./assets/640.webp)

输入数字确认安装版本：1 or 2 or 3

前往ARLweb页面：`https://IP:5003/`

![图片](./assets/640-1716266394547-1.webp)

`账号：admin，密码：honmashironeko`

## 手动安装步骤：

<span style="color: rgba(0, 0, 0, 0.9);">此处请注意，根据您希望安装的 docker 镜像进行选择，“honmashironeko/” 后面应当跟着"arl-docker-initial、arl-docker-portion、arl-docker-all"其中一个。</span>

&nbsp;

安装docker：`yum -y install docker`

启动docker服务：`systemctl start docker`

拉取docker镜像：`docker pull honmashironeko/arl-docker-initial`

运行docker容器：`docker run -d -p 5003:5003 --name arl --privileged=true honmashironeko/arl-docker-initial /usr/sbin/init`

前往ARLweb页面：`https:*//IP:5003/*`

`账号：admin，密码：honmashironeko`

# 特别鸣谢

感谢ARL项目：https://github.com/TophantTechnology/ARL

感谢ARL项目备份：https://github.com/Aabyss-Team/ARL

感谢部分指纹提供：https://github.com/loecho-sec/ARL-Finger-ADD

感谢全量指纹提供：https://blog.zgsec.cn/

# 源码安装

根据ARL官方V2.6.2版本源码，修复部分bug之后制作完成的源码安装脚本

下载部署脚本项目：`git clone https:*//github.com/honmashironeko/ARL-docker.git*`

进入项目文件夹：`cd ARL-docker/`

添加运行权限：`chmod +x setup-arl.sh`

执行部署脚本：`bash setup-arl.sh`

可能会在运行的时候报错一次，不需要管他，重新运行一遍 bash setup-arl.sh 即可。

# 文件配置

您需要先进入容器中再进行操作，方法如下

进入容器命令：`docker exec -it 镜像名称 /bin/bash`

进入配置文件目录：`cd /opt/ARL/app`

编辑配置文件：`vi config.yaml`

进入ARL控制文件目录：`cd /opt/ARL/misc`

增加运行权限：`chmod +x manage.sh`

重启ARL相关服务：`./manage.sh restart`

