#!/bin/bash
#https://www.stgraber.org/2016/04/13/lxd-2-0-docker-in-lxd-712/
apt-get -q -y -u update
#apt-get -q -y -u -V dist-upgrade
apt-get -q -y -u -V install docker.io
#apt-get -q -y -u -V install emacs24-nox
apt-get -q -y -u -V install emacs25-nox

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



