# ARL(灯塔）-docker版
本项目基于ARL v2.6.2版本源码，制作成docker镜像进行快速部署，到手即用。
# 使用教程
## 一键部署脚本：
1、下载部署脚本项目：git clone https://github.com/honmashironeko/ARL-docker.git

2、进入项目文件夹：cd ARL-docker/

3、添加运行权限：chmod +x setup_docker.sh

4、执行部署脚本：bash setup_docker.sh
![Clip_2024-05-21_11-18-05](https://github.com/honmashironeko/ARL-docker/assets/139044047/84b17c4d-7005-4d61-81b0-b91e4d5e6df4)
![Clip_2024-05-21_11-20-02](https://github.com/honmashironeko/ARL-docker/assets/139044047/93a72b17-7535-4db6-94ac-6beed92fead0)


## 手动安装步骤：
此处请注意，根据您希望安装的 docker 镜像进行选择，“honmashironeko/” 后面应当跟着"arl-docker-initial、arl-docker-portion、arl-docker-all"其中一个
  
1、安装docker：yum -y install docker

2、启动docker服务：systemctl start docker

3、拉取docker镜像：docker pull honmashironeko/arl-docker-initial

4、运行docker容器：docker run -d -p 5003:5003 --name arl --privileged=true honmashironeko/arl-docker-initial /usr/sbin/init         

5、前往ARLweb页面：https://IP:5003/

6、账号：admin，密码：honmashironeko

![image](https://github.com/honmashironeko/ARL-docker/assets/139044047/46504320-97b4-44e3-aa06-ba121cb33cd6)
## 特别鸣谢
感谢ARL项目备份：https://github.com/Aabyss-Team/ARL

感谢部分指纹提供：https://github.com/loecho-sec/ARL-Finger-ADD

感谢全量指纹提供：曾哥
