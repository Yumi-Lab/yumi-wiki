# 1.2 Getting Started with the Smart Pi One

<img src="../../img/SmartPi/SmartPi_One_Startup/smartpi_one_startup_1.png" alt="Smart Pi One - Yumi" width="380"/>

## Introduction
The **Smart Pi One** is a versatile nano-computer designed for various projects, from home automation to retro gaming. This guide will walk you through the initial setup and essential configurations to get you started.

## Specifications
For detailed specifications of the Smart Pi One, visit the [Specifications Page](https://wiki.yumi-lab.com/SmartPI/SmartPi_One_specifications/).

## 1. Required Materials
Before starting, ensure you have the following:
- A Smart Pi One board
- A compatible power adapter
- A microSD card (minimum 16 GB)
- An HDMI cable (for display)
- A USB keyboard and mouse (for initial setup)
- Internet connection (Wi-Fi or Ethernet)

## 2. Preparing the microSD Card
1. **Download the Official Linux Server Image** for Smart Pi One from the [Linux Image Page](https://wiki.yumi-lab.com/SmartPI/SmartPi_Linux/).
2. **Flash the Image** onto the microSD card using software like balenaEtcher. Follow the instructions on the [Micro SD Card Flashing Guide](https://wiki.yumi-lab.com/SmartPI/SmartPi_Linux_flash_sd/).

![alt text](../../img/SmartPi/SmartPi_One_Startup/smartpi_one_startup_2.png)

3. Insert the microSD card into the Smart Pi One.

## 3. Connecting the Hardware
1. Connect the Smart Pi One to a monitor using an HDMI cable.
2. Plug in the USB keyboard and mouse.
3. Connect the power adapter to the board.

## 4. Powering On the Board
1. Turn on the power supply. The board should boot automatically.
2. Follow the on-screen instructions to configure the initial settings, including network configuration.

## 5. Accessing the Board via SSH
The Smart Pi One has SSH enabled by default. To connect remotely:
1. **Find the IP Address** of the Smart Pi One. You can use a network scanner or check your router’s DHCP settings.
2. From another device, open a terminal and type:
   ```bash
   ssh user@ip_address
   ```
   Replace `user` with your username and `ip_address` with the Smart Pi One’s IP address.

![alt text](../../img/SmartPi/SmartPi_One_Startup/smartpi_one_startup_3.png)

For detailed SSH connection instructions for Windows, Mac, and Linux, refer to the [SSH Connection Guide](https://wiki.yumi-lab.com/SmartPI/SmartPi_Connect_Ssh/).

## 6. System Update
After booting, it’s crucial to update the system to ensure you have the latest security patches and features:
```bash
sudo apt update && sudo apt upgrade -y
```

![alt text](../../img/SmartPi/SmartPi_One_Startup/smartpi_one_startup_4.png)

## 7. Initial Configuration
- **Change Password**: For security, change the default password. Follow the instructions in the [Password Change Guide](https://wiki.yumi-lab.com/SmartPI/SmartPi_Change_Password/).
- **Set the Timezone**: Make sure the timezone is set correctly by following the [Timezone Configuration Guide](https://wiki.yumi-lab.com/SmartPI/SmartPi_ConfigureTimeZone/).
- **Connect to Wi-Fi**: If using Wi-Fi, refer to the [Wi-Fi Connection Guide](https://wiki.yumi-lab.com/SmartPI/SmartPi_Connect_Wifi/) to set it up.

## 8. Basic Commands
Familiarize yourself with essential commands to manage your board effectively. Visit the [Basic Commands Page](https://wiki.yumi-lab.com/SmartPI/SmartPi_Basic_Commands/) for useful commands such as shutting down, rebooting, and file management.

## 9. Explore Advanced Projects
Once you are comfortable with the basics, explore advanced projects:
- **Klipper**: [Setup Klipper](https://wiki.yumi-lab.com/SmartPI/SmartPi_Klipper/)
- **Retro Gaming**: [Install RetroMi (Optimized RetroPie)](https://wiki.yumi-lab.com/SmartPI/SmartPi_Retro_Gaming/)
- **Home Automation**: [Set up Home Assistant](https://wiki.yumi-lab.com/SmartPI/SmartPi_Home_Assistant/)
- **Media Storage**: [Configure OpenMediaVault](https://wiki.yumi-lab.com/SmartPI/SmartPI_OpenMediaVault/)
- **Media Server**: [Set up Plex Server](https://wiki.yumi-lab.com/SmartPI/SmartPi_Plex_Server/)

