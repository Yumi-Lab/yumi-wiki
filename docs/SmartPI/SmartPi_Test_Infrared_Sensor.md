# Testing and Using the Infrared Sensor on Smart Pi One

## Introduction
This guide explains how to activate and test the infrared sensor on the Smart Pi One board running Armbian. We will also see how to use this sensor with Python and a more engaging C program.

<img src="../../img/SmartPi/SmartPi_Test_Infrared_Sensor/SmartPi_Test_Infrared_Sensor_1.png" width="400" alt="Top view">

## Activating the Infrared Sensor

### Step 1: Activate in Armbian-Config
1. Open Armbian-Config:
   ```bash
   sudo armbian-config
   ```

2. Choose `System`:

    <img src="../../img/SmartPi/SmartPi_Test_Infrared_Sensor/SmartPi_Test_Infrared_Sensor_2.png" width="750" alt="Top view">

3. Select `Hardware`:

    <img src="../../img/SmartPi/SmartPi_Test_Infrared_Sensor/SmartPi_Test_Infrared_Sensor_3.png" width="750" alt="Top view">

4. Then `cir`,`save` and `back`:

    <img src="../../img/SmartPi/SmartPi_Test_Infrared_Sensor/SmartPi_Test_Infrared_Sensor_4.png" width="750" alt="Top view">

5. To finish: "reboot" to apply the changes:

    <img src="../../img/SmartPi/SmartPi_Test_Infrared_Sensor/SmartPi_Test_Infrared_Sensor_5.png" width="750" alt="Top view">



### Step 2: Install ir-keytable
Start by installing `ir-keytable`, a tool that allows you to manage the infrared sensor:

```bash
sudo apt-get install ir-keytable
```

### Step 3: Configure Infrared Protocols
To activate the infrared protocols, use the following command:

```bash
echo "+rc-5 +nec +rc-6 +jvc +sony +rc-5-sz +sanyo +sharp +mce_kbd +xmp" | sudo tee /sys/class/rc/rc0/protocols
```

## Testing the Infrared Sensor

To test the infrared sensor and verify that it is working correctly, run the following command:

```bash
ir-keytable -t
```
This command will display events when a button on the remote control is pressed. Press `CTRL-C` to stop the test.

## Using Python

### Prerequisites
Before starting, ensure you have installed the `python-evdev` module, which allows you to read events from input devices:

```bash
sudo apt-get install python3-evdev
```

### Example Python Script

Here’s a complete script to read infrared events from the sensor:

```python
import evdev
from evdev import InputDevice, categorize, ecodes

# Replace '/dev/input/eventX' with the correct path for your infrared sensor
device = InputDevice('/dev/input/eventX')

print("Waiting for infrared events. Press CTRL-C to quit.")

try:
    for event in device.read():
        if event.type == ecodes.EV_KEY:  # Check if the event is a key press
            key_event = categorize(event)
            if key_event.keystate == key_event.key_up:  # Only take key releases
                print(f"Key released: {key_event.keycode}")

except KeyboardInterrupt:
    print("\nScript stopped.")

except Exception as e:
    print(f"An error occurred: {e}")
```

### Running the Script
1. Save the script as `ir_event.py`.
2. Execute it with the necessary permissions (you may need to use `sudo`):
   ```bash
   sudo python3 ir_event.py
   ```

## Using a C Program

### Example C Program

Here’s a more engaging example in C that will listen for infrared events and print a message when specific keys are pressed:

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

int main() {
    char command[100];

    // Replace '/dev/input/eventX' with the correct path for your infrared sensor
    snprintf(command, sizeof(command), "ir-keytable -t");

    printf("Listening for infrared remote control events. Press CTRL-C to exit.\n");

    // Use a system call to execute ir-keytable in a loop
    while (1) {
        system(command);
        sleep(1);  // Add a small delay to avoid overwhelming the output
    }

    return 0;
}
```

### Compilation and Execution
1. Save the program as `ir_test.c`.
2. Compile it with:
   ```bash
   gcc -o ir_test ir_test.c
   ```
3. Run the program:
   ```bash
   ./ir_test
   ```

You now have all the information needed to activate, test, and use the infrared sensor on the Smart Pi One board. Whether using Python or C, you can easily interact with your remote control.

