#!/bin/bash
#https://www.stgraber.org/2016/04/13/lxd-2-0-docker-in-lxd-712/
#apt-get -q -y -u update
#apt-get -q -y -u -V dist-upgrade
apt-get -q -y -u -V install docker.io
apt-get -q -y -u -V install emacs24-nox

docker run -it ubuntu


