set -e

echo "cd /opt/"

mkdir -p /opt/
cd /opt/

echo "安装依赖项 ..."
yum localinstall -y /root/arl/yum/*.rpm

if [ ! -f /usr/bin/python3.6 ]; then
  echo "链接 python3.6"
  ln -s /usr/bin/python36 /usr/bin/python3.6
fi

if [ ! -f /usr/local/bin/pip3.6 ]; then
  echo "安装  pip3.6"
  python3.6 -m ensurepip --default-pip
  python3.6 -m pip install --upgrade pip
  pip3.6 --version
fi

if ! command -v nmap &> /dev/null
then
    echo "安装 nmap-7.93-1 ..."
    rpm -vhU /root/arl/misc/nmap-7.93-1.x86_64.rpm
fi


if ! command -v nuclei &> /dev/null
then
  echo "安装 nuclei_3.2.4 ..."
  cp /root/arl/misc/nuclei_3.2.4_linux_amd64.zip /opt
  unzip nuclei_3.2.4_linux_amd64.zip && mv nuclei /usr/bin/ && rm -f nuclei_3.2.4_linux_amd64.zip
  nuclei -ut
fi


if ! command -v wih &> /dev/null
then
  echo "安装 wih ..."
  ## 安装 WIH
  cp /root/arl/misc/wih_linux_amd64 /usr/bin/wih && chmod +x /usr/bin/wih
  wih --version
fi


echo "启动服务 ..."
systemctl enable mongod
systemctl start mongod
systemctl enable rabbitmq-server
systemctl start rabbitmq-server


if [ ! -d ARL ]; then
  echo "复制 ARL 项目"
  cp -r /root/arl/misc/ARL /opt
fi

if [ ! -d "ARL-NPoC" ]; then
  echo "复制 ARL-NPoC 项目"
  cp -r /root/arl/misc/ARL-NPoC /opt
fi

cd ARL-NPoC
echo "安装 poc 必须库 ..."
pip3.6 install -r requirements.txt
pip3.6 install -e .
cd ../

if [ ! -f /usr/local/bin/ncrack ]; then
  echo "复制 ncrack ..."
  cp /root/arl/misc/ncrack /usr/local/bin/ncrack
  chmod +x /usr/local/bin/ncrack
fi

mkdir -p /usr/local/share/ncrack
if [ ! -f /usr/local/share/ncrack/ncrack-services ]; then
  echo "复制 ncrack-services ..."
  cp /root/arl/misc/ncrack-services /usr/local/share/ncrack/ncrack-services
fi

mkdir -p /data/GeoLite2
if [ ! -f /data/GeoLite2/GeoLite2-ASN.mmdb ]; then
  echo "复制 GeoLite2-ASN.mmdb ..."
  cp /root/arl/misc/GeoLite2-ASN.mmdb /data/GeoLite2/
fi

if [ ! -f /data/GeoLite2/GeoLite2-City.mmdb ]; then
  echo "复制 GeoLite2-City.mmdb ..."
  cp /root/arl/misc/GeoLite2-City.mmdb /data/GeoLite2/
fi

cd ARL

if [ ! -f rabbitmq_user ]; then
  echo "添加 rabbitmq 用户"
  rabbitmqctl add_user arl arlpassword
  rabbitmqctl add_vhost arlv2host
  rabbitmqctl set_user_tags arl arltag
  rabbitmqctl set_permissions -p arlv2host arl ".*" ".*" ".*"
  echo "初始化 arl 用户"
  mongo 127.0.0.1:27017/arl docker/mongo-init.js
  touch rabbitmq_user
fi

echo "安装 arl 必须库 ..."
pip3.6 install -r requirements.txt
if [ ! -f app/config.yaml ]; then
  echo "create config.yaml"
  cp app/config.yaml.example  app/config.yaml
fi

if [ ! -f /usr/bin/phantomjs ]; then
  echo "安装 phantomjs"
  ln -s `pwd`/app/tools/phantomjs  /usr/bin/phantomjs
fi

if [ ! -f /etc/nginx/conf.d/arl.conf ]; then
  echo "复制 arl.conf"
  cp misc/arl.conf /etc/nginx/conf.d
fi



if [ ! -f /etc/ssl/certs/dhparam.pem ]; then
  echo "download dhparam.pem"
  cp /root/arl/misc/dhparam.pem /etc/ssl/certs/dhparam.pem
fi


echo "gen cert ..."
chmod +x ./docker/worker/gen_crt.sh
./docker/worker/gen_crt.sh


cd /opt/ARL/

chmod +x /opt/ARL/app/tools/massdns

if [ ! -f /etc/systemd/system/arl-web.service ]; then
  echo  "copy arl-web.service"
  cp misc/arl-web.service /etc/systemd/system/
fi

if [ ! -f /etc/systemd/system/arl-worker.service ]; then
  echo  "copy arl-worker.service"
  cp misc/arl-worker.service /etc/systemd/system/
fi


if [ ! -f /etc/systemd/system/arl-worker-github.service ]; then
  echo  "copy arl-worker-github.service"
  cp misc/arl-worker-github.service /etc/systemd/system/
fi

if [ ! -f /etc/systemd/system/arl-scheduler.service ]; then
  echo  "copy arl-scheduler.service"
  cp misc/arl-scheduler.service /etc/systemd/system/
fi

echo "start arl services ..."
systemctl enable arl-web
systemctl start arl-web
systemctl enable arl-worker
systemctl start arl-worker
systemctl enable arl-worker-github
systemctl start arl-worker-github
systemctl enable arl-scheduler
systemctl start arl-scheduler
systemctl enable nginx
systemctl start nginx

systemctl status arl-web
systemctl status arl-worker
systemctl status arl-worker-github
systemctl status arl-scheduler

echo "install done"
