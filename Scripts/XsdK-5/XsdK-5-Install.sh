#!/bin/bash
apt-get -q -y -u update
#apt-get -q -y -u -V dist-upgrade

apt-get -q -y -u -V install emacs24-nox
apt-get -q -y -u -V install nginx

apt-get -q -y -u -V install gcc
apt-get -q -y -u -V install g++

apt-get -q -y -u -V install libfcgi-dev
apt-get -q -y -u -V install liblmdb-dev
apt-get -q -y -u -V install spawn-fcgi

apt-get -q -y -y -V install swi-prolog-nox

apt-get -q -y -y -V install r-base r-base-dev

wget https://bruda.ca/_media/emacs/prolog.el

git clone https://github.com/hanllc/appsrv.git

#database location
mkdir /root/mydb

#eventually download datalog microjson (unused) minijson (about to use)
#http://chriswu.me/blog/writing-hello-world-in-fcgi-with-c-plus-plus/

ln -s /root/appsrv/etc/nginx/sites-available/brokeravm.com /etc/nginx/sites-available/brokeravm.com
ln -s /etc/nginx/sites-available/brokeravm.com /etc/nginx/sites-enabled/brokeravm.com

chmod 775 /root
chmod 775 /root/appsrv
chmod -R 775 /root/appsrv/ecma


