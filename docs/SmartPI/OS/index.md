# Operating Systems for Smart Pi One

The Smart Pi One and Smart Pad run a full 32-bit ARM Linux (Allwinner H3 / armv7l). YUMI-LAB builds and publishes every image on this page: five Armbian-based Debian and Ubuntu releases in server and desktop editions, plus a minimal DietPi variant for boards where the 1 GB of RAM is the limiting factor.

All of them share the same hardware stack — our overclocked kernel, our U-Boot, our device tree — so you can move from one to another without changing anything about the board.

## 1. Available images

<div class="banner-gallery" markdown>

[![Debian 13 Trixie for Smart Pi One](/img/SmartPi/OS/debian13-trixie-banner.svg)](../SmartPi_Linux.md)

[![Debian 12 Bookworm for Smart Pi One](/img/SmartPi/OS/debian12-bookworm-banner.svg)](../SmartPi_Linux.md)

[![Ubuntu 24.04 Noble for Smart Pi One](/img/SmartPi/OS/ubuntu2404-noble-banner.svg)](../SmartPi_Linux.md)

[![Ubuntu 22.04 Jammy for Smart Pi One](/img/SmartPi/OS/ubuntu2204-jammy-banner.svg)](../SmartPi_Linux.md)

[![Debian 11 Bullseye for Smart Pi One](/img/SmartPi/OS/debian11-bullseye-banner.svg)](../SmartPi_Linux.md)

[![DietPi for Smart Pi One](/img/SmartPi/OS/dietpi-banner.svg)](SmartPi_DietPi.md)

![Debian 14 Forky for Smart Pi One — coming soon](/img/SmartPi/OS/debian14-forky-banner.svg){ .off-glb }

</div>

**Debian 14 Forky** is the next Debian stable. An image for these boards is in preparation and will appear here when it is ready.

## 2. At a glance

| Image | Base | Editions | RAM at idle | Best for |
|---|---|---|---|---|
| ![](/img/SmartPi/OS/debian-logo.svg){ .off-glb width="18" } **[Debian 13 Trixie](../SmartPi_Linux.md)** | Armbian | Server + Desktop | ~105 MB (server) | New installations — current stable |
| ![](/img/SmartPi/OS/debian-logo.svg){ .off-glb width="18" } **[Debian 12 Bookworm](../SmartPi_Linux.md)** | Armbian | Server + Desktop | ~105 MB (server) | Proven stability, wide package coverage |
| ![](/img/SmartPi/OS/ubuntu-logo.svg){ .off-glb width="18" } **[Ubuntu 24.04 Noble](../SmartPi_Linux.md)** | Armbian | Server + Desktop | ~105 MB (server) | Ubuntu users, abundant documentation |
| ![](/img/SmartPi/OS/ubuntu-logo.svg){ .off-glb width="18" } **[Ubuntu 22.04 Jammy](../SmartPi_Linux.md)** | Armbian | Server (+ Desktop up to v1.7.0) | ~105 MB (server) | Existing 22.04 deployments |
| ![](/img/SmartPi/OS/debian-logo.svg){ .off-glb width="18" } **[Debian 11 Bullseye](../SmartPi_Linux.md)** | Armbian | Server | ~105 MB | Legacy setups only — end of life |
| ![](/img/SmartPi/OS/dietpi-mark.png){ .off-glb width="18" } **[DietPi](SmartPi_DietPi.md)** | Debian 13 trixie server | Server (headless) | **~87 MB** | Squeezing the most out of 1 GB of RAM |

*Idle memory measured on a Smart Pi One, minutes after boot with nothing added: **Debian 12 bookworm server (Yumi 26.08.0) — 105 MB used of 960 MB total**, 854 MB available. The Armbian releases share one base, so the other server images sit in the same range; each is added here as it is measured on hardware.*

## 3. What every YUMI image includes

These are ours, not stock Armbian or stock DietPi. Whichever you pick, you get:

| Feature | Detail |
|---|---|
| **CPU overclock** | 1368 MHz instead of the stock 1296 MHz |
| **Custom U-Boot** | DRAM at 576 MHz with ZQ calibration and ODT |
| **Device tree** | `YUMi SmartPi One` — `cat /proc/device-tree/model` |
| **Smart Pad screen rotation** | The 4.3" 800x480 touchscreen is detected at boot and the display rotated 180° only then; an HDMI monitor is left alone |
| **SSH over USB** | The OTG port powers the board *and* carries the network — see below |
| **Boot logo** | The Yumi logo is embedded in U-Boot and drawn the moment the video output starts |
| **Kernel packages held** | `apt-mark hold` on every `linux-*` package, so no upgrade can replace the custom kernel with a generic one |

!!! note "One image for both boards"
    The Smart Pad is a Smart Pi One fitted with the 4.3" touchscreen, mounted upside-down. Since the rotation is decided at runtime, a single image serves both products.

## 4. SSH over USB (OTG port)

A single USB cable between the board's **OTG port** and your computer powers the Smart Pi One *and* gives it a network link. No Ethernet, no WiFi, no screen.

The board answers at **`172.22.1.1`**. Set your computer's new USB network interface to `172.22.1.2` / `255.255.255.0`, then:

```bash
ssh root@172.22.1.1
```

The gadget uses **CDC NCM**, recognised natively by macOS, Linux and Windows — no driver to install.

!!! warning "Unplugging the cable cuts the power"
    The cable is the power supply as well as the network link. And a computer's USB port may not deliver enough current for a sustained workload at 1368 MHz — use a dedicated **5 V / 2 A** supply for that.

## 5. Which one should I choose?

- **[Debian 13 Trixie](../SmartPi_Linux.md)** — the default choice for a new board. Current Debian stable, server or desktop.
- **[Debian 12 Bookworm](../SmartPi_Linux.md)** — when you want the most conservative, most widely tested option.
- **[Ubuntu 24.04 Noble](../SmartPi_Linux.md)** — if you already work with Ubuntu and want its documentation and PPAs.
- **[DietPi](SmartPi_DietPi.md)** — when RAM is what you are short of. About 87 MB at idle against roughly 105 MB for an Armbian server image, in a system trimmed to the essentials, with a menu-driven software catalog. Headless only, and currently a release candidate.
- **[Ubuntu 22.04 Jammy](../SmartPi_Linux.md)** / **[Debian 11 Bullseye](../SmartPi_Linux.md)** — only to match an existing deployment. Bullseye is end of life.

## 6. Purpose-built images

Beyond the general-purpose systems above, YUMI-LAB also ships images built around a single application:

- **[YumiOS — Klipper](../SmartPi_Klipper.md)** — 3D printer control, the system running on the Klipper Smart Pad
- **[RetroMi](../SmartPi_Retro_Gaming.md)** — retro gaming, an optimised RetroPie for the H3

## 7. Next step

Once you have picked an image, write it to a microSD card (4 to 32 GB). The simplest route is Raspberry Pi Imager pointed at our image list — it downloads, verifies and writes in one step:

[:material-download-box: Install with Raspberry Pi Imager](SmartPi_RPi_Imager.md){ .md-button .md-button--primary }
[:octicons-download-16: Download the images](../SmartPi_Linux.md){ .md-button }
[:material-sd: Flash guide — balenaEtcher](../SmartPi_Linux_flash_sd.md){ .md-button }

Then verify the board is running the YUMI build:

![Verifying a YUMI Linux image over SSH](/img/SmartPi/OS/smartpi-linux-terminal.svg){ .off-glb }
