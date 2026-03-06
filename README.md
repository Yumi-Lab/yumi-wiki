# YUMI-LAB Documentation Wiki

Official documentation wiki for [Yumi Lab](https://www.yumi-lab.com) products — built with [MkDocs Material](https://squidfunk.github.io/mkdocs-material/).

**Live site:** [wiki.yumi-lab.com](https://wiki.yumi-lab.com)

## Content

| Section | Description |
|---------|-------------|
| **Yumi C Series** | Yumi C Series 3D printer documentation and overview |
| **Yumi L Series (Laser)** | Laser engraver guides — assembly, safety, LightBurn, LaserGRBL, wireless setup, maintenance, tutorials |
| **Smart Pi One** | SBC nano-computer — specifications, Linux images, getting started, SSH, Wi-Fi, GPIO sensors & modules, projects (Klipper, retro gaming, Home Assistant, Plex, OpenMediaVault) |
| **Klipper Smart Pad** | Klipper pad setup — SSH, screen rotation, KlipperScreen VNC, calibrations (extruder, Z-offset, PID, ADXL), OrcaSlicer, Yumi App, printer configs |
| **Printers Installation** | Klipper configuration for Wanhao D12, D12-230 EVO, Artillery Sidewinder X1/X2, Prusa MK3 |
| **Yumi Components** | Specs for SmartLCD Touch 4.3", SmartHub, SmartShield |
| **Maintenance** | General 3D printer maintenance — lubrication, nozzle cleaning, belt tension, build plate, fan cleaning |
| **Yumi 3D Pen** | 3D pen documentation |
| **Yumi PenScreen** | PenScreen documentation |
| **Yumi STL** | Printable accessories and replacement parts |

## Local Development

### Prerequisites

- Python 3.x
- pip

### Setup & Serve

```bash
# Clone the repository
git clone https://github.com/Yumi-Lab/yumi-wiki.git
cd yumi-wiki

# Create and activate a virtual environment
python3 -m venv venv
source venv/bin/activate

# Install dependencies
pip install mkdocs mkdocs-material

# Start the local dev server (live reload)
mkdocs serve
```

Then open [http://127.0.0.1:8000](http://127.0.0.1:8000) in your browser.

### Build

```bash
mkdocs build
```

The static site is generated in the `site/` directory.

## Project Structure

```
yumi-wiki/
├── docs/                  # Markdown documentation pages
│   ├── index.md           # Homepage
│   ├── SmartPI/           # Smart Pi One docs + Sensors & Modules
│   ├── KlipperSmartPad/   # Klipper Smart Pad docs + Calibrations + Tuto
│   ├── Yumi_C_Series/     # C Series 3D printer docs
│   ├── Yumi_L_Series/     # L Series laser engraver docs + Tuto
│   ├── Yumi_Components/   # Component specifications
│   ├── PRINTERS/          # Printer installation guides
│   ├── Maintenance/       # Maintenance guides
│   ├── 3d_pen/            # 3D pen docs
│   ├── PenScreen/         # PenScreen docs
│   └── Yumi_stl/          # STL files documentation
├── img/                   # Images and assets
├── css/                   # Custom stylesheets
├── Klipper/               # Klipper configuration files
├── Profile_Slicer/        # Slicer profiles
├── stl/                   # STL model files
├── mkdocs.yml             # MkDocs configuration & navigation
└── deploy_yumi_wiki.sh    # Server deployment script
```

## Deployment

The wiki is deployed to `wiki.yumi-lab.com` via the `deploy_yumi_wiki.sh` script, which builds the site and copies it to the web server directory.

## License

This documentation is maintained by [Yumi Lab](https://github.com/Yumi-Lab).
