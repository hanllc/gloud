#!/bin/bash
#apt-get -q -y -u update
apt-get -q -y -u -V install nginx

mkdir -p /pdata/web/xsdlive.com
mkdir /pdata/web/brokeravm.com
mkdir /pdata/web/wehrli.org
chown -R www-data:www-data /pdata/web/xsdlive.com
chown -R www-data:www-data /pdata/web/brokeravm.com
chown -R www-data:www-data /pdata/web/wehrli.org
chmod 755 /pdata/web

curl -o /root/brokeravm.com.asc https://raw.githubusercontent.com/hanllc/gcloud/master/Scripts/XsdK-1/brokeravm.com.asc
gpg --allow-secret-key-import --import /root/instance-config-key.asc
gpg --output brokeravm.com --decrypt brokeravm.com.asc

cp brokeravm.com /etc/nginx/sites-available/brokeravm.com
ln -s /etc/nginx/sites-available/brokeravm.com /etc/nginx/sites-enabled/brokeravm.com


mv /etc/nginx/sites-enabled/default /root

service nginx restart