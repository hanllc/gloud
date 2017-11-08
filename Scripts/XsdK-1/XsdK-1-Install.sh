#!/bin/bash -x
#apt-get -q -y -u update
apt-get -q -y -u -V install nginx

#appears to exist already on gcp
#mkdir ~/.ssh
#chmod 700 ~/.ssh

#initial setup; now stored in source control 
#ssh-keygen -t rsa -b 4096 -N "" -f "/root/.ssh/key4x" -q
curl -o /root/.ssh/key4x.pub https://raw.githubusercontent.com/hanllc/gloud/master/Scripts/key4x.pub
cat /root/.ssh/key4x.pub >> /root/.ssh/authorized_keys

mkdir -p /pdata/web/xsdlive.com
mkdir /pdata/web/brokeravm.com
mkdir /pdata/web/wehrli.org
chown -R www-data:www-data /pdata/web/xsdlive.com
chown -R www-data:www-data /pdata/web/brokeravm.com
chown -R www-data:www-data /pdata/web/wehrli.org
chmod 755 /pdata/web

cd /pdata/web/
git clone https://github.com/hanllc/mrk.brokeravm.com.git brokeravm.com

mkdir -p /etc/nginx/ssl/brokeravm.com
mkdir -p /etc/nginx/ssl/wehrli.org
mkdir -p /etc/nginx/ssl/xsdlive.com

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

#NOTE USED NEW LETSENCRYPT cytpobot
# https://certbot.eff.org/#ubuntuxenial-nginx

apt-get install software-properties-common
add-apt-repository ppa:certbot/certbot
apt-get update
apt-get install python-certbot-nginx

## this runs it
sudo certbot --nginx certonly

#move new certs files into nginx reqd locations
cp /etc/letsencrypt/live/brokeravm.com/privkey.pem /etc/nginx/ssl/brokeravm.com/server.key
cp /etc/letsencrypt/live/brokeravm.com/fullchain.pem /etc/nginx/ssl/brokeravm.com/server.crt

#hack till new certs
cp /etc/letsencrypt/live/wehrli.org/privkey.pem /etc/nginx/ssl/wehrli.org/server.key
cp /etc/letsencrypt/live/wehrli.org/fullchain.pem /etc/nginx/ssl/wehrli.org/server.crt

cp /etc/letsencrypt/live/xsdlive.com/privkey.pem /etc/nginx/ssl/xsdlive.com/server.key
cp /etc/letsencrypt/live/xsdlive.com/fullchain.pem /etc/nginx/ssl/xsdlive.com/server.crt


#config
curl -o /root/brokeravm.com.asc https://raw.githubusercontent.com/hanllc/gloud/master/Scripts/XsdK-1/brokeravm.com.asc
gpg --allow-secret-key-import --import /root/instance-config-key.asc
gpg --output brokeravm.com --decrypt brokeravm.com.asc
cp brokeravm.com /etc/nginx/sites-available/brokeravm.com

#need other site setups placed in git encrypted

ln -s /etc/nginx/sites-available/brokeravm.com /etc/nginx/sites-enabled/brokeravm.com
ln -s /etc/nginx/sites-available/wehrli.org /etc/nginx/sites-enabled/wehrli.org
ln -s /etc/nginx/sites-available/xsdlive.com /etc/nginx/sites-enabled/xsdlive.com

mv /etc/nginx/sites-enabled/default /root

service nginx restart
#systemctl status nginx.service
