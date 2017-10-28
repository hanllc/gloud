#!/bin/bash
#https://www.stgraber.org/2016/04/13/lxd-2-0-docker-in-lxd-712/
apt-get -q -y -u update
#apt-get -q -y -u -V dist-upgrade
apt-get -q -y -u -V install docker.io
#apt-get -q -y -u -V install emacs25-nox
apt-get -q -y -u -V install emacs24-nox

#docker run -it ubuntu:16.04
docker pull ubuntu:16.04


#docker pull odoo:9
#https://hub.docker.com/_/odoo/
#https://www.odoo.com/documentation/9.0/setup/install.html#setup-install-source
#http://www.tecmint.com/install-openerp-odoo-with-nginx-on-centos-and-debian/

#these go in a script/docker file
apt-get -q -y -u update
apt-get -q -y -u -V install git
#git clone https://github.com/odoo/odoo.git
git clone --depth 3 https://github.com/odoo/odoo.git

#from another process
docker commit 175193ae8074 woodo01

apt-get -q -y -u -V install python
apt-get -q -y -u -V install python-dev
apt-get -q -y -u -V install libpq-dev
apt-get -q -y -u -V install libxml2-dev
apt-get -q -y -u -V install libxslt-dev
#apt-get -q -y -u -V install python-ldap
apt-get -q -y -u -V install libldap2-dev
apt-get -q -y -u -V install libsasl2-dev
apt-get -q -y -u -V install libevent-dev
apt-get -q -y -u -V install python-pip
pip install --upgrade pip  
apt-get -q -y -u -V install python-psycopg2
cd /odoo
pip install -r requirements.txt

apt-get -q -y -u -V install nodejs
apt-get -q -y -u -V install nodejs-legacy
apt-get -q -y -u -V install npm
npm install -g less

#test postgres from another machine
apt-get -q -y -u -V install postgresql-client
apt-get -q -y -u -V  install inetutils-ping
apt-get -q -y -u -V  install traceroute


#odoo filestore issue - docker related
https://github.com/odoo/odoo/issues/9296

#new server used this process
http://www.tech-it.ma/en/2017/03/13/installation-odoo-10-sur-ubuntu-16-04-lts/
#python deps
apt-get install python-dateutil python-docutils python-feedparser python-jinja2 python-ldap python-libxslt1 python-lxml python-mako python-mock python-openid python-psycopg2 python-psutil python-pybabel python-pychart python-pydot python-pyparsing python-reportlab python-simplejson python-tz python-unittest2 python-vatnumber python-vobject python-webdav python-werkzeug python-xlwt python-yaml python-zsi poppler-utils python-pip python-pypdf python-passlib python-decorator gcc python-dev mc bzr python-setuptools python-markupsafe python-reportlab-accel python-zsi python-yaml python-argparse python-openssl python-egenix-mxdatetime python-usb python-serial lptools make python-pydot python-psutil python-paramiko poppler-utils python-pdftools antiword python-requests python-xlsxwriter python-suds python-psycogreen python-ofxparse python-gevent

#odoo deps
sudo apt-get install -y npm
sudo ln -s /usr/bin/nodejs /usr/bin/node
sudo npm install -g less less-plugin-clean-css

#deviated step here - test postgres from another machine
apt-get -q -y -u -V install postgresql-client
apt-get -q -y -u -V  install inetutils-ping
apt-get -q -y -u -V  install traceroute

#local user
adduser --system --home=/opt/odoo --group odoo

#gdata
sudo wget https://pypi.python.org/packages/a8/70/bd554151443fe9e89d9a934a7891aaffc63b9cb5c7d608972919a002c03c/gdata-2.0.18.tar.gz
sudo tar zxvf gdata-2.0.18.tar.gz
sudo chown -R odoo: gdata-2.0.18
sudo -s
cd gdata-2.0.18/
python setup.py install


git clone --depth=1 --branch=10.0 https://github.com/odoo/odoo.git /opt/odoo/odoo
sudo mv odoo/ odoo-10.0/ 
sudo chown -R odoo: odoo-10.0

sudo mkdir /var/log/odoo
sudo chown -R odoo:root /var/log/odoo

sudo cp /opt/odoo/odoo-10.0/debian/odoo.conf /etc/odoo.conf
sudo chown odoo: /etc/odoo.conf
sudo vim /etc/odoo.conf

#steps for Wkhtmltopdf 
https://www.linode.com/docs/websites/cms/install-odoo-10-on-ubuntu-16-04

#oddo 11 attempt in new docker container
git clone --branch 11.0 --depth 1 https://github.com/odoo/odoo.git /opt/odoo/odoo-11-0

#manual docker container preparation steps

#parts extracted from https://github.com/Yenthe666/InstallScript/blob/11.0/odoo_install.sh

echo -e "\n--- Installing Python 3 + pip3 --"
sudo apt-get install python3 python3-pip

echo -e "\n---- Install tool packages ----"
sudo apt-get install wget git bzr python-pip gdebi-core -y

