# 1.6 Wireless Control

The **YUMI Laser** can be controlled over Wi-Fi without a physical display, using a PC, smartphone, or tablet.  
This section covers the three available connection methods and how to launch engraving jobs wirelessly.


---

## Method 1 – Serial Command Setup via USB

1. **Install USB Driver**  
   - Install the CH340 driver so your PC can detect the laser’s COM port.  
   - On Windows, check the COM port in *Device Manager*.

2. **Connect to the Laser**  
   - Open LaserGRBL (or another serial terminal) and connect at **115200 baud**.

3. **Send Wi-Fi Credentials** (replace with your network details):  

    [ESP100]Your_WiFi_Name
    [ESP101]Your_WiFi_Password
    [ESP115]ON

4. **Obtain IP Address**  
- Send:  
  ```
  [ESP111]
  ```
- The laser returns its IP address (e.g., `192.168.0.105`).  
  Enter this IP in a web browser to open the **Web Control Interface**.

---

## Method 2 – MKS Laser Tool

1. **Install MKS Laser Tool** on your PC.  
2. **Connect via USB** and select the detected COM port.  
3. Enter your Wi-Fi SSID and password, then click **Connect Wi-Fi**.  
4. Once connected, the IP address is displayed.  
5. Type this IP into your browser to access the **Web Control Interface**.

---

## Web Control Interface Features

From the built-in web UI, you can:
- Move the laser head manually
- Adjust laser power & speed
- Upload, select, and delete files
- Start/stop jobs
- Monitor job progress in real-time

---


## Tips for Stable Wireless Use
- Keep the laser close to the Wi-Fi router
- Avoid congested Wi-Fi channels
- For large files, USB transfer is more reliable