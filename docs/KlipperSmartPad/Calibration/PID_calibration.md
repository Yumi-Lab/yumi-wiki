# 2.3 PID calibration

The calibration of the PID (Proportional-Integral-Derivative) on Klipper, a firmware used to control 3D printers, is crucial for ensuring precise temperature regulation of the extruder and the heated bed. 

# 2.3.1 Purpose of PID Calibration

Here are the primary purposes and benefits of this calibration.

**Temperature Stability**:
   PID calibration helps maintain a stable temperature of the extruder and heated bed. A stable temperature is essential for high-quality 3D prints, as temperature fluctuations can lead to defects in the printed layers.

**Response Accuracy**:
   With proper PID calibration, the printer can reach the desired temperature more quickly and with fewer oscillations around that temperature. This reduces preheating time and improves the overall efficiency of the printer.

**Preventing Overshooting**:
   A poorly calibrated PID can result in overshooting, where the temperature repeatedly exceeds and falls below the target value. This can damage the printer components or affect print quality. PID calibration minimizes these oscillations.

**Consistent Print Quality**:
   Well-regulated temperature ensures consistent print quality. Printing materials like PLA, ABS, and PETG have optimal temperature ranges, and maintaining these temperatures precisely ensures consistent results.



# 2.3.2 Calibrating PID settings for the extruder

1. Open the Printer’s Terminal and access your printer's terminal via your control interface (such as Mainsail: **http://yumios.local** or **http://Your_IP_Address**).

   ![smartpad_pid_1](../img/KlipperSmartPad/PID_calibration/smartpad_pid_1.png)
   
2. In the console, input the following command for the calibration:

     ```sh
     PID_CALIBRATE HEATER=extruder TARGET=200
     ```
     Replace **`200`** with the desired target temperature.

     ![smartpad_pid_2](../img/KlipperSmartPad/PID_calibration/smartpad_pid_2.png)

3. The calibration process may take several minutes. Klipper will heat and cool the extruder or bed multiple times to determine the optimal PID parameters.

   ![smartpad_pid_3](../img/KlipperSmartPad/PID_calibration/smartpad_pid_3.png)

4. Once the calibration is complete, Klipper will display the new PID parameters (P, I, D). Save them using the command:

     ```sh
     SAVE_CONFIG
     ```

     ![smartpad_pid_4](../img/KlipperSmartPad/PID_calibration/smartpad_pid_4.png)

# 2.3.2 Calibrating PID settings for the heated bed

1. In the console, input the following command for the calibration:

     ```sh
     PID_CALIBRATE HEATER=heater_bed TARGET=60
     ```
     Replace **`60`** with the desired target temperature.

     ![smartpad_pid_5](../img/KlipperSmartPad/PID_calibration/smartpad_pid_5.png)

2. The calibration process may take several minutes. Klipper will heat and cool the extruder or bed multiple times to determine the optimal PID parameters.

   ![smartpad_pid_6](../img/KlipperSmartPad/PID_calibration/smartpad_pid_6.png)

3. Once the calibration is complete, Klipper will display the new PID parameters (P, I, D). Save them using the command:

     ```sh
     SAVE_CONFIG
     ```

    ![smartpad_pid_7](../img/KlipperSmartPad/PID_calibration/smartpad_pid_4.png)

