# 2.3 Home Assistant

<p align="center">
<img src="https://design.home-assistant.io/images/brand/logo.png" style="width:50%" >
</p>

# Installation

Download Balena Etcher: https://etcher.balena.io/#download-etcher

Download Home Assistant image and unzip it: https://github.com/Maxime3d77/smartpad-home-assistant/releases

Start Balena Etcher

Select your img file:
<p align="center">
<img src="https://github.com/Maxime3d77/smartpad-home-assistant/blob/main/img/Balena001.png?raw=true" style="width:50%" >
</p>

Select you sd support:
<p align="center">
<img src="https://github.com/Maxime3d77/smartpad-home-assistant/blob/main/img/balena002.png?raw=true" style="width:50%" >
</p>
<p align="center">
<img src="https://github.com/Maxime3d77/smartpad-home-assistant/blob/main/img/balena003.png?raw=true" style="width:50%" >
</p>

Flash SD:
<p align="center">
<img src="https://github.com/Maxime3d77/smartpad-home-assistant/blob/main/img/balena004.png?raw=true" style="width:50%" >
</p>

# Wifi

with a keyboard and screen, connect to the smartpad.
Attention QWERTY keyboard
User: pi
Password: yumi

run the command:

sudo armbian-config

using the arrows on your keyboard, go to Network confirm with Enter
Then go to Wifi

Select your wifi and type your password.
Exit the menu

Use the command to retrieve the IP address:
sudo ip a




# Connexion

Now connect to the Home Assistant interface using a browser:

http://Your_IP:8123


<p align="center">
<img src="https://github.com/Maxime3d77/smartpad-home-assistant/blob/main/img/HA001.png?raw=true" style="width:50%" >
</p>