//login
gcloud auth login 

//list servers
gcloud compute instances list

//create an instance
gcloud compute instances create xsd1 --zone us-central1-c --network personal --image ubuntu-14-04 --machine-type g1-small --boot-disk-type pd-standard --boot-disk-size 10GB --no-boot-disk-auto-delete

gcloud compute instances create xsd1 --zone us-central1-c --network personal --image ubuntu-14-04 --machine-type g1-small --boot-disk-type pd-standard --boot-disk-size 10GB --no-boot-disk-auto-delete --metadata-from-file startup-script=C:\Users\wehrli\Source\Repos\gcloud\Scripts\XsdInstall.sh

gcloud compute instances create xsd1 --zone us-central1-c --network personal --image "/ubuntu-os-cloud/ubuntu-1604-xenial-v20160420c" --machine-type f1-micro --boot-disk-type pd-standard --boot-disk-size 10GB --no-boot-disk-auto-delete --metadata-from-file startup-script=C:\Users\wehrli\Source\Repos\gcloud\Scripts\XsdInstall.sh

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
