# Klipper Prusa Mk3 installation

![mk3](img\Printers\Prusa\Mk3\Mk3.jpeg)

This procedure is for anyone who has a Prusa Mk3 and a SmartPad klipper control device.

## Please read the procedure first

You are responsible for all operations carried out on your equipment. This procedure explains how to set up klipper on your printer. It has been tested and is fully functional.

This procedure has been tested and approved for prusa mk3. Do not install it on other printers.


# Hardware and software :

MobaXterm https://mobaxterm.mobatek.net/download-home-edition.html

# Connection SSH

Download and install MobaXterm.

Click on the Session icon

![Moba Session](img\Printers\Prusa\Mk3\MobaSession.png)

Select SSH

![SSH](img\Printers\Prusa\Mk3\MobaSSH.png)

Enter the raspberry's IP address and enter pi as the user name.
Follow this procedure to find the IP address: https://www.malekal.com/comment-faire-un-scan-ip-reseau-local-lan/
Or, on the Pad, go to Menu :

![Pad1](img\Printers\Prusa\Mk3\Pad1.jpeg)

Network:

![Pad1](img\Printers\Prusa\Mk3\Pad2.jpeg)

You will see your IP address

![Pad1](img\Printers\Prusa\Mk3\Pad3.jpeg)

![MobaConnect](/img\Printers\Prusa\Mk3\MobaConnect.png)

You will be prompted to enter the password.

The Pad Wanhao username is "pi" and the password is "fun".

A certificate authorization may appear. You need to validate it.
Once you're logged in, you'll see this screen:

![ConnectPi](img\Printers\Prusa\Mk3\ConnectPI.png)

# Generate firmware

The left sidebar corresponds to the Pad file and the right to the command line interface.

Issue the command 'cd klipper' and confirm with Enter

![FW](img\Printers\Prusa\Mk3\fw1.png)
![FW](img\Printers\Prusa\Mk3\fw2.png)
![FW](img\Printers\Prusa\Mk3\fw3.png)
![FW](img\Printers\Prusa\Mk3\fw4.png)