# Klipper Prusa Mk3 installation

![mk3](/img/Printers/Prusa/Mk3/Mk3.jpeg)

This procedure is for anyone who has a Prusa Mk3 and a SmartPad klipper control device.

## Please read the procedure first

You are responsible for all operations carried out on your equipment. This procedure explains how to set up klipper on your printer. It has been tested and is fully functional.

This procedure has been tested and approved for prusa mk3. Do not install it on other printers.


# Hardware and software :

MobaXterm https://mobaxterm.mobatek.net/download-home-edition.html

# Connection SSH

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

![MobaConnect](//img/Printers/Prusa/Mk3/MobaConnect.png)

You will be prompted to enter the password.

The Pad Wanhao username is "pi" and the password is "fun".

A certificate authorization may appear. You need to validate it.
Once you're logged in, you'll see this screen:

![ConnectPi](/img/Printers/Prusa/Mk3/ConnectPI.png)

# Generate firmware

The left sidebar corresponds to the Pad file and the right to the command line interface.

Issue the command 'cd klipper' and confirm with Enter

![FW](/img/Printers/Prusa/Mk3/fw1.png)

Run the 'make menuconfig' command and confirm with enter

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

# Firmware flash

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

# Download configuration files

You can download the Prusa configuration files from the following link:

Macro: Klipper\Prusa\Mk3\macros.cfg
Printer.cfg: Klipper\Prusa\Mk3\printer.cfg

# Mainsail Web interface

You can connect to your Mainsail interface from a web browser with the address http://votre IP address.

Example: http://192.168.1.74

You should arrive on this page. The error is normal. We haven't finished the configuration.

![Mainsail](/img/Printers/Prusa/Mk3/mainsail1.png)

We're going to load the configuration files.

Unzip the zip containing the configuration files.

Go to the folder.

![Mainsail](/img/Printers/Prusa/Mk3/mainsail2.png)

From the Mainsail interface, go to Machine (wrench icon)
Click on the button to load files

![Mainsail](/img/Printers/Prusa/Mk3/mainsail3.png)

Select all configuration files and click Open. Your files will be uploaded to Mainsail.

![Mainsail](/img/Printers/Prusa/Mk3/mainsail2.png)

Restart the Pad and connect the printer to it with the correct USB cable.

![Mainsail](/img/Printers/Prusa/Mk3/mainsail4.png)

From the Dashboard, you should be able to control your printer.

# Changer les paramètres de votre slicer
## CURA

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
END_PRINT
```

![Slicer](/img/Printers/Prusa/Mk3/Slicer02.png)

You need to install the Klipper Setting Plugin. 
To do this, please follow the steps below: https://github.com/jjgraphix/KlipperSettingsPlugin
Once installed, activate firmware retraction in the Klipper Settings section.

![Slicer](/img/Printers/Prusa/Mk3/Slicer03.png)

## PrusaSlicer

From your printer settings,
In the Start Gcode section, enter:
```
START_PRINT BED_TEMP=[first_layer_bed_temperature] EXTRUDER_TEMP=[first_layer_temperature]
```
In the End Gcode section put:
```
END_PRINT
```

![Slicer](/img/Printers/Prusa/Mk3/Slicer04.png)

In the general section of your printer settings, activate firmware retraction.

# Calibrating your printer
## BED PID

Now it's time to set the PIDs and printer settings.

Start BED PID and save the configuration:
From the Dashboard, launch the BED PID 65 macro

![Calibration](/img/Printers/Prusa/Mk3/Calibration01.png)

Your tray will heat up several times to 65°C and wait 5 minutes for this to finish.
Use the save macro to apply the settings on restart.

## HOTEND PID

Start HOTEND PID and save the configuration:
From the Dashboard, run the HOTEND 220 PID macro

![Calibration](/img/Printers/Prusa/Mk3/Calibration01.png)

Your nozzle will heat up several times to 220°C and wait 5 minutes for this to finish.
Use the save macro to apply the settings on restart.

## Adjust Z-OFFSET

From the dashboard, switch to the Console section.

Run command `G28` to reposition the head on its point of origin.
You can execute the G28 command by clicking on the Home button.

![Calibration](/img/Printers/Prusa/Mk3/Calibration02.png)

Run command
`G28`
`PROBE_CALIBRATE`

Carry out the calibration using the paper sheet.
Make sure the nozzle is clean and clear of any filament residue that could distort the measurements.
Now you need to set the Z position with the TESTZ command.
The principle is simple - you'll need to gradually lower your nozzle to perfectly adjust the height between your platen and the nozzle. Position a sheet of paper and use the following commands or the interface that has just appeared.

TESTZ Z=- to lower the nozzle
TESTZ Z=+ to raise the nozzle

Here's an example:
TESTZ Z=-10 lowers the nozzle by 10mm
TESTZ Z=-0.1 lowers nozzle by 0.1mm
TESTZ Z=-0.01 lowers the nozzle by 0.01mm
Try to be as precise as possible.

Once the head is correctly set, issue the ACCEPT command, then SAVE_CONFIG.
Mainsail will restart and your configuration will be saved.
Use the `G28` command to reposition the head to its original point.

# Extruder calibration

The configuration files I use are set up for my hardware. You need to set the parameters of your extruder.
Start by heating your nozzle to 220°C from the control panel.

![Calibration](/img/Printers/Prusa/Mk3/Calibration03.png)

At console level, run the following commands:
`M83` to reset the extruder
Mark your filament 10 cm and 12 cm from the extruder with a marker.

The aim is to ask the extruder to draw 10cm and check that the correct length has been drawn.
Once you're ready, run the command:
`G1 E100 F200`
Check that 10cm has been extruded.
If so, nothing to do.

If not, you'll need to change a parameter in your configuration file. The parameter to change is in printer.cfg.
Search in the extrude section and find the value rotation_distance.

![Calibration](/img/Printers/Prusa/Mk3/Calibration04.png)

The value entered must be replaced by the correct value.
To find the correct value, use the following formula:
("measured distance in mm" / "requested distance in mm") X "rotation_distance".

Example:
I had 9cm extruded and not 10cm
The current value of rotation_distance is 7.805
The formula will therefore be ("90" / "100") X "7.805" = 7.0245
The new value will be 7.0245
Click on SAVE and RESTART in the top right-hand corner to save the file.
Now your Pad and printer are ready to print.
You can slice a 3d model and import it into the G-Code File section.
You can now start printing from the Mainsail interface or from the touch screen.


# Print

I recommend starting with a calibration cube. 

https://www.thingiverse.com/thing:1278865

Once you've got a perfect cube, you can start printing 😉