# 1.4 Change timezone

# Hardware and software :

MobaXterm https://mobaxterm.mobatek.net/download-home-edition.html

Pronterface https://github.com/kliment/Printrun/releases/tag/printrun-2.0.1 

# SSH connection

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

The Pad Wanhao username is `pi` and the password is `fun`.

A certificate authorization may appear. You need to validate it.
Once you're logged in, you'll see this screen:

![ConnectPi](/img/Printers/Artillery/X2/ConnectPI.png)

run the following command:

```
sudo armbian-config
```

Use the arrow keys to go to Personnal and confirm by pressing `Enter`.

![TimeZone](/img/SmartPi/TimeZone/Timezone001.png)

Use the arrow keys to go to TimeZone and press "Enter" to confirm.

![TimeZone](/img/SmartPi/TimeZone/Timezone002.png)

Use the arrows to select your zone and press `Enter` to confirm.

![TimeZone](/img/SmartPi/TimeZone/Timezone003.png)

Select your reference city using the arrows and press Enter to confirm.

![TimeZone](/img/SmartPi/TimeZone/Timezone004.png)

You can exit the SSH connection - the card is now on time