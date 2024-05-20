# ARL(灯塔）-docker版
本项目基于ARL v2.6.2版本源码，制作成docker镜像进行快速部署，到手即用。
# 使用教程
## 一键部署脚本：
1、下载部署脚本项目：git clone https://github.com/honmashironeko/ARL-docker.git

2、进入项目文件夹：cd ARL-docker/

3、添加运行权限：chmod +x setup_docker.sh

4、执行部署脚本：bash setup_docker.sh

## 手动安装步骤：
1、安装docker：yum -y install docker

2、启动docker服务：systemctl start docker

3、拉取docker镜像：docker pull honmashironeko/arl-docker

4、运行docker容器：docker run -d -p 5003:5003 --name arl --privileged=true honmashironeko/arl-docker /usr/sbin/init

5、前往ARLweb页面：https://IP:5003/

6、账号：admin，密码：arlpass

![image](https://github.com/honmashironeko/ARL-docker/assets/139044047/46504320-97b4-44e3-aa06-ba121cb33cd6)
