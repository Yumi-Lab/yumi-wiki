# 2.4 OpenMediaVault

![OMV](/img/SmartPi/OMV/openmediavault.jpg)

Openmediavault is a reference for anyone who wants to build their own DIY NAS.



# Prerequisites

-Installing a smartpi, LINUX BOOKWORM SERVER is recommanded.  

-During linux server installation please create user: pi 

Connect to the pad via ssh with mobaxterm or putty, for example.

![SSH](/img/SmartPi/OMV/OMV001.png)

## Update the parcels

```
sudo apt-get update && sudo apt-get upgrade -y
```

## Install

Switch to Superuser:

```
su
```

Install the openmediavault keyring manually:

```
 apt-get install --yes gnupg
wget --quiet --output-document=- https://packages.openmediavault.org/public/archive.key | gpg --dearmor --yes --output "/usr/share/keyrings/openmediavault-archive-keyring.gpg"
```

Add the package repositories:

```
cat <<EOF >> /etc/apt/sources.list.d/openmediavault.list
deb [signed-by=/usr/share/keyrings/openmediavault-archive-keyring.gpg] https://packages.openmediavault.org/public sandworm main
# deb [signed-by=/usr/share/keyrings/openmediavault-archive-keyring.gpg] https://downloads.sourceforge.net/project/openmediavault/packages sandworm main
## Uncomment the following line to add software from the proposed repository.
# deb [signed-by=/usr/share/keyrings/openmediavault-archive-keyring.gpg] https://packages.openmediavault.org/public sandworm-proposed main
# deb [signed-by=/usr/share/keyrings/openmediavault-archive-keyring.gpg] https://downloads.sourceforge.net/project/openmediavault/packages sandworm-proposed main
## This software is not part of OpenMediaVault, but is offered by third-party
## developers as a service to OpenMediaVault users.
# deb [signed-by=/usr/share/keyrings/openmediavault-archive-keyring.gpg] https://packages.openmediavault.org/public sandworm partner
# deb [signed-by=/usr/share/keyrings/openmediavault-archive-keyring.gpg] https://downloads.sourceforge.net/project/openmediavault/packages sandworm partner
EOF
```


Install the openmediavault package:

```
apt-get install openmediavault
```


connection to web interface

http://Your_IP_Address

![SSH](/img/SmartPi/OMV/OMV002.png)


The default logins are :

Username: `admin`
Password: `openmediavault`

You can now connect a disk and create shares.

## Add Disk

Please note that not all changes are applied immediately. Each change requires validation.
If you see the following message, this means that changes are pending. Click on validate to apply them.

![SSH](/img/SmartPi/OMV/OMV013.png)

Connecting an external usb hard drive
Go to Storage\File Systems

![SSH](/img/SmartPi/OMV/OMV003.png)

Click on the Play button

![SSH](/img/SmartPi/OMV/OMV004.png)

Select your disk and click on Save

![SSH](/img/SmartPi/OMV/OMV005.png)

Go to StorageShared Folders then click on + to create a new share

![SSH](/img/SmartPi/OMV/OMV006.png)

The name field corresponds to the name of the share.
The FileSytem field corresponds to your disk
The relative path field corresponds to the name of the folder created on your disk.
Once completed, click on Save

![SSH](/img/SmartPi/OMV/OMV007.png)


If it's for a Windows share, go to Services\SMB/CIFS\Settings
Activate the service and select the features you want.
Once completed, click on Save

![SSH](/img/SmartPi/OMV/OMV008.png)


Then go to Services\SMB/CIFS\Shares and click on the pencil to choose the options that interest you.

![SSH](/img/SmartPi/OMV/OMV009.png)
![SSH](/img/SmartPi/OMV/OMV010.png)

Once completed, click on Save


Return to StorageShared Folders. select your share and click on permission. Then choose the desired permission

![SSH](/img/SmartPi/OMV/OMV011.png)
![SSH](/img/SmartPi/OMV/OMV012.png)


