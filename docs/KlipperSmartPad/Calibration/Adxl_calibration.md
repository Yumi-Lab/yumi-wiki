# 2.4 Adxl calibration

# 📦 Prerequisites
- **Smartpad**  [buy here](https://wanhao-europe.com/products/wanhao-klipper-pad?variant=50407737753940)
- **ADXL345 sensor** properly connected and configured in Klipper  [buy here](https://wanhao-europe.com/products/capteur-adxl-test?_pos=1&_psq=adxl&_ss=e&_v=1.0)  

---

# 🚀 Starting the Calibration

1. Connect the ADXL to the smartpad
<p align="center">
  <img src="/img/KlipperSmartPad/ADXL/009.jpg" alt="ADXL" style="width:50%;" />
</p>
2. On the **Smartpad**, go to the **More** menu  
<p align="center">
  <img src="/img/KlipperSmartPad/ADXL/005.jpg" alt="ADXL" style="width:50%;" />
</p>
32. Select **Input Shaper**  
<p align="center">
  <img src="/img/KlipperSmartPad/ADXL/006.jpg" alt="ADXL" style="width:50%;" />
</p>
4. Wait for the Smartpad to detect the ADXL (about **5–10 seconds**)  
5. Select **Auto-Calibrate**  
<p align="center">
  <img src="/img/KlipperSmartPad/ADXL/007.jpg" alt="ADXL" style="width:50%;" />
</p>
6. Choose the axis to measure (**X** or **Y**)  
<p align="center">
  <img src="/img/KlipperSmartPad/ADXL/008.jpg" alt="ADXL" style="width:50%;" />
</p>
---

# 📏 ADXL Positioning

## Measuring the X-axis
- Mount the ADXL on the X-axis as shown in the reference photo (using a screw).  
<p align="center">
  <img src="/img/KlipperSmartPad/ADXL/004.jpg" alt="ADXL" style="width:50%;" />
</p>
- Start the measurement for the **X-axis**  
- Once complete, **save your values**  
<p align="center">
  <img src="/img/KlipperSmartPad/ADXL/001.jpg" alt="ADXL" style="width:50%;" />
</p>
- The X-axis is now configured ✅  

---

## Measuring the Y-axis
- You can use this STL file to mount the ADXL on the bed:  
  [ADXL Clamp Mount - Makerworld](https://makerworld.com/fr/models/1197743-adxl-clamp-mount-work-on-heatbed-nozzle?from=search)  
- Install the mount as shown in the reference photo  
<p align="center">
  <img src="/img/KlipperSmartPad/ADXL/003.jpg" alt="ADXL" style="width:50%;" />
</p>
<p align="center">
  <img src="/img/KlipperSmartPad/ADXL/002.jpg" alt="ADXL" style="width:50%;" />
</p>
- Start the measurement for the **Y-axis**  
- Once complete, **save your values**  
<p align="center">
  <img src="/img/KlipperSmartPad/ADXL/001.jpg" alt="ADXL" style="width:50%;" />
</p>
- The Y-axis is now configured ✅  

---

!!! tip  
    Always ensure the ADXL wiring is secure before running measurements to avoid incorrect readings.
