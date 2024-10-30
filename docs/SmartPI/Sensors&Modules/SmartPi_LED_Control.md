# Controlling an LED via GPIO on Smart Pi One

This page describes how to control an LED using GPIO on the Smart Pi One, with detailed steps, wiring instructions, a wiring diagram, and code examples in both Python and C.

![Smart Pi One - LED](../../../img/SmartPi/Sensors&Modules/SmartPi_LED_Control/SmartPi_LED_Control_1.png)

## Required Materials

- Smart Pi One
- LED (with resistor around 220Ω to 1kΩ if necessary)
- Connecting wires
- Breadboard (optional for easier connections)


## Wiring Diagram

Below is the wiring diagram for connecting an LED to GPIO on the Smart Pi One

<img src="../../../img/SmartPi/Sensors&Modules/SmartPi_LED_Control/SmartPi_LED_Control_3.png" width="520" alt="LED Wiring Diagram">

## Connecting the LED

<img src="../../../img/SmartPi/Sensors&Modules/SmartPi_LED_Control/SmartPi_LED_Control_2.png" width="140" alt="LED Wiring Diagram">

**Connect the LED:**
   - Connect the longer leg of the LED (**anode**) to GPIO (**GPIOG11**/**PIN: 7**).
   - Connect the shorter leg of the LED (**cathode**) to ground (**GND**/**PIN:9**).
   - If necessary, place a resistor in series with the LED to limit the current (**typically around 220Ω to 1kΩ**).

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

   ![Smart Pi One - LED](../../../img/SmartPi/Sensors&Modules/SmartPi_Button_Control/SmartPi_Button_Control_3.png)


## Turning on an LED via Command Line (CLI)

### Step 1: Turn on the LED

To turn on the LED on GPIO 7:

```bash
sudo gpio 7 mode out
sudo gpio 7 write 1
```

![Smart Pi One - LED](../../../img/SmartPi/Sensors&Modules/SmartPi_LED_Control/SmartPi_LED_Control_4.png)

### Step 2: Turn off the LED

To turn off the LED:

```bash
sudo gpio 7 write 0
```

![Smart Pi One - LED](../../../img/SmartPi/Sensors&Modules/SmartPi_LED_Control/SmartPi_LED_Control_5.png)

## Using Python

## Creating the Python Script

1. Open a terminal on your Smart Pi One.
2. Create a new Python file using `nano`:

   ```bash
   nano led_control.py
   ```

3. Copy and paste the following Python code into the file:

   ```python
   import time
   from smartpi_gpio.gpio import GPIO

   # Initialize GPIO
   gpio = GPIO()

   # Set GPIO7 as output for the LED
   gpio.setup(7, gpio.OUT)

   try:
       while True:
           # Turn on the LED
           gpio.output(7, gpio.HIGH)
           print("LED is ON")
           time.sleep(2)  # Keep it on for 2 seconds
           
           # Turn off the LED
           gpio.output(7, gpio.LOW)
           print("LED is OFF")
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
sudo python3 led_control.py
```

![Smart Pi One - LED](../../../img/SmartPi/Sensors&Modules/SmartPi_LED_Control/SmartPi_LED_Control_6.png)
