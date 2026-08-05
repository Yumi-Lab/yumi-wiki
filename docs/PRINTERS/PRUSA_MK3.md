# Klipper Prusa Mk3 installation

![mk3](/img/Printers/Prusa/Mk3/Mk3.jpeg)

This procedure is for anyone who has a Prusa Mk3 and a SmartPad klipper control device.

## 1. Please read the procedure first

You are responsible for all operations carried out on your equipment. This procedure explains how to set up klipper on your printer. It has been tested and is fully functional.
This procedure has been tested and approved for prusa mk3. Do not install it on other printers.


## 2. Hardware and software

MobaXterm https://mobaxterm.mobatek.net/download-home-edition.html

## 3. SSH connection

Download and install MobaXterm.

Click on the Session icon

![Moba Session](/img/Printers/Prusa/Mk3/MobaSession.png)

Select SSH

![SSH](/img/Printers/Prusa/Mk3/MobaSSH.png)

Enter the raspberry's IP address and enter pi as the user name.
Follow this procedure to find the IP address: https://www.malekal.com/comment-faire-un-scan-ip-reseau-local-lan/
Or, on the Pad, go to Menu :

![Pad1](/img/Printers/Prusa/Mk3/Pad1.jpeg)

Network:

![Pad1](/img/Printers/Prusa/Mk3/Pad2.jpeg)

You will see your IP address

![Pad1](/img/Printers/Prusa/Mk3/Pad3.jpeg)

![MobaConnect](/img/Printers/Prusa/Mk3/MobaConnect.png)

You will be prompted to enter the password.

The Yumi Smart Pad username is "pi" and the password is "yumi".

A certificate authorization may appear. You need to validate it.
Once you're logged in, you'll see this screen:

![ConnectPi](/img/Printers/Prusa/Mk3/ConnectPI.png)

## 4. Generate firmware

The left sidebar corresponds to the Pad file and the right to the command line interface.

Issue the command `cd klipper` and confirm with Enter
```
cd klipper
```

![FW](/img/Printers/Prusa/Mk3/fw1.png)

to access the firmware configuration parameter, run the command:

```
make menuconfig
```

![FW](/img/Printers/Prusa/Mk3/fw2.png)

You need to set the following information:

![FW](/img/Printers/Prusa/Mk3/fw3.png)

Use the arrow keys to move around and enter to confirm.
When ready, press `q`
Confirm with `Y`

![FW](/img/Printers/Prusa/Mk3/fw4.png)

Run the `make clean` and `make` command. This will generate the firmware.
```
make clean
make
```

## 5. Firmware flash

Return to MobaXterm.
Connect the printer to the pad and run the command:
```
ls /dev/serial/by-id*
```
You should have a device.
![Flash](/img/Printers/Prusa/Mk3/Flash.png)

Run the following command to flash the printer:
```
make flash FLASH_DEVICE=/dev/serial/by-id/xxxxxxxxxxxxxx
```

XXXXXX corexponds to the one you obtained with the command ls /dev/serial/by-id*.
For example: make flash FLASH_DEVICE=/dev/serial/by-id/usb-Prusa_Research__prusa3d.com__Original_Prusa_i3_MK3_CZPX0123X004XK05843-if00

## 6. Download configuration files

You can download the Prusa configuration file from the following link:

Printer.cfg: https://github.com/Yumi-Lab/yumi-wiki/blob/main/Klipper/Prusa/Mk3/printer.cfg

## 7. Mainsail Web interface

You can connect to your Mainsail interface from a web browser with the address http://Your IP address.

Example: http://192.168.1.74

You should arrive on this page. The error is normal. We haven't finished the configuration.

![Mainsail](/img/Printers/Prusa/Mk3/mainsail1.png)

From the Mainsail interface, go to Machine (wrench icon)
Click on the button to load files

![Mainsail](/img/Printers/Prusa/Mk3/mainsail3.png)

Select configuration file and click Open. Your file will be uploaded to Mainsail.

![Mainsail](/img/Printers/Prusa/Mk3/mainsail2.png)

Restart the Pad and connect the printer to it with the correct USB cable.

![Mainsail](/img/Printers/Prusa/Mk3/mainsail4.png)

From the Dashboard, you should be able to control your printer.

## 8. Changer les paramètres de votre slicer
## 9. CURA

From cura, go to Preference/Configure Cura...
In the new window, go to Printers and choose your X2 profile.
Click on Machine settings

![Slicer](/img/Printers/Prusa/Mk3/Slicer01.png)

In the Start Gcode section put:
```
START_PRINT BED_TEMP={material_bed_temperature_layer_0} EXTRUDER_TEMP={material_print_temperature_layer_0}
```

Put in End Gcode:
```
PRINT_END
```

![Slicer](/img/Printers/Prusa/Mk3/Slicer02.png)

You need to install the Klipper Setting Plugin. 
To do this, please follow the steps below: https://github.com/jjgraphix/KlipperSettingsPlugin
Once installed, activate firmware retraction in the Klipper Settings section.

![Slicer](/img/Printers/Prusa/Mk3/Slicer03.jpeg)

## 10. PrusaSlicer

From your printer settings,
In the Start Gcode section, enter:
```
START_PRINT BED_TEMP=[first_layer_bed_temperature] EXTRUDER_TEMP=[first_layer_temperature]
```
In the End Gcode section put:
```
PRINT_END
```

![Slicer](/img/Printers/Prusa/Mk3/Slicer04.png)

In the general section of your printer settings, activate firmware retraction.

## 11. Calibrating your printer

The general calibration procedures are documented in the SmartPad calibration guides:

- [PID calibration](../KlipperSmartPad/Calibration/PID_calibration.md)
- [Z-OFFSET calibration](../KlipperSmartPad/Calibration/Z_Offset_calibration.md)
- [Extruder calibration](../KlipperSmartPad/Calibration/Extruder_calibration.md)

The steps below use the YumiOS dashboard macros, which automate the PID calibration.

## 12. BED PID

Now it's time to set the PIDs and printer settings.

Start BED PID and save the configuration:
From the Dashboard, launch the BED PID 65 macro

![Calibration](/img/Printers/Prusa/Mk3/Calibration01.png)

Your tray will heat up several times to 65°C and wait 5 minutes for this to finish.
Use the save macro to apply the settings on restart.

## 13. HOTEND PID

Start HOTEND PID and save the configuration:
From the Dashboard, run the HOTEND 220 PID macro

![Calibration](/img/Printers/Prusa/Mk3/Calibration01.png)

Your nozzle will heat up several times to 220°C and wait 5 minutes for this to finish.
Use the save macro to apply the settings on restart.

## 14. Print

I recommend starting with a calibration cube. 

https://www.thingiverse.com/thing:1278865

Once you've got a perfect cube, you can start printing