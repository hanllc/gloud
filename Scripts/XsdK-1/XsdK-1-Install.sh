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

mkdir -p /etc/nginx/ssl/brokeravm.com
# ssl_certificate     /etc/nginx/ssl/brokeravm.com/server.crt;
# ssl_certificate_key /etc/nginx/ssl/brokeravm.com/server.key;
# openssl req -newkey rsa:2048 -keyout brokeravm.key -out brokeravm.csr
# http://nginx.org/en/docs/http/configuring_https_servers.html#chains
# http://serverfault.com/questions/259302/best-location-for-ssl-certificate-and-private-keys-on-ubuntu
# http://www.westphahl.net/blog/2012/01/03/setting-up-https-with-nginx-and-startssl/
curl -o /root/brokeravm.com.crt https://raw.githubusercontent.com/hanllc/gloud/master/Scripts/XsdK-1/1_brokeravm.com_bundle.crt
cp brokeravm.com.crt /etc/nginx/ssl/brokeravm.com/server.crt
#open key - injected here
cp brokeravm-key.asc /etc/nginx/ssl/brokeravm.com/server.key
#steps for encrypted key
#cp brokeravm-key.asc /etc/nginx/ssl/brokeravm.com/server-secure.key
#openssl rsa -in /etc/nginx/ssl/brokeravm.com/server-secure.key -out /etc/nginx/ssl/brokeravm.com/server.key

curl -o /root/brokeravm.com.asc https://raw.githubusercontent.com/hanllc/gloud/master/Scripts/XsdK-1/brokeravm.com.asc
gpg --allow-secret-key-import --import /root/instance-config-key.asc
gpg --output brokeravm.com --decrypt brokeravm.com.asc
cp brokeravm.com /etc/nginx/sites-available/brokeravm.com
ln -s /etc/nginx/sites-available/brokeravm.com /etc/nginx/sites-enabled/brokeravm.com


mv /etc/nginx/sites-enabled/default /root

service nginx restart
#systemctl status nginx.service
