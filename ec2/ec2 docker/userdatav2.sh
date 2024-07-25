#!/bin/bash
sudo -i
cd /root
chmod 777 .
apt-get update -y
apt-get install docker.io -y
mv /home/ubuntu/* .
cd docker
docker build -t nginximage .
docker run -dit --name nginxcontainer1 -p 1122:80 nginximage
