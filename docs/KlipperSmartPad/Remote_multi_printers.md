# 3.1 Remote multiple printers on one pad

You can control multiple pads with a single pad. This provides centralized control over all your printers.

# Mainsail method

Log in to your mainsail interface

Go to the `Machine` tab and edit the `klipperscreen.cfg` file

In this text file, you'll need to put the first line:


```
[main]
```

Now we need to add sections for each printer
`[printer Printer name]`
`moonraker_host: pad ip address`

In the following example, a smartpad is connected to a sidewinder x2 and a creality K1 Max.
The K1 Max uses a port to connect to mainsail, so you need to specify it with the additional line `moonraker_port: port number`

```
[main]

[printer Sidewinderx2]
moonraker_host: 192.168.1.35

[printer CrealityK1Max]
moonraker_host: 192.168.1.69
moonraker_port: 4409
```
Here's how it looks on the Pad
You can see the Sidewinder X2 and the Creality K1 Max.
![RemotePad](/img/KlipperSmartPad/RemotePads/20240222_170827.jpg)

From this screen I can control the X2 pad

![RemotePad](/img/KlipperSmartPad/RemotePads/20240222_170840.jpg)

Press this button to return to the printer list.

![RemotePad](/img/KlipperSmartPad/RemotePads/20240222_170841.jpg)

And now I control my Creality K1 Max

![RemotePad](/img/KlipperSmartPad/RemotePads/20240222_170854.jpg)

# SSH method

To do this, you need an ssh connection on the pad you'll be using to control other pads.

Once connected, you'll need to edit a text file.

```
nano cd ~/printer_data/config/KlipperScreen.conf
```

In this text file, you'll need to put the first line:


```
[main]
```

Now we need to add sections for each printer
`[printer Printer name]`
`moonraker_host: pad ip address`

In the following example, a smartpad is connected to a sidewinder x2 and a creality K1 Max.
The K1 Max uses a port to connect to mainsail, so you need to specify it with the additional line `moonraker_port: port number`

```
[main]

[printer Sidewinderx2]
moonraker_host: 192.168.1.35

[printer CrealityK1Max]
moonraker_host: 192.168.1.69
moonraker_port: 4409
```
Here's how it looks on the Pad
You can see the Sidewinder X2 and the Creality K1 Max.
![RemotePad](/img/KlipperSmartPad/RemotePads/20240222_170827.jpg)

From this screen I can control the X2 pad

![RemotePad](/img/KlipperSmartPad/RemotePads/20240222_170840.jpg)

Press this button to return to the printer list.

![RemotePad](/img/KlipperSmartPad/RemotePads/20240222_170841.jpg)

And now I control my Creality K1 Max

![RemotePad](/img/KlipperSmartPad/RemotePads/20240222_170854.jpg)