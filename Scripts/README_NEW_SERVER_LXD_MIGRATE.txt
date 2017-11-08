
gcloud compute instances create xsd2 --zone us-central1-c --network personal --can-ip-forward --tags http-server,https-server --image "/ubuntu-os-cloud/ubuntu-1604-xenial-v20170516" --no-boot-disk-auto-delete --machine-type g1-small --boot-disk-type pd-standard --boot-disk-size 20GB --metadata-from-file startup-script=C:\Users\wehrli\Source\Repos\gcloud\Scripts\XsdInstall.sh

//review log via 	 less /var/log/syslog

//https://stgraber.org/2016/04/12/lxd-2-0-remote-hosts-and-container-migration-612/

//on new server
lxc config set core.https_address [::]:8443
lxc config set core.trust_password FOD



//on cur server
lxc config set core.https_address [::]:8443

//lxc remote add foo 1.2.3.4
//lxc remote add xsd2 192.168.199.3
lxc remote add xsd1 192.168.199.2


//failed so we 
//added firewall rule personal network google network to allow 8443

//see add remote
lxc remote list 

//rename xsd2-x to reflect a copy vs a immutable new build
sudo lxc copy xsd1-1 xsd2:xsd2-1
sudo lxc copy xsd1-3 xsd2:xsd2-3
sudo lxc copy xsd1-4 xsd2:xsd2-4
sudo lxc copy xsd1-5 xsd2:xsd2-5

//OR place in script and sudo
lxc copy xsd1-1 xsd2:xsd2-1
lxc copy xsd1-3 xsd2:xsd2-3
lxc copy xsd1-4 xsd2:xsd2-4
lxc copy xsd1-5 xsd2:xsd2-5
 
 //move to xsd1 from xsd2
lxc copy xsd1-1 xsd1:xsd1-1
lxc copy xsd1-3 xsd1:xsd1-3
lxc copy xsd1-4 xsd1:xsd1-4
lxc copy xsd2-5 xsd2:xsd1-5
