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
