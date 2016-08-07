#!/bin/bash
#apt-get -q -y -u update
sudo apt-get -q -y -u -V install emacs24-nox
sudo apt-get install traceroute
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

#initial setup; now stored in source control 
#ssh-keygen -t rsa -b 4096 -N "" -f "/root/.ssh/key4x" -q
curl -o /root/.ssh/key4x.pub https://raw.githubusercontent.com/hanllc/gloud/master/Scripts/key4x.pub
cat /root/key4x.pub >> /root/.ssh/authorized_keys

#worked with no added configuration - nice
sudo apt-get install xterm

#get chrome
# ref http://www.ubuntumaniac.com/2016/02/install-google-chrome-4802564116-on.html

wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i --force-depends google-chrome-stable_current_amd64.deb
sudo apt-get install -f

#MANUAL STEP hack chrome start to make run at root
# https://ubuntuforums.org/showthread.php?t=1743565

