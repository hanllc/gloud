#! /bin/bash

#see for example-info http://howto.blbosti.com/2010/02/simple-ubuntu-install-script/
#see for gcp docs on startup scripts https://cloud.google.com/compute/docs/startupscript

#see for log /var/log/startupscript.log

HOST_INSTALL=true
XSD_K-1_INSTALL=true

if [ "$HOST_INSTALL" == true]; then
	#download only use -d with apt-get

	#emacs
	sudo apt-get -q -y -u -V install emacs24-nox

	#lxd system
	sudo add-apt-repository -m -y ppa:ubuntu-lxc/lxd-stable
	sudo apt-get -q -y -u update
	sudo apt-get -q -y -u -V dist-upgrade
	sudo apt-get -q -y -u -V install lxd

	sudo lxd init --auto --storage-backend=dir

	lxc launch ubuntu:14.04 xsd1-1
fi

if [ "$XSD_K-1_INSTALL" == true]; then
	wget https://raw.githubusercontent.com/hanllc/gcloud/master/Scripts/XsdK-1/XsdK-1-Install.sh
	lxc file push ./XsdK-1-Install.sh xsd1-1/.
	lxc exec xsd1-1 ./XsdK-1-Install.sh
fi

