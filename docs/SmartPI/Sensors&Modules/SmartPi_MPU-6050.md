# How to Test the MPU-6050 Sensor on Smart Pi One Using smartpi-mpu6050 (Python and C)

This guide explains how to connect and test the **MPU-6050** accelerometer and gyroscope sensor with the **Smart Pi One** board using both Python (`smartpi-mpu6050` package) and C. It also covers how to detect the sensor via I2C.

The **MPU-6050** is a 6-axis motion tracking device that provides accelerometer and gyroscope data, making it useful for projects requiring motion sensing, orientation detection, and balance control.

You will learn how to:
- Connect the MPU-6050 sensor to the Smart Pi One.
- Detect the MPU-6050 via I2C.
- Install and use the Python library `smartpi-mpu6050`.
- Test the sensor and retrieve data using Python and C.

## Prerequisites

### Hardware
- Smart Pi One board (Yumi Robotics)
- MPU-6050 sensor
- Jumper wires for connections
- Raspberry Pi (connected to Smart Pi One)

### Software
- Python 3.6 or higher
- `smartpi-mpu6050` Python package
- I2C enabled on Raspberry Pi
- `python3-smbus` installed (system library for I2C communication)
- `libi2c-dev` package for C development

## Wiring Diagram

To connect the MPU-6050 sensor to the Smart Pi One, follow this wiring setup:

| MPU-6050 Pin | Smart Pi One Pin | Description  |
|--------------|------------------|--------------|
| VCC          | 3.3V             | Power        |
| GND          | GND              | Ground       |
| SCL          | SCL (I2C1 Clock)  | I2C Clock    |
| SDA          | SDA (I2C1 Data)   | I2C Data     |

## Detecting the MPU-6050 Using I2C

Before you begin programming, you need to verify that the MPU-6050 sensor is connected correctly and can be detected via I2C.

### Step 1: Enable I2C on the Raspberry Pi

To enable I2C, run the following command:

```bash
sudo armbian-config

After enabling I2C, you can use the i2cdetect command to check if the sensor is connected and detect its address. Run the following command:

```bash
sudo i2cdetect -y 1
```

You should see an output similar to this:

```lua
     0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
00:          -- -- -- -- -- -- -- -- -- -- -- -- -- 
10: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
20: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
30: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
40: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
50: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
60: -- -- -- -- -- -- -- 68 -- -- -- -- -- -- -- -- 
70: -- -- -- -- -- -- -- --                        
```

In this case, the MPU-6050 is detected at address 0x68. This confirms that the sensor is correctly connected and ready for use.


#### 5. Installation (Python)

## Installation (Python)

Before starting, make sure the I2C interface is enabled on your Raspberry Pi as explained above.

### Step 1: Install python3-smbus
Install the required system library for I2C communication:

```bash
sudo apt-get update
sudo apt-get install python3-smbus
```

```bash
sudo pip3 install smartpi-mpu6050
```


#### 6. Running the Test (Python)

## Running the Test (Python)

After the installation, you can use the following Python script to test your MPU-6050 sensor. This script will print the temperature, accelerometer, and gyroscope data from the sensor.

### Test Script (Python)

```python
from smartpi_mpu6050.mpu6050 import MPU6050

# Initialize the MPU-6050 sensor
mpu = MPU6050(0x68)

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

# Step-by-Step Instructions

1. Create a new Python file test_mpu6050.py and paste the code above.

2. Run the Python script:

```bash
python3 test_mpu6050.py
```

3. You should see output showing the temperature, accelerometer, and gyroscope data.

## C Program to Read MPU-6050 Data

Create a C file test_mpu6050.c and add the following code:

```c
#include <stdio.h>
#include <linux/i2c-dev.h>
#include <sys/ioctl.h>
#include <fcntl.h>
#include <unistd.h>

#define MPU6050_ADDR 0x68
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

    // Wake up the MPU-6050
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

## Step 3: Compile and Run the Program
Compile the C program using gcc:

```bash
gcc -o test_mpu6050 test_mpu6050.c -li2c

```

Run the program:

```bash
./test_mpu6050

```

You should see the temperature and accelerometer data printed to the terminal.


#### 8. Troubleshooting

## Troubleshooting

### Common Issues:

1. **I2C Device Not Detected**
   - Ensure I2C is enabled on the Raspberry Pi using `sudo raspi-config`.
   - Verify the connections of the SDA and SCL pins.
   - Use the following command to check if the MPU-6050 is detected:
     ```bash
     sudo i2cdetect -y 1
     ```
   - You should see the address `0x68` in the output.

2. **No Data from Sensor**
   - Ensure the correct I2C address (`0x68`) is being used in the code.
   - Check power and ground connections.

3. **Library Installation Issues**
   - Ensure that `python3-smbus` or `libi2c-dev` is installed, depending on the language you're using.
