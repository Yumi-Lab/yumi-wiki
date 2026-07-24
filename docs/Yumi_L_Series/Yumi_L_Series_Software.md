# Software Overview & Compatibility

The YUMI Laser (L-A4 / L-A3 / L-A2) is a standard **GRBL** machine: it can be controlled by any GRBL-compatible software over USB (baud rate `115200`).  
This page compares the three recommended options so you can quickly pick the right one for your computer and your needs.

---

## 1. Compatibility & Price Comparison

| Software | Windows | macOS | Linux | Price | Setup Guide |
|----------|:-------:|:-----:|:-----:|-------|-------------|
| **LightBurn** | ✅ | ✅ | ✅ | Paid license (free trial) | [1.6 LightBurn Setup](Yumi_L_Series_LightBurn.md) |
| **LaserGRBL** | ✅ | ❌ | ❌ | **Free** (open source) | [1.7 LaserGRBL Setup](Yumi_L_Series_LaserGRBL.md) |
| **OpenBurn Laser** | ✅ | ❌ | ❌ | **Free** | [1.8 OpenBurn Laser Setup](Yumi_L_Series_OpenBurn.md) |

> 💡 Whatever your OS, you can also control the laser from any web browser (PC, Mac, smartphone, tablet) using the built-in **Web Control Interface** — see [1.9 Wireless Control](Yumi_L_Series_Wireless.md).

---

## 2. LightBurn

[https://lightburnsoftware.com](https://lightburnsoftware.com){ target=_blank }

The most powerful and complete laser software on the market. Full vector editing, image processing, material library, camera support.

- **OS**: Windows, macOS, Linux — the only option for Mac and Linux users
- **Price**: paid license, with a free trial period
- **Best for**: regular users and professionals who want the most complete tool

➡️ Setup guide: [1.6 LightBurn Setup and Usage](Yumi_L_Series_LightBurn.md)

---

## 3. LaserGRBL

[https://lasergrbl.com](https://lasergrbl.com){ target=_blank }

The reference free and open-source software for GRBL laser engravers. Excellent raster image engraving (line to line, dithering), simple and reliable.

- **OS**: Windows only
- **Price**: free and open source
- **Best for**: beginners on Windows, image engraving

➡️ Setup guide: [1.7 LaserGRBL Setup and Usage](Yumi_L_Series_LaserGRBL.md)  
➡️ Tutorials: [LaserGRBL step-by-step](Tuto/Yumi_L_LaserGRBL.md) · [Cork engraving with LaserGRBL](Tuto/Yumi_L_Cork_Engraving.md)

---

## 4. OpenBurn Laser

[https://www.m3d-formation.com/openburn/](https://www.m3d-formation.com/openburn/){ target=_blank }

A free alternative to LightBurn developed by M3D-FORMATION, with a similar intuitive interface: image import, vector drawing tools (rectangles, circles, lines, hexagons, text), multiple machine profiles, and a Frame preview function.

- **OS**: Windows only
- **Price**: free
- **Best for**: Windows users who want a LightBurn-style interface without buying a license

➡️ Setup guide: [1.8 OpenBurn Laser Setup and Usage](Yumi_L_Series_OpenBurn.md)

---

## 5. Which Software Should You Choose?

| Your situation | Recommended software |
|----------------|---------------------|
| I use a **Mac** or **Linux** computer | **LightBurn** (only desktop option) or the [Web Control Interface](Yumi_L_Series_Wireless.md) |
| I'm on **Windows** and want a free tool | **OpenBurn Laser** (LightBurn-style) or **LaserGRBL** (image engraving) |
| I mainly engrave **photos and images** | **LaserGRBL** or **LightBurn** |
| I do **advanced vector work** or use the laser professionally | **LightBurn** |
| I want to control the laser from a **smartphone or tablet** | [Web Control Interface](Yumi_L_Series_Wireless.md) |

All three programs use the same machine settings: work area per model (L-A4: 210 × 297 mm, L-A3: 420 × 297 mm, L-A2: 420 × 594 mm), USB connection at `115200` baud, and the same recommended power ranges per laser module (see each setup guide).
