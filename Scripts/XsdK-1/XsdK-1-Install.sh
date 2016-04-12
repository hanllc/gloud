#! /bin/bash
apt-get -q -y -u update
apt-get -q -y -u -V install nginx

mkdir /pdata
mkdir /pdata/web
mkdir /pdata/web/xsdlive.com
mkdir /pdata/web/brokeravm.com
mkdir /pdata/web/wehrli.org

#mkdir /etc/nginx/sites-available/brokeravm.com
#wget brokeravm

curl -o instance-config-key.asc "http://metadata.google.internal/computeMetadata/v1/instance/attributes/xsdkey"  -H "Metadata-Flavor: Google"
curl -o brokeravm.com.asc https://raw.githubusercontent.com/hanllc/gcloud/master/Scripts/XsdK-1/brokeravm.com.asc
gpg --allow-secret-key-import --import instance-config-key.asc
gpg --output brokeravm.com --decrypt brokeravm.com.asc





