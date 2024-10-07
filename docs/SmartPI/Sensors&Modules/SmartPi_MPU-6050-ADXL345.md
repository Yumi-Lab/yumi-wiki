# How to Test the MPU-6050 and ADXL345 Sensors on Smart Pi One (Python and C)

This guide explains how to connect and test the **MPU-6050** and **ADXL345** sensors with the **Smart Pi One** board using both Python (via the `smartpi-mpu6050` package) and C. It also covers how to detect the sensors via I2C.

## Prerequisites

### Hardware
- **Smart Pi One** board
- Jumper wires for connections
- **MPU-6050** sensor and/or **ADXL345** sensor

### Software
- Python 3.6 or higher
- `smartpi-mpu6050` Python package
- I2C enabled on the Smart Pi One
- `python3-smbus` system library for I2C communication
- `libi2c-dev` package for C development

## Activating I2C on Smart Pi One (for MPU-6050 and ADXL345)

Before starting with sensor tests, ensure that **I2C** is enabled on the Smart Pi One. Follow these steps:

1. Open **Armbian-Config** via an SSH interface or terminal window:

    ```bash
    sudo armbian-config
    ```

2. Choose **System**:

    ![Smart Pi One - System](../../../img/SmartPi/Sensors&Modules/SmartPi_MPU-6050-ADXL345/SmartPi_MPU-6050_ADXL345_3.png)

3. Select **Hardware**:

    ![Smart Pi One - Hardware](../../../img/SmartPi/Sensors&Modules/SmartPi_MPU-6050-ADXL345/SmartPi_MPU-6050_ADXL345_4.png)

4. Enable **i2c1**, then **Save** and **Back**:

    ![Smart Pi One - Enable I2C](../../../img/SmartPi/Sensors&Modules/SmartPi_MPU-6050-ADXL345/SmartPi_MPU-6050_ADXL345_5.png)


5. To finish, **Reboot** to apply the changes:

    ![Smart Pi One - Reboot](../../../img/SmartPi/Sensors&Modules/SmartPi_MPU-6050-ADXL345/SmartPi_MPU-6050_ADXL345_6.png)


## How to Test the MPU-6050 Sensor

![MPU-6050](../../../img/SmartPi/Sensors&Modules/SmartPi_MPU-6050-ADXL345/SmartPi_MPU-6050_ADXL345_1.png)

### Wiring Diagram

Connect the **MPU-6050** sensor to the **Smart Pi One** using this setup:

| MPU-6050 Pin | Smart Pi One Pin     | Description  |
|--------------|----------------------|--------------|
| VCC          | (**1**) 3.3V             | Power        |
| GND          | (**6**) GND              | Ground       |
| SCL          | (**27**) SCL (I2C1 Clock)| I2C Clock    |
| SDA          | (**28**) SDA (I2C1 Data) | I2C Data     |

<img src="../../../img/SmartPi/Sensors&Modules/SmartPi_MPU-6050-ADXL345/SmartPi_MPU-6050_ADXL345_2.png" width="500" alt="Smart Pi One - MPU-6050 Wiring">

### 1. Detecting the MPU-6050 Using I2C

Run the following steps to verify that the MPU-6050 sensor is detected:

1. Enable I2C using the steps mentioned above.

2. Check for sensor detection with this command:

    ```bash
    sudo i2cdetect -y 1
    ```

    You should see the MPU-6050 detected at address `0x68`.

    ![MPU-6050](../../../img/SmartPi/Sensors&Modules/SmartPi_MPU-6050-ADXL345/SmartPi_MPU-6050_ADXL345_7.png)

### 2. Using Python to Read MPU-6050 Data

#### Prerequisites

Install the required system libraries for I2C communication:

    ```bash
    sudo apt-get update
    sudo apt-get install python3-smbus
    ```

Install the Python package:

    ```bash
    sudo pip3 install smartpi-mpu6050
    ```

