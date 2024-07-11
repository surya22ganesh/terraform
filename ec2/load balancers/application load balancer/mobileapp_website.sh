#! /bin/bash
sudo -i
yum update -y
yum install unzip -y
yum install httpd -y
service httpd start
cd /opt/
chmod 777 .
wget https://www.free-css.com/assets/files/free-css-templates/download/page293/fitapp.zip
unzip fitapp.zip
cd mobile-app-html-template
mv * /var/www/html/

 
 