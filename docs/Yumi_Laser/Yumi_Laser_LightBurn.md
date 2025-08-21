# LightBurn Setup and First Engraving

**LightBurn** is one of the most powerful and user-friendly software tools for controlling your YUMI Laser.  
This guide will walk you through setting up LightBurn for your specific YUMI L Series model (L-A4, L-A3, L-A2) and laser module (2.5W, 5.5W, 10W, 20W), and launching your first engraving job.

<img src="../../img/Yumi_laser/Yumi_Laser_LightBurn/Yumi_Laser_LightBurn_01.png" width="600" alt="LightBurn Interface">

---

## Step 1 — Install LightBurn

- Download LightBurn from the official website: [https://lightburnsoftware.com](https://lightburnsoftware.com)  
- Install it on your computer (Windows, macOS, Linux supported).

---

## Step 2 — Connect Your YUMI Laser

- Power on your YUMI Laser.  
- Connect it to your computer via **USB cable**.  
- Insert the included **MicroSD card** if you wish to load files directly without USB control.  

---

## Step 3 — Add the YUMI Laser to LightBurn

- Open **LightBurn** → go to **Devices** → click **Find my Laser**.  
<img src="../../img/Yumi_laser/Yumi_Laser_LightBurn/Yumi_Laser_LightBurn_02.png" width="450" alt="LightBurn Devices">

- The **Device Discovery Wizard** opens → click **Next**.  
- LightBurn scans and detects your machine (e.g., `GRBL (210 mm x 297 mm) at COM3, 115200 baud`).  
- Select it → click **Add Device**.  
<img src="../../img/Yumi_laser/Yumi_Laser_LightBurn/Yumi_Laser_LightBurn_03.png" width="500" alt="LightBurn Device Discovery Wizard">

- Replace the default name (`GRBL`) with e.g. `YUMI-LA4-2.5W`.  
- Set **Machine Units** to `mm/min`.  
- Enter the **work area dimensions** for your model:  

   | Model  | Width (mm) | Height (mm) |
   |--------|------------|-------------|
   | L-A4   | 210        | 297         |
   | L-A3   | 420        | 297         |
   | L-A2   | 420        | 594         |

- Click **Next** → choose **Front Left** as origin.  
- Disable **Auto-home on startup**.  
- Click **Finish**.  

<img src="../../img/Yumi_laser/Yumi_Laser_LightBurn/Yumi_Laser_LightBurn_06.png" width="500" alt="LightBurn Device Added">

---

## Step 4 — Import a Test Design

- Create or import a design (text, SVG, or image).  
- Place it inside the workspace area.  
- Set the **Layer**:  
  - **Line** → outline engraving  
  - **Fill** → filled engraving  
- Adjust parameters:  
  - Speed (mm/min)  
  - Max Power (%)  
  - Pass Count  

<img src="../../img/Yumi_laser/Yumi_Laser_LightBurn/Yumi_Laser_LightBurn_09.png" width="500" alt="LightBurn Layer Settings">

---

## Step 5 — Configure the Laser Module Power

- **2.5W** → fine engraving, 10–40% power  
- **5.5W** → general use, 20–70%  
- **10W** → faster engraving, 30–90%  
- **20W** → high speed/thick cuts, 50–100%  

⚠️ Always start low, then increase if needed.

---

## Step 6 — Position & Focus the Laser

- Move the laser head manually over the workpiece.  
- Place the **5 mm spacer** on the surface.  
- Loosen the module screws → slide laser down to touch spacer → remove spacer → tighten screws.  

---

## Step 7 — Enable Air Assist (Optional)

- If equipped, turn on **Air Assist** for better cut quality and less burning.  

---

## Step 8 — Launch the First Engraving

- In LightBurn, click **Frame** to preview area.  
- Click **Start** to begin engraving.  
