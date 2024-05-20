# ARL(灯塔）-docker版
本项目基于ARL v2.6.2版本源码，制作成docker镜像进行快速部署，到手即用。
# 使用教程
1、安装docker：yum -y install docker
2、启动docker服务：systemctl start docker
3、拉取docker镜像：docker pull honmashironeko/arl-docker
4、运行docker容器：docker run -d -p 5003:5003 --name arl --privileged=true honmashironeko/arl-docker /usr/sbin/init
5、前往ARLweb页面：https://IP:5003/
6、账号：admin，密码：arlpass
