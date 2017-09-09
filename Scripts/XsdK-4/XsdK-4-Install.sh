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

