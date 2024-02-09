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

![FW](/img/Printers/Artillery/X2/FW01.png)

Run the `make menuconfig` command and confirm with enter.

![FW](/img/Printers/Artillery/X2/FW02.png)

You need to set the information below:
 
![FW](/img/Printers/Artillery/X2/FW03.png)

Use the arrow keys to move around and enter to confirm.
When ready, press q
Confirm with Y
 
![FW](/img/Printers/Artillery/X2/FW04.png)

Run the `make` command. This will generate the firmware.

#  Switch printer to DFU mode

We need to switch the printer to DFU mode in order to install the frmware.
To do this, you can install pronterface (link to start of tutorial) on your computer and connect it directly to the printer.
Open Pronterface (in administrator mode).

![Pronterface](/img/Printers/Artillery/X2/Pronterface01.png)

Connect the printer to the PC using the USB port and set 115200 baud.
Click on connect.

![Pronterface](/img/Printers/Artillery/X2/Pronterface02.png)

  Run the `M997` command

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
`ls /dev/serial/by-id/*`

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
