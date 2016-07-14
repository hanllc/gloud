#!/bin/bash
#apt-get -q -y -u update

sudo apt-get install nodejs
sudo apt-get install nodejs-legacy

sudo apt-get install npm
# Because of a conflict with another package, the executable from the Ubuntu repositories is called nodejs instead of node. 
# Keep this in mind as you are running software.
sudo ln -s /usr/bin/nodejs /usr/bin/node

npm install -g bower
npm install -g polymer-cli

mkdir -p /pdata/web/brokeravm.com
