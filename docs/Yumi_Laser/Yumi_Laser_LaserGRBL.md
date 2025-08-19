# 1.5 LaserGRBL Setup and First Engraving

**LaserGRBL** is a free, open-source software designed to control GRBL-based laser engravers such as the YUMI Laser.  
This guide explains how to configure LaserGRBL for your model (L-A4 / L-A3 / L-A2), select the laser power module, and perform your first engraving.

<img src="../../img/Yumi_laser/Yumi_Laser_LaserGRBL/Yumi_Laser_LaserGRBL_01.png" width="600" alt="LaserGRBL Logo">

---

## 1. Install LaserGRBL

- Download LaserGRBL from the official website: [https://lasergrbl.com](https://lasergrbl.com)
- Install it on your Windows computer (LaserGRBL is Windows-only).

---

## 2. Connect Your YUMI Laser

1. Power on your YUMI Laser.
2. Connect it to your computer via **USB cable**.
3. Wait for Windows to recognize the device.

---

## 3. Configure LaserGRBL for Your Model

1. Open **LaserGRBL**.

<img src="../../img/Yumi_laser/Yumi_Laser_LaserGRBL/Yumi_Laser_LaserGRBL_02.png" width="600" alt="LaserGRBL Interface">

2. At the top left, select the correct **COM port** and **baud rate**:
   - **Baud rate**: `115200`
3. Click **Connect**.

<img src="../../img/Yumi_laser/Yumi_Laser_LaserGRBL/Yumi_Laser_LaserGRBL_03.gif" width="600" alt="LaserGRBL Interface">


4. Set the Work Area Size in **Grbl Configuration**

Open **Grbl Configuration** (`Grbl > Grbl Configuration`) and set the **work area size** according to your YUMI model.  

<img src="../../img/Yumi_laser/Yumi_Laser_LaserGRBL/Yumi_Laser_LaserGRBL_04.png" alt="LaserGRBL Configuration Interface">

You must adjust the following parameters:  

- **X-axis maximum travel**  
- **Y-axis maximum travel**  

After entering the correct values, click **Write** and then **Close**.  


#### Work Area Dimensions per Model

| Model | **X-axis (mm)** | **Y-axis (mm)** |
|-------|-----------------|-----------------|
| L-A4  | 210             | 297             |
| L-A3  | 420             | 297             |
| L-A2  | 420             | 594             |

<img src="../../img/Yumi_laser/Yumi_Laser_LaserGRBL/Yumi_Laser_LaserGRBL_05.png" alt="LaserGRBL Work Area Preview">


## 4. Set Laser Power

- In LaserGRBL, laser power is expressed as a percentage of the maximum PWM value.
- Recommended starting values per module:
  - **2.5W** → 10–40%
  - **5.5W** → 20–70%
  - **10W** → 30–90%
  - **20W** → 50–100%

> Always start low and increase gradually to avoid burning materials.

---

## 5. Load a Test File

1. Click **File** next to the **Open File** field and select a simple test file (`.nc`, `.svg`, or `.bmp`). 

<img src="../../img/Yumi_laser/Yumi_Laser_LaserGRBL/Yumi_Laser_LaserGRBL_06.png" alt="LaserGRBL Work Area Preview">

2. For images, use the **Import Raster Image** function.

<img src="../../img/Yumi_laser/Yumi_Laser_LaserGRBL/Yumi_Laser_LaserGRBL_07.png" alt="LaserGRBL Work Area Preview">

3. Adjust the **engraving method** (e.g., *Line to Line*, *Dithering*, etc.) according to your needs.  


---

## 6. Position & Focus the Laser


1. Move the laser head **manually** over the workpiece.  
2. Place the **fixed-focus spacer** (5 mm) on the surface. 

<img src="../../img/Yumi_laser/Yumi_Laser_LaserGRBL/Yumi_Laser_LaserGRBL_08.png" width="600"  alt="LaserGRBL Work Area Preview">

3. Loosen the fixing screws of the laser module.  

<img src="../../img/Yumi_laser/Yumi_Laser_LaserGRBL/Yumi_Laser_LaserGRBL_09.png" width="200"  alt="LaserGRBL Work Area Preview">

4. Slide the laser down until it touches the spacer.  
5. Remove the spacer and tighten the screws.  

<img src="../../img/Yumi_laser/Yumi_Laser_LaserGRBL/Yumi_Laser_LaserGRBL_10.png" width="250"  alt="LaserGRBL Work Area Preview">

---

## 7. Positioning the Workpiece

1. Click **Move to Center** → the laser moves to the center of the design.  
2. Click **Light Laser** → the laser emits a weak beam to show the engraving center. Adjust your material position if necessary.  

<img src="../../img/Yumi_laser/Yumi_Laser_LaserGRBL/Yumi_Laser_LaserGRBL_11.png" alt="LaserGRBL Work Area Preview">

<img src="../../img/Yumi_laser/Yumi_Laser_LaserGRBL/Yumi_Laser_LaserGRBL_12.gif" width="" alt="LaserGRBL Work Area Preview">

3. Click **Profile Scan** → the laser scans the outline of the design.  
   - Adjust the material again if needed.  
   - Use **Wrap Around** until the outline matches correctly.  

<img src="../../img/Yumi_laser/Yumi_Laser_LaserGRBL/Yumi_Laser_LaserGRBL_13.png" alt="LaserGRBL Work Area Preview">

<img src="../../img/Yumi_laser/Yumi_Laser_LaserGRBL/Yumi_Laser_LaserGRBL_14.gif" alt="LaserGRBL Work Area Preview">

---

## 8. Enable Air Assist (Optional)

- If your engraver is equipped with **Air Assist**, turn it on now.  
- This helps improve cutting quality and reduce burn marks. 

## 9. Start Engraving

1. Verify speed, power, and focus.  
2. Click **Start** to begin engraving.  
3. Stay near the machine and monitor the process for safety. 

## 10. Save Your Settings

- Save material-specific settings using the **Material Profiles** feature for future reuse.