#### Python Script for Testing MPU-6050:

Create a Python file named `test_mpu6050.py` and add the following code:

```bash
nano test_mpu6050.py
```

Paste the code below into the file:

```python
from smartpi_mpu6050.mpu6050 import MPU6050

mpu = MPU6050(0x68)

temp = mpu.get_temp()
print(f"Temperature: {temp:.2f} °C")

accel_data = mpu.get_accel_data()
print(f"Accelerometer: X={accel_data['x']:.2f} m/s^2, Y={accel_data['y']:.2f} m/s^2, Z={accel_data['z']:.2f} m/s^2")

gyro_data = mpu.get_gyro_data()
print(f"Gyroscope: X={gyro_data['x']:.2f} °/s, Y={gyro_data['y']:.2f} °/s, Z={gyro_data['z']:.2f} °/s")
```

### Running the Python Script

1. Create a new Python file test_mpu6050.py and paste the code above.

    
    ```bash
    nano test_mpu6050.py
    ```

    ![Smart Pi One - nano](../../../img/SmartPi/Sensors&Modules/SmartPi_MPU-6050-ADXL345/SmartPi_MPU-6050_ADXL345_8.png)

2. Save the script, then run it with the necessary permissions (you may need to use sudo):

    ```bash
    sudo python3 test_mpu6050.py
    ```

    You should see the temperature, accelerometer, and gyroscope data in the terminal.

    ![Smart Pi One - nano](../../../img/SmartPi/Sensors&Modules/SmartPi_MPU-6050-ADXL345/SmartPi_MPU-6050_ADXL345_9.png)



### 3. Using a C Program to Read MPU-6050 Data

#### Prerequisites

Install the required I2C development library:

```bash
sudo apt-get install libi2c-dev
```

#### Example C Program

Create a C file named `test_mpu6050.c` and add the following code:

```bash
nano test_mpu6050.c
```

Paste the code below into the file:

```c
#include <stdio.h>
#include <linux/i2c-dev.h>
#include <i2c/smbus.h>  
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

    i2c_smbus_write_byte_data(fd, PWR_MGMT_1, 0x00);

    int accel_x = read_word_2c(fd, ACCEL_XOUT0);
    int accel_y = read_word_2c(fd, ACCEL_XOUT0 + 2);
    int accel_z = read_word_2c(fd, ACCEL_XOUT0 + 4);

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
    nano test_mpu6050.c
    ```

2. Save the C program, then compile it using gcc:

    
    ```bash
    gcc -o test_mpu6050 test_mpu6050.c -li2c
    ```

3. Run the program:

    
    ```bash
    ./test_mpu6050
    ```

    You should see the temperature and accelerometer data printed to the terminal.

    ![Smart Pi One - Create file](../../../img/SmartPi/Sensors&Modules/SmartPi_MPU-6050-ADXL345/SmartPi_MPU-6050_ADXL345_10.png)


## How to Test the ADXL345 Sensor

![ADXL345](../../../img/SmartPi/Sensors&Modules/SmartPi_MPU-6050-ADXL345/SmartPi_MPU-6050_ADXL345_11.png)

### Wiring Diagram

Connect the **ADXL345** sensor to the **Smart Pi One** using this setup:

| ADXL345 Pin | Smart Pi One Pin     | Description  |
|-------------|----------------------|--------------|
| VCC         | (**1**) 3.3V             | Power        |
| GND         | (**6**)                  | Ground       |
| SCL         | (**27**) SCL (I2C1 Clock)| I2C Clock    |
| SDA         | (**28**) SDA (I2C1 Data) | I2C Data     |

<img src="../../../img/SmartPi/Sensors&Modules/SmartPi_MPU-6050-ADXL345/SmartPi_MPU-6050_ADXL345_12.png" width="500" alt="Smart Pi One - ADXL345 Wiring">

### 1. Detecting the ADXL345 Using I2C

Run the following steps to verify that the ADXL345 sensor is detected:

