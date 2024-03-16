# 2.2 Retro Gaming

![retropie](/img/SmartPi/Retro_Gaming/RetroPieWebsiteLogo.png)



# Prerequisites

Installing a smartpi operating system without a graphical interface

# Manual Installation

L'installation manuel peut prendre plusieur heures. il faudra donc être patient le temps que tout s'installe correctement. il faudrat simplement executer differente comment pendant l'installation.

Connecter vous en ssh sur le pad avec mobaxterm ou putty par exemple.

## Mettre a jour les parcels

'''
sudo apt-get update && sudo apt-get upgrade -y
'''

## Install the dependencies

'''
sudo apt-get install git dialog unzip xmlstarlet libsdl2-2.0-0 libsdl2-gfx-1.0-0 libsdl2-image-2.0-0 libsdl2-mixer-2.0-0 libsdl2-net-2.0-0 libsdl2-ttf-2.0-0 libsdl2-dev libusb-1.0-0-dev libavformat-dev libavdevice-dev pulseaudio samba xorg openbox alsa-utils menu libglib2.0-bin python3-xdg at-spi2-core dbus-x11 xmlstarlet joystick triggerhappy -y
'''

## Download the smartpi installation for Retropie

'''
git clone .......
'''

## Retropie installation

'''
cd RetroPie-Setup
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
'''

## Relaunching the smartpie

'''
sudo reboot
'''

# Sart

You should see Emulastation start up.

![emula](/img/SmartPi/Retro_Gaming/bootemulastation.png)

Once started, you need to set up a controller

![emula](/img/SmartPi/Retro_Gaming/RetroPie-Reset-Controllers.png)


# add roms or BIOS

you can add roms and bios from your pc by opening an explorer and typing your ip address in the address bar.

For exemple:

![emula](/img/SmartPi/Retro_Gaming/uncshare.png)

you'll be able to see the bios and roms folder. Simply upload your files here, respecting the format and tree structure.
For example, in the roms folder, there's the gba folder for gameboy advance, psx for playstation 1

In this example there is a zip rom for a GameBoy Advence game.

![emula](/img/SmartPi/Retro_Gaming/exemplegba.png)

Each time you add or remove roms, you need to restart Emulation Station or Smartpi.

![emula](/img/SmartPi/Retro_Gaming/gba1)

![emula](/img/SmartPi/Retro_Gaming/gba2)

![emula](/img/SmartPi/Retro_Gaming/gba3)


For everything else, please refer to the official Retropie documentation.


