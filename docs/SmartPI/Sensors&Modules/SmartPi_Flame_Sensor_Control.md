# Flame Presence Sensor with Smart Pi One

In this guide, we will demonstrate how to read the values from a flame presence sensor connected to the **Smart Pi One**, using the **SmartPi-GPIO** library.

![Smart Pi One - Flame Presence Sensor](../../../img/SmartPi/Sensors&Modules/SmartPi_Flame_Sensor_Control/SmartPi_Flame_Sensor_Control_1.png)

We will cover the following methods:
- **CLI commands**
- **Python script**
- **C program**

## Required Materials

- Smart Pi One
- Flame presence sensor (e.g., DFRobot DFR0090 or similar)
- Connecting wires
- Breadboard (optional for easier connections)

### Wiring Diagram

The flame presence sensor typically has three pins: **VCC**, **GND**, and **DOUT** (digital output).

- **VCC** connects to **3.3V (Pin 1)**.
- **GND** connects to **Ground (Pin 7)**.
- **DOUT** connects to **GPIO7 (Pin 7)** to read the presence of flame.

| **Pin Number** | **Pin Name**          | **Function**          |
|----------------|-----------------------|-----------------------|
| 1              | 3.3V                  | Power Supply          |
| 7              | GPIO7                 | Flame Sensor Output    |
| 7              | GND                   | Ground                |

<img src="../../../img/SmartPi/Sensors&Modules/SmartPi_Flame_Sensor_Control/SmartPi_Flame_Sensor_Control_2.png" width="520" alt="Flame Sensor Wiring Diagram">

## Reading Values via CLI

You can read the values from the flame presence sensor using the CLI.

### Steps:

1. **Configure the pin for digital input**:
   ```bash
   sudo gpio 7 mode in
   ```

2. **Read the value from the flame sensor**:
   ```bash
   sudo gpio read 7
   ```

3. **Example to read and display values continuously**:
   Use a loop to read the state of the flame sensor and print its value:
   ```bash
   while true; do
     value=$(sudo gpio read 7)
     echo "Flame Sensor Value: $value"
     sleep 1
   done
   ```

This will display the current value read by the flame sensor every second.

## Using Python

### Prerequisites: Configuration of smartpi-gpio

To install **SmartPi-GPIO** on your Smart Pi One, follow these steps:

1. **Update the system**:
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

## Reading Values with Python

With **SmartPi-GPIO** and Python, you can write a simple script to read the value from the flame presence sensor.

### Steps:

1. **Create a Python file**:
   ```bash
   nano flame_sensor_read.py
   ```

2. **Write the following code**:

   ```python
   from smartpi_gpio.gpio import GPIO
   import time

   # Initialize GPIO instance
   gpio = GPIO()

   # GPIO pin number for the flame sensor (GPIO7)
   flame_sensor_pin = 7

   # Configure the pin as input
   gpio.set_direction(flame_sensor_pin, "in")

   print("Reading values from the flame presence sensor...")

   while True:
       # Read the value from the flame sensor
       value = gpio.read(flame_sensor_pin)
       print(f"Flame Sensor Value: {value}")
       time.sleep(1)  # Read every second
   ```

3. **Save and exit** (`CTRL+X`, `Y`, and `Enter`).

4. **Run the Python script**:
   ```bash
   python3 flame_sensor_read.py
   ```

This will continuously display the current value read by the flame presence sensor every second.

## Displaying Values with a C Program

You can also read the values from the flame presence sensor using a C program and the **SmartPi-GPIO** library.

### Steps:

1. **Create a C file**:
   ```bash
   nano flame_sensor_read.c
   ```

2. **Write the following code**:

   ```c
   #include <stdio.h>
   #include <stdlib.h>
   #include "smartpi_gpio.h" // Include SmartPi-GPIO header

   int main() {
       // Initialize the GPIO library
       if (gpio_init() == -1) {
           printf("Failed to initialize GPIO.\n");
           return -1;
       }

       int flame_sensor_pin = 7; // GPIO7 (Pin 7)

       // Set the pin as input
       gpio_set_direction(flame_sensor_pin, GPIO_INPUT);

       printf("Reading values from the flame presence sensor...\n");

       while (1) {
           // Read the value from the flame sensor
           int value = gpio_read(flame_sensor_pin);
           printf("Flame Sensor Value: %d\n", value);

           // Small delay to prevent busy-waiting
           usleep(1000000); // 1 second
       }

       // Cleanup and close GPIO
       gpio_cleanup();

       return 0;
   }
   ```

3. **Save and exit** (`CTRL+X`, `Y`, and `Enter`).

4. **Compile the C program**:
   ```bash
   gcc -o flame_sensor_read flame_sensor_read.c -lsmartpi_gpio
   ```

5. **Run the program**:
   ```bash
   sudo ./flame_sensor_read
   ```

When you run the program, it will continuously display the current value read by the flame presence sensor every second.
