#!/bin/bash -x
#apt-get -q -y -u update

sudo apt-get -q -y -u -V install emacs24-nox
apt-get install postgresql-9.5
#sudo su - postgres -c "createuser -s $USER"
sudo su - postgres -c "createuser -s xsdodoo"

#https://www.postgresql.org/docs/9.5/static/app-psql.html
#https://help.ubuntu.com/lts/serverguide/postgresql.html
#https://www.digitalocean.com/community/tutorials/how-to-use-roles-and-manage-grant-permissions-in-postgresql-on-a-vps--2
#enable remote access to postgres
# host       DATABASE  USER  ADDRESS  METHOD  [OPTIONS]
echo "#wehrli bot adds" >> /etc/postgresql/9.5/main/pg_hba.conf 
echo "host         all       all   192.168.198.0/24 trust" >> /etc/postgresql/9.5/main/pg_hba.conf
echo "#" >> /etc/postgresql/9.5/main/pg_hba.conf
echo "#wehrli bot adds" >> /etc/postgresql/9.5/main/postgresql.conf
echo "listen_addresses = '*'" >> /etc/postgresql/9.5/main/postgresql.conf
echo "#" >> /etc/postgresql/9.5/main/postgresql.conf

systemctl restart postgresql.service
