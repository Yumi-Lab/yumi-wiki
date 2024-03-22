# 2.2 RetroPie
![retropie](/img/SmartPi/Retro_Gaming/RetroPieWebsiteLogo.png)
## Intrdocution
RetroPie stands out in the retro gaming world for its unparalleled flexibility and customization options, making it a go-to choice for enthusiasts and builders of retro gaming projects. With its broad support for emulators, RetroPie enables users to dive into a vast library of games spanning decades of consoles and computer systems, from classic Atari and NES to more recent platforms like the PlayStation.

Its customizable nature is a significant advantage, offering users the freedom to tweak the user interface, controller configurations, and even add extra scripts and features to meet their specific needs. This adaptability makes RetroPie an ideal solution for those looking to create a personalized retro gaming console.

Moreover, RetroPie benefits from a dedicated and active community, providing extensive guides, tutorials, and support forums. This community is invaluable for both newcomers learning to set up their retro gaming system and experienced users seeking advanced advice or new project ideas.

In summary, RetroPie is a key platform for retro gaming projects, offering powerful flexibility, extensive emulator support, and a vibrant community, enabling users to craft customized and immersive retro gaming experiences.

# Auto Installation

You can use raspberry imager to prepare the SD card with the image below

Prebuilt image link for 16GB or more (BETA / Remember to unzip the file/ password pi: fun): https://gofile.me/67vGQ/0bSQSSoCT

Image for OS any SD card: Available soon


# Prerequisites

-Installing a smartpi, LINUX BOOKWORM SERVER is recommanded.  

-During linux server installation please create user: pi 

# Manual Installation

Manual installation can take several hours, so you'll just have to be patient while everything installs properly. You'll just have to do a few things during installation.

Connect to the pad via ssh with mobaxterm or putty, for example.

## Update the parcels

```
sudo apt-get update && sudo apt-get upgrade -y
```

## Install the dependencies

```
sudo apt-get install git dialog unzip xmlstarlet libsdl2-2.0-0 libsdl2-gfx-1.0-0 libsdl2-image-2.0-0 libsdl2-mixer-2.0-0 libsdl2-net-2.0-0 libsdl2-ttf-2.0-0 libsdl2-dev libusb-1.0-0-dev libavformat-dev libavdevice-dev pulseaudio samba xorg openbox alsa-utils menu libglib2.0-bin python3-xdg at-spi2-core dbus-x11 xmlstarlet joystick triggerhappy -y
```

## Download the smartpi installation for Retropie

```
git clone https://github.com/Yumi-Lab/Retropie-smartpi.git
```

## Retropie installation

```
cd Retropie-smartpi
sudo chmod +x retropie_setup.sh
sudo chmod +x SambaRetropie.sh
sudo chmod +x retropie_packages.sh
sudo chmod +x autostartES.sh
sudo ./retropie_packages.sh setup basic_install
sudo ./retropie_packages.sh bluetooth depends
sudo ./retropie_packages.sh usbromservice
sudo ./retropie_packages.sh samba depends
sudo ./retropie_packages.sh samba install_shares
sudo ./autostartES.sh
sudo chmod 777 -R /opt/retropie/
sudo chmod +x /opt/retropie/configs/all/autostart.sh
sudo chmod +x /opt/retropie/configs/all/autostart.sh
```

## Relaunching the smartpie

```
sudo reboot
```

## Start

You should see Emulastation start up.

![emula](/img/SmartPi/Retro_Gaming/bootemulastation.png)

Once started, you need to set up a controller

![emula](/img/SmartPi/Retro_Gaming/RetroPie-Reset-Controllers.png)


## add roms or BIOS

you can add roms and bios from your pc by opening an explorer and typing your ip address in the address bar.

For exemple:

![emula](/img/SmartPi/Retro_Gaming/uncshare.png)

you'll be able to see the bios and roms folder. Simply upload your files here, respecting the format and tree structure.
For example, in the roms folder, there's the gba folder for gameboy advance, psx for playstation 1

In this example there is a zip rom for a GameBoy Advence game.

![emula](/img/SmartPi/Retro_Gaming/exemplegba.png)

Each time you add or remove roms, you need to restart Emulation Station or Smartpi.

![emula](/img/SmartPi/Retro_Gaming/gba1.jpg)

![emula](/img/SmartPi/Retro_Gaming/gba2.jpg)

![emula](/img/SmartPi/Retro_Gaming/gba3.jpg)


For everything else, please refer to the official Retropie documentation.


