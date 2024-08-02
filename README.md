# 给孩子点点 Star 吧，求求了，其他项目也可以看看，点点 Star ~

# ARL(灯塔）-docker版

本项目基于渊龙团队备份：[ARL](https://github.com/Aabyss-Team/ARL) v2.6.2版本源码，制作成docker镜像进行快速部署，并提供两种指纹规格的镜像。

1.  arl-docker-initial：ARL初始版本，仅去除域名限制。

2.  arl-docker-all：ARL完全指纹版本，去除域名限制，全量 7165 条指纹。
  
3.  请注意，添加指纹的工具借用的是 ARL-Finger-ADD ，但指纹不是哦，由多处获取，经过格式转换、指纹去重后保留下来的一批指纹，原指纹量达到6w+但其实重复极多。

# 使用教程

## 一键部署脚本：

更换Yum源方法：将本项目中的mian.sh文件内容复制粘贴到您的系统中，并bash mian.sh运行，按照提示操作
下载部署脚本项目：`git clone https://github.com/honmashironeko/ARL-docker.git`

进入项目文件夹：`cd ARL-docker/`

添加运行权限： `chmod +x setup_docker.sh`

执行部署脚本：`bash setup_docker.sh`

![Clip_2024-07-31_18-21-38](https://github.com/user-attachments/assets/53a11bbb-599c-453c-b302-45d4c63dcfb8)

![Clip_2024-07-31_19-07-42](https://github.com/user-attachments/assets/597ec41e-fd92-4cb8-adef-17dfcc4ccc2e)


根据脚本提示进行操作

前往ARLweb页面：`https://IP:5003/`

`账号：admin，密码：honmashironeko`

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

重启ARL相关服务：`bash manage.sh restart`

如果您要重启 docker 容器，或重启系统，请先运行`bash /opt/ARL/misc/manage.sh stop`