echo -e "\n---- Install python packages ----"
sudo apt-get install python-pypdf2 python-dateutil python-feedparser python-ldap python-libxslt1 python-lxml python-mako python-openid python-psycopg2 python-pybabel python-pychart python-pydot python-pyparsing python-reportlab python-simplejson python-tz python-vatnumber python-vobject python-webdav python-werkzeug python-xlwt python-yaml python-zsi python-docutils python-psutil python-mock python-unittest2 python-jinja2 python-pypdf python-decorator python-requests python-passlib python-pil -y
sudo pip3 install pypdf2 Babel passlib Werkzeug decorator python-dateutil pyyaml psycopg2 psutil html2text docutils lxml pillow reportlab ninja2 requests gdata XlsxWriter vobject python-openid pyparsing pydot mock mako Jinja2 ebaysdk feedparser xlwt psycogreen suds-jurko pytz pyusb greenlet xlrd 

echo -e "\n---- Install python libraries ----"
# This is for compatibility with Ubuntu 16.04. Will work on 14.04, 15.04 and 16.04
sudo apt-get install python3-suds

echo -e "\n--- Install other required packages"
sudo apt-get install node-clean-css -y
sudo apt-get install node-less -y
sudo apt-get install python-gevent -y

#topdf
wget https://downloads.wkhtmltopdf.org/0.12/0.12.1/wkhtmltox-0.12.1_linux-trusty-amd64.deb

gdebi --n `basename https://downloads.wkhtmltopdf.org/0.12/0.12.1/wkhtmltox-0.12.1_linux-trusty-amd64.deb`

ln -s /usr/local/bin/wkhtmltopdf /usr/bin
ln -s /usr/local/bin/wkhtmltoimage /usr/bin

#previous container cmd python /opt/odoo/odoo-10.0/odoo-bin --proxy-mode --xmlrpc-port=8069 --db_user xsdodoo --db_host 192.168.198.15
#don't forget to secure https://brokeravm.com/web/database/manager

adduser --system --home=/opt/odoo --group odoo
sudo chown -R odoo:odoo /opt/odoo
mkdir /var/log/odoo
chown -R odoo:odoo /var/log/odoo
mkdir /opt/odoo/odoo-11-0/custom
mkdir /opt/odoo/odoo-11-0/custom/addons
chown -R odoo:odoo /opt/odoo/odoo-11-0/custom

mkdir /etc/odoo
printf '[options]\n' >> /etc/odoo/brokeravm.conf
printf 'admin_passwd = FOD\n' >> /etc/odoo/brokeravm.conf
printf 'xmlrpc_port = 8069\n' >> /etc/odoo/brokeravm.conf
printf 'logfile = /var/log/odoo\n' >> /etc/odoo/brokeravm.conf
printf 'addons_path = /opt/odoo/odoo-11-0/addons,/opt/odoo/odoo-11-0/custom/addons\n' >> /etc/odoo/brokeravm.conf

chown -R odoo:odoo /etc/odoo

#added steps here for postgres from another machine
apt-get -q -y -u -V install postgresql-client
apt-get -q -y -u -V  install inetutils-ping
apt-get -q -y -u -V  install traceroute

adduser --system --quiet --shell=/bin/bash --home=$OE_HOME --gecos 'ODOO' --group $OE_USER

adduser --system --quiet --shell=/bin/bash --home=/opt/odoo --gecos 'ODOO' --group odoo

#from postgres server
# su - postgres -c "createuser -s xsdodoo11"

#datadrive resize required
#https://serverfault.com/questions/703471/why-isnt-my-zfs-pool-expanding-using-zfs-on-linux
#still had to reboot and partprobe and expand after to get it see it

#test exec from docker
#runs good 
docker exec -it -u odoo 8187a4dabe7d  /opt/odoo/odoo-11-0/odoo-bin --proxy-mode --config /etc/odoo/brokeravm.conf --db_user xsdodoo11 --db_host 192.168.198.15

#errors
docker run -it -u odoo -p 8070:8069 --entrypoint="/bin/bash" xodoo11:000

#never returns
docker run -it -p 8070:8069 xodoo11:000 /bin/bash

#then restart and do this to shell in
docker start -i -a 4ca8b0e40356 

#another run attempt - works and opens a shell and emacs ie term works!
docker run -a STDIN -a STDOUT -a STDERR -it -p 8070:8069 xodoo11:000 /bin/bash

#after running exec odoo[s]
docker exec -it -u odoo 9ab2c24c2c98 /opt/odoo/odoo-11-0/odoo-bin --proxy-mode --config /etc/odoo/brokeravm.conf --db_user xsdodoo11 --db_host 192.168.198.15
#still requires a chmod 755 / to run as odoo user

#run detached
docker exec --detach -u odoo 9ab2c24c2c98 /opt/odoo/odoo-11-0/odoo-bin --proxy-mode --config /etc/odoo/brokeravm.conf --db_user xsdodoo11 --db_host 192.168.198.15

#nre launch url
#https://www.brokeravm.com/web/database/selector
