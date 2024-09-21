# 1.7 Basic Commands for Using the Smart Pi One Board

## Introduction
The **Smart Pi One** board runs on Debian with Armbian, a distribution optimized for Single Board Computers (SBCs). This guide provides essential commands to manage the board, focusing on GPIO control, network configuration, and basic system management.

## 1. System Update
Before configuring the board, it’s crucial to update the system for the latest security patches and package updates:
```bash
sudo apt update && sudo apt upgrade -y           
```

## 2. System Information
To check hardware specifications and active services on the Smart Pi One board, here are some useful commands:

- Check the Armbian version:
```bash
armbianmonitor -u
```

- Get information about the board and CPU:
```bash
cat /proc/cpuinfo
```

- Check available memory:
```bash
free -h
```

- Monitor disk usage:
```bash
df -h
```

## 3. GPIO Management with SmartPi-GPIO
The Smart Pi One board allows control of GPIO pins for connecting sensors, LEDs, etc. **SmartPi-GPIO** provides a Python-based interface to manage GPIO, PWM, and interrupts efficiently.

- Install SmartPi-GPIO (if not already installed):
```bash
pip3 install smartpi-gpio
```

- To view the available GPIO pins and their states:
```bash
gpio readall
```

- Configuring a GPIO pin as an output (e.g., GPIO 18):
```bash
gpio setmode 18 out
```

- Writing a high or low state to a GPIO pin:
```bash
gpio write 18 1  # Set pin 18 to HIGH
gpio write 18 0  # Set pin 18 to LOW
```

- Using PWM on a pin (e.g., GPIO 19):
```bash
gpio pwm 19 1000 50  # Set PWM frequency to 1 kHz and duty cycle to 50%
```


## 4. Enabling and Configuring I2C
I2C is used for connecting sensors and peripherals. To enable and configure I2C:

- Enable I2C:
```bash
sudo armbian-config
# Navigate to System > Hardware > Enable I2C
```

- Install I2C tools:
```bash
sudo apt install i2c-tools
```

- Scan connected I2C devices:
```bash
i2cdetect -y 1
```

## 5. Enabling and Configuring SPI
SPI is another interface used for fast communication with external devices.

- Enable SPI via Armbian Config:
```bash
sudo armbian-config
# Navigate to System > Hardware > Enable SPI
```

- Check SPI interface:
```bash
ls /dev/spidev*
```

## 6. Managing Services and Autostart
Armbian uses **systemd** to manage services. You can start, stop, and enable services at boot with the following commands:

- Check the status of a service (e.g., SSH):
```bash
sudo systemctl status ssh
```

- Start a service:
```bash
sudo systemctl start ssh
```

- Enable a service at boot:
```bash
sudo systemctl enable ssh
```

- Disable a service:
```bash
sudo systemctl disable ssh
```

## 7. Basic Network Configuration
For configuring Internet access or handling network settings, here are some basic commands:

- View network interfaces:
```bash
ip a
```

- Set a static IP address (edit configuration as needed):
```bash
sudo nano /etc/network/interfaces
```

- Restart the network after changes:
```bash
sudo systemctl restart networking
```

## 8. Managing Real-Time Clock (RTC)
To enable and configure an external RTC module:

- Load the RTC module:
```bash
sudo modprobe rtc-ds1307
```

- Synchronize the hardware clock with the system clock:
```bash
sudo hwclock -s
```

## 9. Modify a File
To edit a configuration file (e.g., using `nano`):
```bash
sudo nano /path/to/file
```
Replace `/path/to/file` with the actual path of the file you want to edit.


## 10. Shutdown and Reboot
To safely power off the Smart Pi One:
```bash
sudo shutdown now
```

To restart the Smart Pi One:
```bash
sudo reboot
```






