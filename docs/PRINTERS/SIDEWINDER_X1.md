# Klipper Sidewinder X1 installation

![Sidewinder X1](/img/Printers/Artillery/X1/sidewinderx1.jpg)

This procedure is for anyone who has a Sidewinder X1 and a SmartPad klipper control device.

## 1. Please read the procedure first

You are responsible for all operations carried out on your equipment. This procedure explains how to set up klipper on your printer. It has been tested and is fully functional.

**Disconnect the X1 screen from your motherboard**

## 2. Installation video

Installation video by Dark3dPrint (https://www.tiktok.com/@dark3dprint)

[![Watch the video](/img/Printers/Artillery/X1/Video-icon-vector-by-rudezstudio-580x386.jpg)](https://vm.tiktok.com/ZGeCArDfU/){ target=_blank }


## 3. Hardware and software :

MobaXterm https://mobaxterm.mobatek.net/download-home-edition.html


## 4. SSH connection

Download and install MobaXterm.

Click on the Session icon

![Moba Session](/img/Printers/Artillery/X2/MobaSession.png)

Select SSH

![SSH](/img/Printers/Artillery/X2/MobaSSH.png)

Enter the raspberry's IP address and enter pi as the user name.
Follow this procedure to find the IP address: https://www.malekal.com/comment-faire-un-scan-ip-reseau-local-lan/
Or, on the Pad, go to Menu :

![Pad1](/img/Printers/Artillery/X2/Pad1.jpeg)

Network:

![Pad1](/img/Printers/Artillery/X2/Pad2.jpeg)

You will see your IP address

![Pad1](/img/Printers/Artillery/X2/Pad3.jpeg)

![MobaConnect](/img/Printers/Artillery/X2/MobaConnect.png)

You will be prompted to enter the password.

The Pad Wanhao username is `pi` and the password is `yumi`.

A certificate authorization may appear. You need to validate it.
Once you're logged in, you'll see this screen:

![ConnectPi](/img/Printers/Artillery/X2/ConnectPI.png)


## 5. Generate firmware

The left sidebar corresponds to the Raspberry file and the right to the command line interface.

Issue the command `cd klipper` and confirm with Enter
```
cd klipper
```

![FW](/img/Printers/Artillery/X2/FW01.png)

to access the firmware configuration parameter, run the command:

```
make menuconfig
```

![FW](/img/Printers/Artillery/X2/FW02.png)

You need to set the information below:
 
![FW](/img/Printers/Artillery/X1/MKS%20Gen%20l%20V1.x%20V2.x%20setting.png)

Use the arrow keys to move around and enter to confirm.
When ready, press `q`
Confirm with `Y`
 
![FW](/img/Printers/Artillery/X2/FW04.png)

Run the `make clean` and `make` command. This will generate the firmware.
```
make clean
make
```


## 6. Flashing with the SmartPad

Return to MobaXterm.
Connect the printer to the pad and run the `ls /dev/serial/by-id/*` command.

![Flash](/img/Printers/Artillery/X1/X1-001.png)

  Run the following command to flash the printer:

```
 sudo service klipper stop
```
```
 make flash FLASH_DEVICE=/dev/serial/by-id/usb-1a86_USB_Serial-if00-port0
```

![Flash](/img/Printers/Artillery/X1/X1-002.png)

```
sudo service klipper start
```

## 7. Download configuration files

Download the Sidewinder X1 configuration file from the following link:

Printer.cfg: https://github.com/Yumi-Lab/yumi-config/blob/main/smartpad-sidewinder-x1/printer.cfg


## 8. Mainsail Web interface

You can connect to your Mainsail interface from a web browser with the address http://Your_IP_Address.

Example: http://192.168.1.74

You should arrive on this page. The error is normal. We haven't finished the configuration.

![Mainsail](/img/Printers/Artillery/X2/Mainsail01.png)

From the Mainsail interface, go to Machine (wrench icon)
Click on the button to load files

![Mainsail](/img/Printers/Artillery/X2/Mainsail03.png)

Select configuration file and click Open. Your file will be uploaded to Mainsail.

![Mainsail](/img/Printers/Artillery/X2/Mainsail02.png)

Restart the Pad and connect the printer to it with the correct USB cable.

![Mainsail](/img/Printers/Artillery/X2/Mainsail004.png)

## 9. Get your printer's USB ID

Connect your printer to one of the PAD's USB ports.

Connect via SSH with MobaXterm, then enter the following command to retrieve the USB serial from the motherboard:

```
ls /dev/serial/by-id/*
```

Your id will be different from mine. You should see the USB id appear like this:

![MID](/img/Printers/Artillery/X2/ID01.png)

Go to your Mainsail web interface and click on the Machine tab.

Open the printer.cfg file and look for the [mcu] section.

Modify the existing line with the serial number you've just obtained as follows:

![MID](/img/Printers/Artillery/X2/ID02.png)

Click on SAVE and RESTART in the top right-hand corner to save the file.

Your printer should now connect to your Pi. Restart the firmware if it hasn't been updated yet.

![MID](/img/Printers/Artillery/X2/ID03.png)

From the dashboard, it should look like this:

![MID](/img/Printers/Artillery/X2/ID04.png)


## 10. Calibrating your printer

The general calibration procedures are documented in the SmartPad calibration guides:

- [PID calibration](../KlipperSmartPad/Calibration/PID_calibration.md)
- [Z-OFFSET calibration](../KlipperSmartPad/Calibration/Z_Offset_calibration.md)
- [Extruder calibration](../KlipperSmartPad/Calibration/Extruder_calibration.md)

The steps below use the YumiOS dashboard macros, which automate the PID calibration.

## 11. BED PID

Now it's time to set the PIDs and printer settings.

Start BED PID and save the configuration:
From the Dashboard, launch the BED PID 65 macro

![Calibration](/img/Printers/Artillery/X2/Calibration01.png)

Your tray will heat up several times to 65°C and wait 5 minutes for this to finish.
Use the save macro to apply the settings on restart.

## 12. HOTEND PID

Start HOTEND PID and save the configuration:
From the Dashboard, run the HOTEND 220 PID macro

![Calibration](/img/Printers/Artillery/X2/Calibration01.png)

Your nozzle will heat up several times to 220°C and wait 5 minutes for this to finish.
Use the save macro to apply the settings on restart.

## 13. Print

I recommend starting with a calibration cube. 

https://www.thingiverse.com/thing:1278865

Once you've got a perfect cube, you can start printing
