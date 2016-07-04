#!/bin/bash                                                                                                     
#see for example-info http://howto.blbosti.com/2010/02/simple-ubuntu-install-script/                            
#see for gcp docs on startup scripts https://cloud.google.com/compute/docs/startupscript                        
#see for log /var/log/startupscript.log     
#rerun me sudo /usr/share/google/run-startup-scripts
#set true or no                                                                    
HOST_INSTALL="true"
XSD_K1_INSTALL="false"
echo Script run parameters
echo HOST_INSTALL: "$HOST_INSTALL"
echo XSD_K-1_INSTALL: "$XSD_K1_INSTALL"
if [ "$HOST_INSTALL" == 'true' ]; then
        #download only use -d with apt-get                                                                      
        #sudo apt-get -q -y -u update
        #sudo apt-get -q -y -u -V dist-upgrade
		#emacs                                                                                                  
        sudo apt-get -q -y -u -V install emacs24-nox
		#bridge for containers - only needed without NATed lxdbr0 - was never able to get pure bridge or macvlan working
		#sudo apt-get install bridge-utils
		# https://github.com/tych0/tycho.ws/blob/master/src/blog/2016/04/lxdbr0.md
        #lxd system
        #sudo apt-get -q -y -u -V install lxd
        sudo lxd init --auto --storage-backend=dir
		sudo wget https://raw.githubusercontent.com/hanllc/gloud/master/Scripts/lxd-bridge
		sudo mv /etc/default/lxd-bridge /etc/default/orig-lxd-bridge
		sudo cp ./lxd-bridge /etc/default/lxd-bridge
		sudo service lxd-bridge stop && sudo service lxd restart
        lxc launch ubuntu:16.04 xsd1-1
fi
if [ "$XSD_K1_INSTALL" == 'true' ]; then
        wget https://raw.githubusercontent.com/hanllc/gloud/master/Scripts/XsdK-1/XsdK-1-Install.sh
		sudo chmod +x XsdK-1-Install.sh
        lxc file push ./XsdK-1-Install.sh xsd1-1/root/
		
		curl -o instance-config-key.asc http://metadata.google.internal/computeMetadata/v1/project/attributes/xsdkey -H "Metadata-Flavor: Google"
		lxc file push ./instance-config-key.asc xsd1-1/root/

		lxc exec xsd1-1 ls -l /etc/network.d/
		lxc exec xsd1-1 mv /etc/network.d/ens4.cfg /root
		wget https://raw.githubusercontent.com/hanllc/gloud/master/Scripts/XsdK-1/lxdnetwork.cfg
		lxc file push ./lxdnetwork.cfg xsd1-1/etc/interfaces.d/ens4.cfg
		lxc exec xsd1-1 ifdown ens4
		lxc exec xsd1-1 ifup ens4
		lxc exec xsd1-1 ifup br0
		lxc exec xsd1-1 ifconfig
        #lxc exec xsd1-1 /root/XsdK-1-Install.sh
fi
