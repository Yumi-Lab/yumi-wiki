# How to Test the ADX345 Sensor on Smart Pi One (Python and C)

This guide explains how to connect and test the **ADXL345** accelerometer and gyroscope sensor with the **Smart Pi One** board using both Python (`smartpi-mpu6050` package) and C. It also covers how to detect the sensor via I2C.

![Smart Pi One - ADXL345](../../../img/SmartPi/Sensors&Modules/SmartPi_ADXL345/SmartPi_ADXL345_1.png)

The **ADXL345** is a 6-axis motion tracking device that provides accelerometer and gyroscope data, making it useful for projects requiring motion sensing, orientation detection, and balance control.

## Prerequisites

### Hardware
- Smart Pi One board (Yumi)
- ADXL345 sensor
- Jumper wires for connections

### Software
- Python 3.6 or higher
- `smartpi-mpu6050` Python package
- I2C enabled on Smart Pi One
- `python3-smbus` installed (system library for I2C communication)
- `libi2c-dev` package for C development

## Wiring Diagram

To connect the ADXL345 sensor to the Smart Pi One, follow this wiring setup:

| ADXL345 Pin | Smart Pi One Pin     | Description  |
|--------------|----------------------|--------------|
| VCC          | (1) 3.3V             | Power        |
| GND          | (6) GND              | Ground       |
| SCL          | (27) SCL (I2C1 Clock)| I2C Clock    |
| SDA          | (28) SDA (I2C1 Data) | I2C Data     |

<img src="../../../img/SmartPi/Sensors&Modules/SmartPi_ADXL345/SmartPi_ADXL345_2.png" width="500" alt="Smart Pi One - ADXL345">

## 1. Detecting the ADXL345 Using I2C

Before you begin programming, you need to verify that the ADXL345 sensor is connected correctly and can be detected via I2C.

### Enable I2C on the Smart Pi One

1. Open Armbian-Config via an SSH interface or a terminal window:

```bash
sudo armbian-config
```

2. Choose **System**:

![Smart Pi One - ADXL345](../../../img/SmartPi/Sensors&Modules/SmartPi_ADXL345/SmartPi_ADXL345_3.png)

3. Select **Hardware**:

![Smart Pi One - ADXL345](../../../img/SmartPi/Sensors&Modules/SmartPi_ADXL345/SmartPi_ADXL345_4.png)

4. Enable **i2c1**, then **Save** and **Back**:

![Smart Pi One - ADXL345](../../../img/SmartPi/Sensors&Modules/SmartPi_ADXL345/SmartPi_ADXL345_5.png)

5. To finish, **Reboot** to apply the changes:

![Smart Pi One - ADXL345](../../../img/SmartPi/Sensors&Modules/SmartPi_ADXL345/SmartPi_ADXL345_6.png)

After enabling I2C, you can use the i2cdetect command to check if the sensor is connected and detect its address. Run the following command:

```bash
sudo i2cdetect -y 1
```

You should see an output similar to this:

![Smart Pi One - ADXL345](../../../img/SmartPi/Sensors&Modules/SmartPi_ADXL345/SmartPi_ADXL345_7.png)

In this case, the ADXL345 is detected at address 0x53. This confirms that the sensor is correctly connected and ready for use.

## 2. Using Python to Read ADXL345 Data

Before starting, make sure the I2C interface is enabled on your Smart Pi One as explained above.

### Prerequisites

Install the required system library for I2C communication:

```bash
sudo apt-get update
sudo apt-get install python3-smbus
```

Install the Python package:

```bash
sudo pip3 install smartpi-mpu6050
```

### Running the Test

After installation, use the following Python script to test your ADXL345 sensor. This script will print the temperature, accelerometer, and gyroscope data from the sensor.

### Example Python Script

Here’s a complete script to read MPU6050 data from the sensor:

```python
from smartpi_mpu6050.mpu6050 import MPU6050

# Initialize the ADXL345 sensor
mpu = MPU6050(0x53)

# Get temperature
temp = mpu.get_temp()
print(f"Temperature: {temp:.2f} °C")

# Get accelerometer data
accel_data = mpu.get_accel_data()
print(f"Accelerometer: X={accel_data['x']:.2f} m/s^2, Y={accel_data['y']:.2f} m/s^2, Z={accel_data['z']:.2f} m/s^2")

# Get gyroscope data
gyro_data = mpu.get_gyro_data()
print(f"Gyroscope: X={gyro_data['x']:.2f} °/s, Y={gyro_data['y']:.2f} °/s, Z={gyro_data['z']:.2f} °/s")
```

