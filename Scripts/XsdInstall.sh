#!/bin/bash                                                                                                     
#see for example-info http://howto.blbosti.com/2010/02/simple-ubuntu-install-script/                            
#see for gcp docs on startup scripts https://cloud.google.com/compute/docs/startupscript                        
#see for log /var/log/startupscript.log     
#rerun me sudo /usr/share/google/run-startup-scripts
#set true or no                                                                    
HOST_INSTALL="true"
XSD_K1_INSTALL="false"
XSD_K1_PORTFWD="false"
echo XSD startup script run parameters
echo HOST_INSTALL: "$HOST_INSTALL"
echo XSD_K-1_INSTALL: "$XSD_K1_INSTALL"
echo XSD_K-1_PORTFWD: "$XSD_K1_PORTFWD"
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
		sudo wget https://raw.githubusercontent.com/hanllc/gloud/master/Scripts/lxd-bridge
		sudo mv /etc/default/lxd-bridge /etc/default/orig-lxd-bridge
		sudo cp ./lxd-bridge /etc/default/lxd-bridge
		sudo lxd init --auto --storage-backend=dir
		#sudo service lxd-bridge stop && sudo service lxd restart
        #lxc launch ubuntu:16.04 xsd1-1
fi
if [ "$XSD_K1_INSTALL" == 'true' ]; then
        wget https://raw.githubusercontent.com/hanllc/gloud/master/Scripts/XsdK-1/XsdK-1-Install.sh
		sudo chmod +x XsdK-1-Install.sh
        lxc file push ./XsdK-1-Install.sh xsd1-1/root/
		curl -o brokeravm-key.asc http://metadata.google.internal/computeMetadata/v1/project/attributes/brokeravmkey -H "Metadata-Flavor: Google"
		lxc file push ./brokeravm-key.asc xsd1-1/root/
		curl -o instance-config-key.asc http://metadata.google.internal/computeMetadata/v1/project/attributes/xsdkey -H "Metadata-Flavor: Google"
		lxc file push ./instance-config-key.asc xsd1-1/root/
		lxc exec xsd1-1 /root/XsdK-1-Install.sh
fi
if [ "$XSD_K1_PORTFWD" == 'true' ]; then
		# BE SURE to make sure google subnet rules network tag is empty or correct - burned hours on that
		# https://cloud.google.com/compute/docs/networking#natgateway
		# http://serverfault.com/questions/780082/iptables-nat-to-lxd-containers
		# http://serverfault.com/questions/689930/linux-container-bridge-port-forwarding
		sudo iptables -t nat -A	PREROUTING -i ens4 -p tcp -d 192.168.199.2 --dport 80 -j DNAT --to-destination 192.168.198.202:80
		sudo iptables -t nat -A	PREROUTING -i ens4 -p tcp -d 192.168.199.2 --dport 443 -j DNAT --to-destination 192.168.198.202:443
		# sudo iptables -t nat -L -n -v
		# use -D to remove
fi