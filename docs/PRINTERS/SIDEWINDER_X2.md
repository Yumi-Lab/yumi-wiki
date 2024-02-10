# Klipper Sidewinder X2 installation

![Sidewinder X2](/img/Printers/Artillery/X2/X2.jpeg)

This procedure is for anyone who has a Sidewinder X2 and a SmartPad klipper control device.

## Please read the procedure first

You are responsible for all operations carried out on your equipment. This procedure explains how to set up klipper on your printer. It has been tested and is fully functional.

This procedure has been tested and approved for Ruby 1.2 motherboards. Do not install it on other motherboards.

# Hardware and software :

MobaXterm https://mobaxterm.mobatek.net/download-home-edition.html

Pronterface https://github.com/kliment/Printrun/releases/tag/printrun-2.0.1 

# Connection SSH

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

The Pad Wanhao username is "pi" and the password is "fun".

A certificate authorization may appear. You need to validate it.
Once you're logged in, you'll see this screen:

![ConnectPi](/img/Printers/Artillery/X2/ConnectPI.png)


# Generate firmware

The left sidebar corresponds to the Raspberry file and the right to the command line interface.

Issue the command `cd klipper` and confirm with Enter
```
cd klipper
```

![FW](/img/Printers/Artillery/X2/FW01.png)

Run the `make menuconfig` command and confirm with enter.
```
make menuconfig
```

![FW](/img/Printers/Artillery/X2/FW02.png)

You need to set the information below:
 
![FW](/img/Printers/Artillery/X2/FW03.png)

Use the arrow keys to move around and enter to confirm.
When ready, press q
Confirm with Y
 
![FW](/img/Printers/Artillery/X2/FW04.png)

Run the `make` command. This will generate the firmware.
```
make
```

#  Switch printer to DFU mode

We need to switch the printer to DFU mode in order to install the frmware.
To do this, you can install pronterface (link to start of tutorial) on your computer and connect it directly to the printer.
Open Pronterface (in administrator mode).

![Pronterface](/img/Printers/Artillery/X2/Pronterface01.png)

Connect the printer to the PC using the USB port and set 115200 baud.
Click on connect.

![Pronterface](/img/Printers/Artillery/X2/Pronterface02.png)

  Run the `M997` command
'''
M997
'''

  # Flashing with the SmartPad

Return to MobaXterm.
Connect the printer to the pad and run the `lsusb` command.
You should have a device in DFU mode.

![Flash](/img/Printers/Artillery/X2/FlashPrinter.png)

  Run the following command to flash the printer:
`make flash FLASH_DEVICE=0483:df11`

# Download configuration files

Download the Sidewinder X2 configuration files from the following link:

Printer.cfg: https://github.com/Yumi-Lab/yumi-wiki/blob/main/Klipper/Artillery/X2/printer.cfg
Macros.cfg: https://github.com/Yumi-Lab/yumi-wiki/blob/main/Klipper/Artillery/X2/macros.cfg

# Mainsail Web interface

You can connect to your Mainsail interface from a web browser with the address http://votre IP address.

Example: http://192.168.1.74

You should arrive on this page. The error is normal. We haven't finished the configuration.

![Mainsail](/img/Printers/Artillery/X2/Mainsail01.png)

 We're going to load the configuration files.

Unzip the zip containing the configuration files.

Go to the folder.

![Mainsail](/img/Printers/Artillery/X2/Mainsail02.png)

From the Mainsail interface, go to Machine (wrench icon)
Click on the button to load files

![Mainsail](/img/Printers/Artillery/X2/Mainsail03.png)

Select all configuration files and click Open. Your files will be uploaded to Mainsail.

![Mainsail](/img/Printers/Artillery/X2/Mainsail02.png)

Restart the Pad and connect the printer to it with the correct USB cable.

![Mainsail](/img/Printers/Artillery/X2/Mainsail04.png)

# Get your printer's USB ID

Connect your printer to one of the PAD's USB ports.

Connect via SSH with MobaXterm, then enter the following command to retrieve the USB serial from the motherboard:
'''
ls /dev/serial/by-id/*
'''
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

# Changer les paramètres de votre slicer
## CURA

From cura, go to Preference/Configure Cura...
In the new window, go to Printers and choose your X2 profile.
Click on Machine settings

![Slicer](/img/Printers/Artillery/X2/Slicer01.png)

In the Start Gcode section put:
`START_PRINT BED_TEMP={material_bed_temperature_layer_0} `
`EXTRUDER_TEMP={material_print_temperature_layer_0}`

Put in End Gcode:
`END_PRINT`

![Slicer](/img/Printers/Artillery/X2/Slicer02.png)

You need to install the Klipper Setting Plugin. 
To do this, please follow the steps below: https://github.com/jjgraphix/KlipperSettingsPlugin
Once installed, activate firmware retraction in the Klipper Settings section.

![Slicer](/img/Printers/Artillery/X2/Slicer03.png)

## PrusaSlicer

From your printer settings,
In the Start Gcode section, enter:
`START_PRINT BED_TEMP=[first_layer_bed_temperature]`
` EXTRUDER_TEMP=[first_layer_temperature]`

In the End Gcode section put:
`END_PRINT`

![Slicer](/img/Printers/Artillery/X2/Slicer04.png)

In the general section of your printer settings, activate firmware retraction.

# Calibrating your printer
## BED PID

Now it's time to set the PIDs and printer settings.

Start BED PID and save the configuration:
From the Dashboard, launch the BED PID 65 macro

![Calibration](/img/Printers/Artillery/X2/Calibration01.png)

Your tray will heat up several times to 65°C and wait 5 minutes for this to finish.
Use the save macro to apply the settings on restart.

## HOTEND PID

Start HOTEND PID and save the configuration:
From the Dashboard, run the HOTEND 220 PID macro

![Calibration](/img/Printers/Artillery/X2/Calibration01.png)

Your nozzle will heat up several times to 220°C and wait 5 minutes for this to finish.
Use the save macro to apply the settings on restart.

## Adjust Z-OFFSET

From the dashboard, switch to the Console section.

Run command `G28` to reposition the head on its point of origin.
You can execute the G28 command by clicking on the Home button.

![Calibration](/img/Printers/Artillery/X2/Calibration02.png)

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

![Calibration](/img/Printers/Artillery/X2/Calibration03.png)

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

![Calibration](/img/Printers/Artillery/X2/Calibration04.png)

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

# Activate Head LED

To activate the head LED, there are 2 macros LED OFF to turn it off and LED ON to turn it on. Click on one of these macros to turn it on or off.

![Calibration](/img/Printers/Artillery/X2/Calibration05.png)

# Print

I recommend starting with a calibration cube. 

https://www.thingiverse.com/thing:1278865

Once you've got a perfect cube, you can start printing 😉
