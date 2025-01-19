# 2.3 Activating a Relay on Smart Pi One

This page describes how to activate a relay using the Smart Pi One, with detailed steps, wiring instructions, and code examples in both Python and C.

![RELAY 5V](/img/SmartPi/Sensors&Modules/SmartPi_Relay_Control/SmartPi_Relay_Control_1.png)


## Required Materials

- Smart Pi One
- Relay module (with optoisolator recommended)
- Connecting wires
- Breadboard (optional for easier connections)


## Wiring Diagram

Below is a sample wiring diagram for connecting a relay module to the Smart Pi One:

<img src="../../../img/SmartPi/Sensors&Modules/SmartPi_Relay_Control/SmartPi_Relay_Control_2.png" width="520" alt="Relay Wiring Diagram">

| **Pin Number** | **Pin Name**          | **Function**           |
|----------------|-----------------------|------------------------|
| 2             | 5V                  | Power Supply            |
| 7              | GPIOG11               | Signal           |
| 6              | GND               | GROUND           |

### Connecting the Relay

1. **Connect the Relay:**
   - Connect the input pin of the relay module (IN) to a GPIO pin on the Smart Pi One (**GPIO7**/**PIN: 7**).
   - Connect the VCC pin of the relay module to the (**5V**/**PIN:2**) on the Smart Pi One.
   - Connect the GND pin of the relay module to the ground (**GND**/**PIN:3**) pin on the Smart Pi One.

2. **Connect the Load:**
   - Connect the device you want to control (e.g., a lamp) to the relay's output terminals. Ensure proper electrical connections are made according to the relay's specifications.

## Prerequisites: Configuration of smartpi-gpio

To install **SmartPi-GPIO** on your Smart Pi One, follow these steps:

1. **Update system**:

   ```bash
   sudo apt update 
   sudo apt-get install -y python3-dev python3-pip libjpeg-dev zlib1g-dev libtiff-dev
   sudo mv /usr/lib/python3.11/EXTERNALLY-MANAGED /usr/lib/python3.11/EXTERNALLY-MANAGED.old
   ```

2. **Clone the repository**:

   ```bash
   git clone https://github.com/ADNroboticsfr/smartpi-gpio.git
   cd smartpi-gpio
   ```

3. **Install the library**:

   ```bash
   sudo python3 setup.py sdist bdist_wheel
   sudo pip3 install dist/smartpi_gpio-1.0.0-py3-none-any.whl
   ```

4. **Activate GPIO interfaces**:

   ```bash
   sudo activate_interfaces.sh
   ``` 

   ![Smart Pi One - Button](/img/SmartPi/Sensors&Modules/SmartPi_Button_Control/SmartPi_Button_Control_3.png)   

## Turning on a RELAY via Command Line (CLI)

### Step 1: Turn on the RELAY

To turn on the RELAY on GPIO 7:

```bash
sudo gpio 7 mode out
sudo gpio 7 write 1
```
![Smart Pi One - Button](/img/SmartPi/Sensors&Modules/SmartPi_Relay_Control/SmartPi_Relay_Control_3.png)   

### Step 2: Turn off the RELAY

To turn off the RELAY:

```bash
sudo gpio 7 write 0
```

![Smart Pi One - Button](/img/SmartPi/Sensors&Modules/SmartPi_Relay_Control/SmartPi_Relay_Control_4.png)   

## Using Python

## Creating the Python Script

1. Open a terminal on your Smart Pi One.
2. Create a new Python file using `nano`:

   ```bash
   nano relay_control.py
   ```

3. Copy and paste the following Python code into the file:

   ```python
   import time
   from smartpi_gpio.gpio import GPIO

   # Initialize GPIO
   gpio = GPIO()

   # Set GPIO7 as output for the relay
   gpio.setup(7, gpio.OUT)

   try:
       while True:
           # Activate the relay (turn on)
           gpio.output(7, gpio.HIGH)
           print("Relay is ON")
           time.sleep(2)  # Keep it on for 2 seconds
           
           # Deactivate the relay (turn off)
           gpio.output(7, gpio.LOW)
           print("Relay is OFF")
           time.sleep(2)  # Keep it off for 2 seconds
   except KeyboardInterrupt:
       pass
   finally:
       gpio.cleanup()  # Clean up GPIO
   ```

4. Save the file by pressing `CTRL + X`, then `Y`, and finally `Enter`.

## Running the Python Script

To run the Python script, use the following command:

```bash
sudo python3 relay_control.py
```

![Smart Pi One - Button](/img/SmartPi/Sensors&Modules/SmartPi_Relay_Control/SmartPi_Relay_Control_5.png)   
