#!/bin/bash
#apt-get -q -y -u update
sudo apt-get -q -y -u -V install emacs24-nox
sudo apt-get install git

sudo apt-get install nodejs
sudo apt-get install nodejs-legacy

sudo apt-get install npm
# Because of a conflict with another package, the executable from the Ubuntu repositories is called nodejs instead of node. 
# Keep this in mind as you are running software.
#pretty sure nodejs-legacy does this
#sudo ln -s /usr/bin/nodejs /usr/bin/node

npm install -g bower
npm install -g polymer-cli

mkdir -p /pdata/web/brokeravm.com
cd /pdata/web/brokeravm.com
git init

#had trouble without --allow-root
bower --allow-root install

#polymer serve -p 80 -H 192.168.198.46

#setup SSH for Chromium via XForwarding
mkdir ~/.ssh
chmod 700 ~/.ssh

#ssh-keygen -t rsa -b 4096 -C "comment" -P "examplePassphrase" -f "desired pathAndName" -q
ssh-keygen -t rsa -b 4096 -N "" -f "/root/.ssh/key4x" -q
cat /root/.ssh/key4x.pub >> /root/.ssh/authorized_keys

