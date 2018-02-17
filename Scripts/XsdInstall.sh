#!/bin/bash -x                                                                                                 
#see for example-info http://howto.blbosti.com/2010/02/simple-ubuntu-install-script/                            
#see for gcp docs on startup scripts https://cloud.google.com/compute/docs/startupscript                        
#see for log /var/log/startupscript.log     
#rerun me 
#sudo google_metadata_script_runner --script-type startup

#set true or no                                                                    
HOST_INSTALL="false"
XSD_K1_INSTALL="false"
XSD_K1_PORTFWD="false"
XSD_K3_INSTALL="false"
XSD_K4_INSTALL="false"
echo XSD startup script run parameters
echo HOST_INSTALL: "$HOST_INSTALL"
echo XSD_K-1_INSTALL: "$XSD_K1_INSTALL"
echo XSD_K-1_PORTFWD: "$XSD_K1_PORTFWD"
echo XSD_K-3_INSTALL: "$XSD_K3_INSTALL"
echo XSD_K-4_INSTALL: "$XSD_K4_INSTALL"

if [ "$HOST_INSTALL" == 'true' ]; then

		#CREATE data disk
		#I DID NOT DO ANY OF THIS DISK MOUNT ONCE USING ZFS
		# sudo lsblk
		# sudo mkfs.ext4 -m 0 -F -E lazy_itable_init=0,lazy_journal_init=0,discard /dev/sdb
		# sudo mkdir -p /mnt/disks/xsddata
		# sudo mount -o discard,defaults /dev/sdb /mnt/disks/xsddata
		# sudo chmod a+w /mnt/disks/xsddata
		# sudo cp /etc/fstab /etc/fstab.backup
		# sudo blkid /dev/sdb
		# add into /etc/fstab
		# UUID=845469a4-0658-4622-9bad-e61ffa57aa59 /mnt/disks/xsddata ext4 discard,defaults,nofail 0 2
		# If you detach this persistent disk or create a snapshot from the boot disk for this instance, edit the /etc/fstab file and remove the 
		# entry for this persistent disk. Even with the nofail or nobootwait options in place, keep the /etc/fstab file in sync with the 
		# devices that are attached to your instance and remove these entries before you create your boot disk snapshot or when you detach 
		# persistent disks.

        #download only use -d with apt-get                                                                      
        # sudo apt-get -q -y -u update
        # sudo apt-get -q -y -u -V dist-upgrade
		#emacs                                                                                                  
        sudo apt-get -q -y -u -V install emacs24-nox
		#zfs
		sudo apt install zfs
		sudo zpool status
		parted /dev/sdb -- mklabel GPT then q
		sudo zpool create xsdpool /dev/sdb


		#bridge for containers - only needed without NATed lxdbr0 - was never able to get pure bridge or macvlan working
		#sudo apt-get install bridge-utils
		# https://github.com/tych0/tycho.ws/blob/master/src/blog/2016/04/lxdbr0.md
        #lxd system
        #sudo apt-get -q -y -u -V install lxd
		sudo wget https://raw.githubusercontent.com/hanllc/gloud/master/Scripts/lxd-bridge
		sudo mv /etc/default/lxd-bridge /etc/default/lxd-bridge.origcopy
		sudo cp ./lxd-bridge /etc/default/lxd-bridge
		

		#sudo lxd init --auto --storage-backend=dir
		sudo lxd init --auto --storage-backend=zfs --storage-pool xsdpool
		sudo service lxd-bridge stop && sudo service lxd restart
		
		#dev web
		#lxc launch ubuntu:16.04 xsd1-2
		#postgres all
		#lxc launch ubuntu:16.04 xsd1-3
		#docker
		#https://www.stgraber.org/2016/04/13/lxd-2-0-docker-in-lxd-712/
		#lxc launch ubuntu:16.04 xsd1-4 -p default -p docker
		#lxc launch ubuntu:16.04 xsd1-5
fi
#prod web
if [ "$XSD_K1_INSTALL" == 'true' ]; then
		lxc launch ubuntu:16.04 xsd1-1
        wget https://raw.githubusercontent.com/hanllc/gloud/master/Scripts/XsdK-1/XsdK-1-Install.sh
		sudo chmod +x XsdK-1-Install.sh
        lxc file push ./XsdK-1-Install.sh xsd1-1/root/
		curl -o brokeravm-key.asc http://metadata.google.internal/computeMetadata/v1/project/attributes/brokeravmkey -H "Metadata-Flavor: Google"
		lxc file push ./brokeravm-key.asc xsd1-1/root/
		curl -o instance-config-key.asc http://metadata.google.internal/computeMetadata/v1/project/attributes/xsdkey -H "Metadata-Flavor: Google"
		lxc file push ./instance-config-key.asc xsd1-1/root/
		#lxc exec xsd1-1 /root/XsdK-1-Install.sh
