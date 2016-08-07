//login
gcloud auth login 

//list servers
gcloud compute instances list

//create an instance

//eventual production type --machine-type g1-small
//may want to add at somepoint --no-boot-disk-auto-delete
//removed after adding to see if fix routing
gcloud compute instances create xsd1 --zone us-central1-c --network personal --can-ip-forward --image "/ubuntu-os-cloud/ubuntu-1604-xenial-v20160420c" --machine-type f1-micro --boot-disk-type pd-standard --boot-disk-size 10GB --metadata-from-file startup-script=C:\Users\wehrli\Source\Repos\gcloud\Scripts\XsdInstall.sh

//nuke
gcloud compute instances delete xsd1 --zone us-central1-c

//stop an instance
gcloud compute instances stop xsd1 --zone us-central1-c

//start an instance
gcloud compute instances start xsd1 --zone us-central1-c

//start ssh terminal
gcloud compute ssh xsd1 --zone us-central1-c

//list disks 
gcloud compute disks list

//create a snapshotq
gcloud compute disks snapshot xsd1 --snapshot-names xsd1-lastsnap --zone us-central1-c

//create disk
gcloud compute disks create xsd1n --source-snapshot xsd1-lastsnap --type pd-standard --zone us-central1-c

//detach old attach new
//not allowed - must delete and recreate VM from snapshot
gcloud compute instances detach-disk xsd1 --disk xsd1 --zone us-central1-c

//set startup script for an instance
gcloud compute instances add-metadata xsd1 --metadata-from-file startup-script=C:\Users\wehrli\Source\Repos\gcloud\Scripts\XsdInstall.sh --zone us-central1-c

//set NOTHING startup script for an instance
gcloud compute instances add-metadata xsd1 --metadata-from-file startup-script=C:\Users\wehrli\Source\Repos\gcloud\Scripts\Nothing.sh --zone us-central1-c

//set metadata to contain private for an instance CONTAINER
gcloud compute instances add-metadata xsd1 --metadata-from-file privatekey=C:\Users\wehrli\ZAccess\gpg\private-xsdlive.asc --zone us-central1-c

//add project metadata
gcloud compute project-info add-metadata --metadata-from-file xsdkey=C:\Users\wehrli\ZAccess\gpg\private-xsdlive.asc
gcloud compute project-info add-metadata --metadata-from-file brokeravmkey=C:\Users\wehrli\ZAccess\StartSSL\brokeravm\brokeravm-privkey.txt


//LXD
// https://linuxcontainers.org/lxd/getting-started-cli/
//|             ALIAS               | FINGERPRINT  | PUBLIC |                   DESCRIPTION                   |  ARCH   |   SIZE   |          UPLOAD DATE       
// #| t/i386/20160222 (4 more)      | 7abf249f6516 | yes    | ubuntu 14.04 LTS i386 (release) (20160222)      | i686    | 117.08MB | Feb 22, 2016 at 12:00am (UTC) |

lxc launch ubuntu:14.04 xsd1-1

//log into container
lxc exec xsd1-1 /bin/bash

//gpg
//see https://www.madboa.com/geek/gpg-quickstart/

//Generate a private key.
gpg --gen-key

gpg --list-keys

//Generate an ASCII version of your public key
gpg --armor --output xsdlive-pubkey.txt --export 'xsdlive'

//Encrypting a file
gpg --armor --encrypt --recipient 'xsdlive' brokeravm.com

gpg --output brokeravm.com --decrypt brokeravm.com.asc

//import private key - for new server to consume encrypted github config files
gpg --allow-secret-key-import --import private-xsdlive.asc

//nuke keys - use caution or you lose all encrypted data with these keys
gpg --delete-secret-keys xsdlive
gpg --delete-key xsdlive


//nginx
sudo nginx -s reload
nginx -t
## OR set path to config file and test for the errors ##
nginx -c /etc/nginx/nginx.conf -t

sudo tail -f /var/log/nginx/error.log 
sudo tail -f /var/log/nginx/brokeravm.error.log;

sudo service nginx start
sudo service nginx stop
sudo service nginx restart
OR
sudo /etc/init.d/nginx start
sudo /etc/init.d/nginx stop
sudo /etc/init.d/nginx restart

//error info
systemctl status nginx.service

//docker
#https://www.stgraber.org/2016/04/13/lxd-2-0-docker-in-lxd-712/
docker run --detach --name app carinamarina/hello-world-app
docker run --detach --name web --link app:helloapp -p 80:5000 carinamarina/hello-world-web

docker run -i -t woodo04 /bin/bash

#good docker practices
#http://developers.redhat.com/blog/2016/02/24/10-things-to-avoid-in-docker-containers/
#http://containertutorials.com/network/basic_network.html

docker run -it ubuntu
docker commit 175193ae8074 woodo01

#remove all container but NOT images
docker rm $(docker ps -aq)

//view some net info for docker host
ip addr

//postgres
//login on server
sudo -u postgres psql postgres

//login from client 
psql -h 192.168.198.167 -U postgres -W
psql -h xsd1-3.lxd -U postgres -W

//odoo
./odoo.py --config ./wehrli.org.conf --proxy-mode --xmlrpc-port=8071 --logfile /var/log/wehrli.org/odoo.log --db_user xxx --db_password xxx

#this worked
lxc exec xsd1-4 /bin/bash 
docker run -p 8069:8069 wodoo05 /odoo/odoo.py --db_user xsdodoo --db_host 192.168.198.167
docker run -p 8069:8069 wodoo05 /odoo/odoo.py --proxy-mode --xmlrpc-port=8069 --db_user xsdodoo --db_host 192.168.198.167

#http://stackoverflow.com/questions/18504835/pil-decoder-jpeg-not-available-on-ubuntu-x64