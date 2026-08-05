# Sound Detection Sensor with Smart Pi One

In this guide, we will demonstrate how to read values from a sound detection sensor connected to the **Smart Pi One**, using the **SmartPi-GPIO** library.

![Smart Pi One - Sound Detection Sensor](../../../img/SmartPi/Sensors&Modules/SmartPi_Sound_Detection_Control/SmartPi_Sound_Detection_Control_1.png)

We will cover the following methods:
- **CLI commands**
- **Python script**

## Required Materials

- Smart Pi One
- Sound detection sensor (e.g., LM393 or similar)
- Connecting wires
- Breadboard (optional for easier connections)

--8<-- "_snippets/smartpi-gpio-prerequisites.md"

### Wiring Diagram

The sound detection sensor typically has three pins: **VCC**, **GND**, and **DOUT** (digital output).

<img src="../../../img/SmartPi/Sensors&Modules/SmartPi_Sound_Detection_Control/SmartPi_Sound_Detection_Control_2.png" width="520" alt="Sound Detection Sensor Wiring Diagram">

- **VCC** connects to **3.3V (Pin 1)**.
- **GND** connects to **Ground (Pin 6)**.
- **DOUT** connects to **GPIO7 (Pin 7)** to read the sound detection signal.

| **Pin Number** | **Pin Name**          | **Function**          |
|----------------|-----------------------|-----------------------|
| 1              | 3.3V                  | Power Supply          |
| 7              | GPIO7                 | Sound Detection Output |
| 6              | GND                   | Ground                |

## Reading Values via CLI

You can read the values from the sound detection sensor using the CLI.

### Steps:

1. **Configure the pin for digital input**:
   ```bash
   sudo gpio 7 mode in
   ```

2. **Example to read and display values continuously**:
   Use a loop to read the state of the sound detection sensor and print a message when sound is detected:
   ```bash
   while true; do
     value=$(sudo gpio read 7)
     if [ "$value" -eq 1 ]; then
       echo "Sound Detected!"
     fi
     sleep 1
   done
   ```

This will display "Sound Detected!" when the sensor picks up sound.

## Reading Values with Python

With **SmartPi-GPIO** and Python, you can write a simple script to read the value from the sound detection sensor.

### Steps:

1. **Create a Python file**:
   ```bash
   nano sound_detection_read.py
   ```

2. **Write the following code**:

   ```python
   from smartpi_gpio.gpio import GPIO
   import time

   # Initialize GPIO instance
   gpio = GPIO()

   # GPIO pin number for the sound detection sensor (GPIO7)
   sound_sensor_pin = 7

   # Configure the pin as input
   gpio.set_direction(sound_sensor_pin, "in")

   print("Reading values from the sound detection sensor...")

   try:
       while True:
           # Read the value from the sound detection sensor
           value = gpio.read(sound_sensor_pin)
           if value == '1':  # Sound detected
               print("Sound Detected!")
           time.sleep(0.01)  # Read every second
   except KeyboardInterrupt:
       print("Exiting...")
   ```

3. **Save and exit** (`CTRL+X`, `Y`, and `Enter`).

4. **Run the Python script**:
   ```bash
   sudo python3 sound_detection_read.py
   ```

This will continuously display "Sound Detected!" when detection occurs.