### Creating and Running the Script

1. Create a new Python file `test_adxl345.py` and paste the code above.

```bash
nano test_adxl345.py
```
![Smart Pi One - nano](../../../img/SmartPi/Sensors&Modules/SmartPi_ADXL345/SmartPi_ADXL345_8.png)

2. Save the script, then run it with the necessary permissions (you may need to use sudo):

```bash
sudo python3 test_adxl345.py
```

You should see output showing the temperature, accelerometer, and gyroscope data.

![Smart Pi One - nano](../../../img/SmartPi/Sensors&Modules/SmartPi_ADXL345/SmartPi_ADXL345_9.png)

## 3. Using a C Program to Read ADXL345 Data

### Prerequisites

Before compiling the C program, install the required I2C development package:

```bash
sudo apt-get install libi2c-dev
```

### Example C Program

Here’s the updated C program that includes the necessary headers for SMBus communication:

```c
#include <stdio.h>
#include <linux/i2c-dev.h>
#include <i2c/smbus.h>  // Include this header for SMBus functions
#include <sys/ioctl.h>
#include <fcntl.h>
#include <unistd.h>

#define MPU6050_ADDR 0x53
#define PWR_MGMT_1   0x6B
#define ACCEL_XOUT0  0x3B
#define TEMP_OUT0    0x41

int read_word_2c(int fd, int reg) {
    int high = i2c_smbus_read_byte_data(fd, reg);
    int low = i2c_smbus_read_byte_data(fd, reg + 1);
    int val = (high << 8) + low;
    if (val >= 0x8000) {
        val = -(65535 - val + 1);
    }
    return val;
}

int main() {
    int fd;
    char *filename = (char*)"/dev/i2c-1";

    if ((fd = open(filename, O_RDWR)) < 0) {
        printf("Failed to open the i2c bus\n");
        return 1;
    }

    if (ioctl(fd, I2C_SLAVE, MPU6050_ADDR) < 0) {
        printf("Failed to acquire bus access and/or talk to slave\n");
        return 1;
    }

    // Wake up the ADXL345
    i2c_smbus_write_byte_data(fd, PWR_MGMT_1, 0x00);

    // Read accelerometer data
    int accel_x = read_word_2c(fd, ACCEL_XOUT0);
    int accel_y = read_word_2c(fd, ACCEL_XOUT0 + 2);
    int accel_z = read_word_2c(fd, ACCEL_XOUT0 + 4);

    // Read temperature data
    int temp_raw = read_word_2c(fd, TEMP_OUT0);
    float temp = (temp_raw / 340.0) + 36.53;

    printf("Temperature: %.2f C\n", temp);
    printf("Accelerometer: X=%d Y=%d Z=%d\n", accel_x, accel_y, accel_z);

    close(fd);
    return 0;
}
```

### Compile and Run the Program

1. Open a text editor to create the C file:

```bash
nano test_adxl345.c
```

2. Save the C program, then compile it using gcc:

```bash
gcc -o test_adxl345 test_adxl345.c -li2c
```

3. Run the program:

```bash
./test_adxl345
```

You should see the temperature and accelerometer data printed to the terminal.

![Smart Pi One - nano](../../../img/SmartPi/Sensors&Modules/SmartPi_ADXL345/SmartPi_ADXL345_10.png)

## 4. Troubleshooting

### Common Issues:

1. **I2C Device Not Detected**
   - Ensure I2C is enabled on the Smart Pi One using `sudo armbian-config`.
   - Verify the connections of the SDA and SCL pins.
   - Use the following command to check if the ADXL345

 is detected:
     ```bash
     sudo i2cdetect -y 1
     ```
   - You should see the address `0x53` in the output.

2. **No Data from Sensor**
   - Ensure the correct I2C address (`0x53`) is being used in the code.
   - Check power and ground connections.

3. **Library Installation Issues**
   - Ensure that `python3-smbus` or `libi2c-dev` is installed, depending on the language you're using.