fi
if [ "$XSD_K1_PORTFWD" == 'true' ]; then
		# currently these get blown away on a reboot
		# BE SURE to make sure google subnet rules network tag is empty or correct - burned hours on that
		# https://cloud.google.com/compute/docs/networking#natgateway
		# http://serverfault.com/questions/780082/iptables-nat-to-lxd-containers
		# http://serverfault.com/questions/689930/linux-container-bridge-port-forwarding
		#xsd1-1
		#sudo iptables -t nat -A	PREROUTING -i ens4 -p tcp -d 192.168.199.2 --dport 80 -j DNAT --to-destination 192.168.198.202:80
		#sudo iptables -t nat -A	PREROUTING -i ens4 -p tcp -d 192.168.199.2 --dport 443 -j DNAT --to-destination 192.168.198.202:443
		#sudo iptables -t nat -A	PREROUTING -i ens4 -p tcp -d 192.168.199.2 --dport 2201 -j DNAT --to-destination 192.168.198.202:22
		#xsd1-2
		#sudo iptables -t nat -A	PREROUTING -i ens4 -p tcp -d 192.168.199.2 --dport 8080 -j DNAT --to-destination 192.168.198.46:80
		#sudo iptables -t nat -A	PREROUTING -i ens4 -p tcp -d 192.168.199.2 --dport 2202 -j DNAT --to-destination 192.168.198.46:22
		#xsd1-4
		#xsd1-5
		#sudo iptables -t nat -A	PREROUTING -i ens4 -p tcp -d 192.168.199.2 --dport 8085 -j DNAT --to-destination 192.168.198.145:80

		# sudo iptables -t nat -L -n -v
		# use -D to remove (replaces the -A)
		#xsd2.xsd1-1
		#sudo iptables -t nat -A	PREROUTING -i ens4 -p tcp -d 192.168.199.3 --dport 80 -j DNAT --to-destination 192.168.198.64:80
		#sudo iptables -t nat -A	PREROUTING -i ens4 -p tcp -d 192.168.199.3 --dport 443 -j DNAT --to-destination 192.168.198.64:443
		#sudo iptables -t nat -A	PREROUTING -i ens4 -p tcp -d 192.168.199.2 --dport 2201 -j DNAT --to-destination 192.168.198.202:22
		#new xsd1.xsd1-1
		sudo iptables -t nat -A	PREROUTING -i ens4 -p tcp -d 192.168.199.2 --dport 80 -j DNAT --to-destination 192.168.198.64:80
		sudo iptables -t nat -A	PREROUTING -i ens4 -p tcp -d 192.168.199.2 --dport 443 -j DNAT --to-destination 192.168.198.64:443
		
fi
if [ "$XSD_K2_INSTALL" == 'true' ]; then
		lxc launch ubuntu:16.04 xsd1-2
# added 512m swap to HOSt to get polymer-cli to install in the container
# hopefully only needed one time - did not make permanent
# https://www.digitalocean.com/community/tutorials/how-to-add-swap-space-on-ubuntu-16-04

        wget https://raw.githubusercontent.com/hanllc/gloud/master/Scripts/XsdK-2/XsdK-2-Install.sh
		sudo chmod +x XsdK-2-Install.sh
        lxc file push ./XsdK-2-Install.sh xsd1-2/root/
		lxc exec xsd1-2 /root/XsdK-2-Install.sh


fi
if [ "$XSD_K3_INSTALL" == 'true' ]; then
		lxc launch ubuntu:16.04 xsd1-3
        wget https://raw.githubusercontent.com/hanllc/gloud/master/Scripts/XsdK-3/XsdK-3-Install.sh
		sudo chmod +x XsdK-3-Install.sh
        lxc file push ./XsdK-3-Install.sh xsd1-3/root/
		#lxc exec xsd1-3 /root/XsdK-3-Install.sh
fi
if [ "$XSD_K4_INSTALL" == 'true' ]; then
		lxc launch ubuntu:16.04 xsd1-4
        wget https://raw.githubusercontent.com/hanllc/gloud/master/Scripts/XsdK-4/XsdK-4-Install.sh
		sudo chmod +x XsdK-4-Install.sh
        lxc file push ./XsdK-4-Install.sh xsd1-4/root/
		#https://github.com/lxc/lxd
		#lxc config set xsd1-4 security.nesting true
		#lxc restart xsd1-4
		#lxc exec xsd1-4 /root/XsdK-4-Install.sh
fi
if [ "$XSD_K5_INSTALL" == 'true' ]; then
        wget https://raw.githubusercontent.com/hanllc/gloud/master/Scripts/XsdK-5/XsdK-5-Install.sh
		sudo chmod +x XsdK-5-Install.sh
        lxc file push ./XsdK-5-Install.sh xsd1-5/root/
		lxc exec xsd1-5 /root/XsdK-5-Install.sh
fi