1. Enable I2C using the steps mentioned above.

2. Check for sensor detection with this command:

    ```bash
    sudo i2cdetect -y 1
    ```

    You should see the ADXL345 detected at address `0x53`.

    ![MPU-6050](../../../img/SmartPi/Sensors&Modules/SmartPi_MPU-6050-ADXL345/SmartPi_MPU-6050_ADXL345_13.png)

### 2. Using Python to Read ADXL345 Data

![Smart Pi One - nano](../../../img/SmartPi/Sensors&Modules/SmartPi_MPU-6050-ADXL345/SmartPi_MPU-6050_ADXL345_11.png)


#### Prerequisites

Install the required system libraries for I2C communication:

```bash
sudo apt-get update
sudo apt-get install python3-smbus
```

Install the Python package:

```bash
sudo pip3 install smartpi-mpu6050
```

#### Python Script for Testing ADXL345

Create a Python file named `test_adxl345.py` and add the following code:

```bash
nano test_adxl345.py
```

Paste the code below into the file:

```python
from smartpi_mpu6050.mpu6050 import MPU6050

mpu = MPU6050(0x53)

accel_data = mpu.get_accel_data()
print(f"Accelerometer: X={accel_data['x']:.2f} m/s^2, Y={accel_data['y']:.2f} m/s^2, Z={accel_data['z']:.2f} m/s^2")
```

### Running the Python Script

1. Create a new Python file `test_adxl345.py` and paste the code above.

    ```bash
    nano test_adxl345.py
    ```


2. Save the script, then run it with the necessary permissions (you may need to use sudo):

    ```bash
    sudo python3 test_adxl345.py
    ```

    You should see the accelerometer data printed in the terminal.

    ![Smart Pi One - nano](../../../img/SmartPi/Sensors&Modules/SmartPi_MPU-6050-ADXL345/SmartPi_MPU-6050_ADXL345_15.png)

---

### 3. Using a C Program to Read ADXL345 Data

#### Prerequisites

Install the required I2C development library:

```bash
sudo apt-get install libi2c-dev
```

#### Example C Program

Create a C file named `test_adxl345.c` and add the following code:

```bash
nano test_adxl345.c
```

Paste the code below into the file:

```c
#include <stdio.h>
#include <linux/i2c-dev.h>
#include <i2c/smbus.h>
#include <sys/ioctl.h>
#include <fcntl.h>
#include <unistd.h>

#define ADXL345_ADDR 0x53
#define POWER_CTL     0x2D
#define DATA_FORMAT   0x31
#define DATAX0       0x32

int read_word_2c(int fd, int reg) {
    int low = i2c_smbus_read_byte_data(fd, reg);
    int high = i2c_smbus_read_byte_data(fd, reg + 1);
    int val = (high << 8) + low;
    return val;
}

int main() {
    int fd;
    char *filename = (char*)"/dev/i2c-1";

    if ((fd = open(filename, O_RDWR)) < 0) {
        printf("Failed to open the i2c bus\n");
        return 1;
    }

    if (ioctl(fd, I2C_SLAVE, ADXL345_ADDR) < 0) {
        printf("Failed to acquire bus access and/or talk to slave\n");
        return 1;
    }

    i2c_smbus_write_byte_data(fd, POWER_CTL, 0x08);  // Set the device to measure mode
    i2c_smbus_write_byte_data(fd, DATA_FORMAT, 0x00); // Set the range to +/- 2g

    int accel_x = read_word_2c(fd, DATAX0);
    int accel_y = read_word_2c(fd, DATAX0 + 2);
    int accel_z = read_word_2c(fd, DATAX0 + 4);

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

    You should see the accelerometer data printed in the terminal.

    ![Smart Pi One - Create file](../../../img/SmartPi/Sensors&Modules/SmartPi_MPU-6050-ADXL345/SmartPi_MPU-6050_ADXL345_16.png)

