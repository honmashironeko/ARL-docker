# ARL(灯塔）-docker版

本项目基于ARL v2.6.2版本源码，制作成docker镜像进行快速部署，并提供三种指纹规格的镜像。

1.  arl-docker-initial：ARL初始版本，仅去除域名限制。

2.  arl-docker-all：ARL完全指纹版本，去除域名限制，全量 7165 条指纹。

**请注意，当前适配全部系统（如有问题，请联系我）**

# 使用教程

## 一键部署脚本：

下载部署脚本项目：`git clone https://github.com/honmashironeko/ARL-docker.git`

进入项目文件夹：`cd ARL-docker/`

添加运行权限： `chmod +x setup_docker.sh`

执行部署脚本：`bash setup_docker.sh`

Centos以外的版本请注意，脚本采用的是yum安装工具，如果是apt的话请运行：`apt install docker.io -y`

![Clip_2024-05-29_15-38-52](https://github.com/honmashironeko/ARL-docker/assets/139044047/ad96b024-194c-4711-8d4c-0079e535341a)


输入数字确认安装版本：1 or 2

在安装完成之后进入容器：`docker exec -it arl /bin/bash`

开始完成ARL部署：`bash /root/arl/set.sh`

前往ARLweb页面：`https://IP:5003/`

`账号：admin，密码：honmashironeko`

## 手动安装步骤：

此处请注意，根据您希望安装的 docker 镜像进行选择，“honmashironeko/” 后面应当跟着"arl-docker-initial、arl-docker-all"其中一个。

安装docker：`yum -y install docker`

其他系统安装：`apt install docker.io -y`

启动docker服务：`systemctl start docker`

拉取docker镜像：`docker pull honmashironeko/arl-docker-initial`

运行docker容器：`docker run -d -p 5003:5003 --name arl --privileged=true honmashironeko/arl-docker-initial /usr/sbin/init`

在安装完成之后进入容器：`docker exec -it arl /bin/bash`

开始完成ARL部署：`bash /root/arl/set.sh`

前往ARLweb页面：`https://IP:5003/`

`账号：admin，密码：honmashironeko`

![image](https://github.com/honmashironeko/ARL-docker/assets/139044047/8cd0408b-880b-4772-821d-932c7f1a948f)


# 特别鸣谢

感谢ARL项目：https://github.com/TophantTechnology/ARL

感谢ARL项目备份：https://github.com/Aabyss-Team/ARL

感谢部分指纹提供：https://blog.zgsec.cn/

# 源码安装

根据ARL官方V2.6.2版本源码，修复部分bug之后制作完成的源码安装脚本

## 本地环境安装法

下载项目压缩包：

Github：https://github.com/honmashironeko/icpscan/releases

夸克网盘：https://pan.quark.cn/s/39b4b5674570#/list/share

百度网盘：https://pan.baidu.com/s/1C9LVC9aiaQeYFSj_2mWH1w?pwd=13r5

移动压缩包：`mv arl-initial.tar /root`

解压文件：`tar -xvf arl-initial.tar`

执行部署脚本：`bash /root/arl/set.sh`

## 在线下载安装法

下载部署脚本项目：`git clone https://github.com/honmashironeko/ARL-docker.git`

进入项目文件夹：`cd ARL-docker/`

添加运行权限：`chmod +x setup-arl.sh`

执行部署脚本：`bash setup-arl.sh`

可能会在运行的时候报错一次，不需要管他，重新运行一遍 bash setup-arl.sh 即可。

# 基本配置

如果需要配置 KEY 等内容，或控制 ARL 开启和关闭，可以采用以下方法

您需要先进入容器中再进行操作，方法如下

进入容器命令：`docker exec -it 镜像名称 /bin/bash`

进入配置文件目录：`cd /opt/ARL/app`

编辑配置文件：`vi config.yaml`

进入ARL控制文件目录：`cd /opt/ARL/misc`

增加运行权限：`chmod +x manage.sh`

重启ARL相关服务：`./manage.sh restart`
