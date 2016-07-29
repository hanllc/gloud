#!/bin/bash
#apt-get -q -y -u update
sudo apt-get -q -y -u -V install emacs24-nox

apt-get install postgresql-9.5
sudo su - postgres -c "createuser -s $USER"
