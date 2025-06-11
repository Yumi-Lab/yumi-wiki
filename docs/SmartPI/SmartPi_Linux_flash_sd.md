# 1.4 Linux flash Micro SD CARD

In this guide, I'll walk you through the steps to install operating system (server or desktop) on your Smart Pi One.
![Layout Smart Pi One](/img/SmartPi/flash_sd/flashsd1.jpg)

## 1.4.1 Hardware

- [Smart Pi One](https://wanhao-europe.com/collections/yumi-smart-pi-nano-computer-diy/products/yumi-smart-pi-one-1g-ddr3-processeur-h3-allwinner)
- Micro SD Card ([Minimum of 16GB](https://wanhao-europe.com/collections/yumi-smart-pi-nano-computer-diy/products/carte-micro-sd-16go))
- USB keyboard and mouse
- Computer display (HDMI)
- Micro-USB C power supply (**5V - 2A  or Power delivery**)

## 1.4.2 Download
Go to Official images. Choose the Armbian version you'd like to install (Debian 12 or UBuntu)


- <B>DEBIAN SERVER :</B> [Yumi-smartpi1-bookworm-server-2024-03-02-2050](https://www.dropbox.com/scl/fo/aalul2sy5xriflqh0v038/h/SMART%20PI%20ONE/DEBIAN%2012/Yumi-smartpi1-bookworm-server-2024-03-02-2050.img.xz.zip?rlkey=x6zccvwdrtmwndpmnx9447bpg&dl=0)
- <B>DEBIAN 12 Desktop :</B> [Yumi-smartpi1-bookworm-desktop-2024-03-02-2050](https://www.dropbox.com/scl/fo/aalul2sy5xriflqh0v038/h/SMART%20PI%20ONE/DEBIAN%2012/Yumi-smartpi1-bookworm-desktop-2024-03-02-2050.img.xz.zip?rlkey=x6zccvwdrtmwndpmnx9447bpg&dl=0)
- <B>UBUNTU SERVER :</B> [Yumi-smartpi1-jammy-server-2024-03-02-2050](https://www.dropbox.com/scl/fo/aalul2sy5xriflqh0v038/h/SMART%20PI%20ONE/UBUNTU/Yumi-smartpi1-jammy-server-2024-03-02-2050.img.xz.zip?rlkey=x6zccvwdrtmwndpmnx9447bpg&dl=0)


## 1.4.3 Use Etcher to write the Smart Pi One SD Card Image to your microSD card

[Download](https://etcher.balena.io/), install, and launch Etcher.

- Open Etcher and click <B>"Select image"</B>.

![ether1](/img/SmartPi/flash_sd/ether1.png)

- Choose the operating system image you downloaded.

![ether2](/img/SmartPi/flash_sd/ether2.png)

- Click <B>"Select target"</B>.

![ether3](/img/SmartPi/flash_sd/ether3.png)

- Choose the micro sd and click <B>"Select 1"</B>.

![ether4](/img/SmartPi/flash_sd/ether4.png)

- Click “Flash!” and wait for the process to complete.

![ether5](/img/SmartPi/flash_sd/ether5.png)

It will take Etcher about 10 minutes to write and validate the image if your microSD card.


## 1.4.4 Booting from MicroSD (First Boot)

Insert the microSD card into your Smart Pi One.

Connect your Smart Pi One to a display, keyboard, and mouse (if necessary).

Power on your Smart Pi One.

## 1.4.5 Initial Setup

Operating system  will guide you through the initial setup. Follow the on-screen instructions, including setting a root password and creating a user.

![smartpi_one_startup_9](/img/SmartPi/SmartPi_One_Startup/smartpi_one_startup_9.png)

> **Note**: If the initial setup for configuring the root and user accounts doesn't appear, you may have missed the first boot and initialization phase. In this case, reflash the SD card, and ensure that the screen and HDMI cable are properly connected before powering on the board to avoid missing the first boot process.

## 1.4.6 Software Updates

After booting, open a terminal. Run the following commands to update your system:

```
sudo apt update && sudo apt upgrade
```

Debian 12 or Ubuntu will download and install the latest updates and patches.

## 1.4.7 Additional Software

Install additional software or packages you need by running:

```
psudo apt install [package-name]
```

Let's go! Operating  system is now up and running on your Smart Pi One. You can explore a variety of applications, use it as a server, or engage in some exciting DIY projects.



