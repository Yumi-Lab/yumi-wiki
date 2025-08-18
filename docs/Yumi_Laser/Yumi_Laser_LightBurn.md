# 1.4 LightBurn Setup and First Engraving

<img src="../../img/Yumi_laser/Yumi_Laser_LightBurn/Yumi_Laser_LightBurn_01.png" width="600" alt="LightBurn Interface">

**LightBurn** is one of the most powerful and user-friendly software tools for controlling your YUMI Laser.  
This guide will walk you through setting up LightBurn for your specific YUMI model (L-A4, L-A3, L-A2) and laser module (2.5W, 5.5W, 10W, 20W), and launching your first engraving job.

---

## 1. Install LightBurn

- Download LightBurn from the official website: [https://lightburnsoftware.com](https://lightburnsoftware.com)
- Install it on your computer (Windows, macOS, Linux supported).

---

## 2. Connect Your YUMI Laser

1. Power on your YUMI Laser.
2. Connect it to your computer via **USB cable**.
3. Insert the included **MicroSD card** if you wish to load files directly without USB control.

---

## 3. Add the YUMI Laser to LightBurn

1. Open LightBurn.
2. Go to **Devices** → **Create Manually**.
3. Choose:
   - **GRBL** as the device type.
   - **Serial/USB** as the connection type.
4. Enter the working area size according to your model:

   | Model  | Width (mm) | Height (mm) |
   |--------|-----------|-------------|
   | L-A4   | 210       | 297         |
   | L-A3   | 420       | 297         |
   | L-A2   | 420       | 594         |

5. Name the device (e.g., `YUMI_LA4_10W`).
6. Click **Finish**.

---

## 4. Configure the Laser Module Power

- In LightBurn’s **Device Settings**, set the **Max Power** to match your laser module:
  - 2.5W: Use for fine engraving, **low power (10–40%)** recommended.
  - 5.5W: General engraving & light cutting, **20–70%**.
  - 10W: Faster engraving & cutting thin materials, **30–90%**.
  - 20W: High-speed engraving & cutting thicker materials, **50–100%**.

> Always start with lower power and increase gradually to avoid burning the material.

---

## 5. Import a Test Design

1. Create a simple design (text or shape) in LightBurn, or import an image/SVG.
2. Place the design within the workspace (make sure it fits inside your model’s work area).
3. Set the **Layer**:
   - **Line** for outline engraving
   - **Fill** for filled engraving
   - **Cut** for cutting

---

## 6. Position & Focus the Laser

1. Move the laser head to the starting position using the LightBurn move controls.
2. Adjust the **focus** according to your module’s instructions (using the focusing tool or manual adjustment).
3. Enable **Air Assist** if available.

---

## 7. Launch the First Engraving

1. In LightBurn, click **Frame** to preview the working area without firing the laser.
2. Click **Start** to begin engraving.
3. Monitor the job and be ready to stop it if needed.

---

## 8. Save Your Settings

- Once you find the right settings for a material, save them as a **Material Library** in LightBurn for future use.


