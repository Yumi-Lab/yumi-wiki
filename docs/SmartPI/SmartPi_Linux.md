# Official Linux Image

Official Armbian-based images for **YUMI Smart Pi One** and **YUMI Smart Pad** (Allwinner H3), built and published by YUMI-LAB.

We offer several Linux distributions optimized for our boards, in both **Server** (headless) and **Desktop** (GUI) editions. Choose the one that best fits your needs:

- **Debian 13 Trixie** — Current stable release (since August 2025). Latest packages, supported until 2028 + LTS until 2030. Recommended for new installations.
- **Debian 12 Bookworm** (the YUMI team's choice) — Previous stable release, supported until June 2028. Proven stability and security, ideal for production environments. Extensive package catalog and strong community support.
- **Ubuntu 24.04 Noble** — Current LTS release, supported until April 2029. User-friendly with abundant documentation, ideal for beginners.
- **Ubuntu 22.04 Jammy** — Previous LTS, standard support until April 2027. Use Noble (24.04) for new installations.
- **Debian 11 Bullseye** — End-of-life (EOL). Provided for legacy compatibility only, no longer recommended for new installations. Server only.

!!! tip "Debian or Ubuntu?"
    **Debian** is preferred for its proven stability and lightweight footprint. **Ubuntu** shines for its ease of use and quick access to new features. Both use `apt` as package manager.

Looking for something lighter? The [DietPi image](OS/SmartPi_DietPi.md) idles at about 87 MB of RAM instead of 528 MB. All the choices are compared on the [Operating Systems](OS/index.md) page.

Once you have downloaded the image of your choice, follow the [flash guide](SmartPi_Linux_flash_sd.md) to transfer it to a microSD card.

---

## 1. Requirements

!!! warning "microSD Card Compatibility"
    - **Minimum:** 4 GB
    - **Maximum: 32 GB** — larger cards are not supported

---

## 2. Latest stable release

!!! success "v1.7.0 — April 23, 2026"
    Server and Desktop editions available. Kernel headers are pre-installed, so kernel modules (WiFi drivers, GPIO drivers, DKMS) compile directly on the board. Select your device and preferred Linux distribution below.

    [:octicons-mark-github-16: View all releases on GitHub](https://github.com/Yumi-Lab/SmartPi-armbian/releases){ .md-button .md-button--primary target=_blank }

---

## 3. Download — Smart Pi One (screenless / external display)

=== ":simple-debian: Debian — Server"

    | Version | Status | Release | Download |
    |---|---|---|---|
    | **Debian 13 Trixie** | :material-star: Recommended | v1.7.0 — 2026-04-23 | [![Download](https://img.shields.io/badge/Download-Trixie_Server-A81D33?logo=debian&logoColor=white)](https://github.com/Yumi-Lab/SmartPi-armbian/releases/download/v1.7.0/Yumi-smartpi1-trixie-debian13-server-2026-04-23-0753.img.xz){ target=_blank } |
    | **Debian 12 Bookworm** | Stable | v1.7.0 — 2026-04-23 | [![Download](https://img.shields.io/badge/Download-Bookworm_Server-A81D33?logo=debian&logoColor=white)](https://github.com/Yumi-Lab/SmartPi-armbian/releases/download/v1.7.0/Yumi-smartpi1-bookworm-debian12-server-2026-04-23-0753.img.xz){ target=_blank } |
    | **Debian 11 Bullseye** | EOL | v1.7.0 — 2026-04-23 | [![Download](https://img.shields.io/badge/Download-Bullseye_Server-A81D33?logo=debian&logoColor=white)](https://github.com/Yumi-Lab/SmartPi-armbian/releases/download/v1.7.0/Yumi-smartpi1-bullseye-debian11-server-2026-04-23-0753.img.xz){ target=_blank } |

    !!! tip "Which version?"
        **Trixie (13)** is the current stable release — recommended for new installations.
        **Bookworm (12)** remains a solid choice for proven stability.
        Bullseye (11) is end-of-life — only use it for legacy setups.

=== ":simple-debian: Debian — Desktop"

    | Version | Status | Release | Download |
    |---|---|---|---|
    | **Debian 13 Trixie** | :material-star: Recommended | v1.7.0 — 2026-04-23 | [![Download](https://img.shields.io/badge/Download-Trixie_Desktop-A81D33?logo=debian&logoColor=white)](https://github.com/Yumi-Lab/SmartPi-armbian/releases/download/v1.7.0/Yumi-smartpi1-trixie-debian13-desktop-2026-04-23-0753.img.xz){ target=_blank } |
    | **Debian 12 Bookworm** | Stable | v1.7.0 — 2026-04-23 | [![Download](https://img.shields.io/badge/Download-Bookworm_Desktop-A81D33?logo=debian&logoColor=white)](https://github.com/Yumi-Lab/SmartPi-armbian/releases/download/v1.7.0/Yumi-smartpi1-bookworm-debian12-desktop-2026-04-23-0753.img.xz){ target=_blank } |

    !!! info "No Bullseye Desktop"
        Debian 11 Bullseye is end-of-life — no desktop image is provided for this version.

=== ":simple-ubuntu: Ubuntu — Server"

    | Version | Status | Release | Download |
    |---|---|---|---|
    | **Ubuntu 24.04 Noble** | :material-star: Recommended (LTS) | v1.7.0 — 2026-04-23 | [![Download](https://img.shields.io/badge/Download-Noble_Server-E95420?logo=ubuntu&logoColor=white)](https://github.com/Yumi-Lab/SmartPi-armbian/releases/download/v1.7.0/Yumi-smartpi1-noble-ubuntu24.04-server-2026-04-23-0753.img.xz){ target=_blank } |
    | **Ubuntu 22.04 Jammy** | LTS | v1.7.0 — 2026-04-23 | [![Download](https://img.shields.io/badge/Download-Jammy_Server-E95420?logo=ubuntu&logoColor=white)](https://github.com/Yumi-Lab/SmartPi-armbian/releases/download/v1.7.0/Yumi-smartpi1-jammy-ubuntu22.04-server-2026-04-23-0753.img.xz){ target=_blank } |

    !!! tip "Which version?"
        **Noble (24.04)** is the current LTS — recommended for new installations (supported until 2029).
        Jammy (22.04) standard support ends April 2027 — migrate to Noble when possible.

=== ":simple-ubuntu: Ubuntu — Desktop"

    | Version | Status | Release | Download |
    |---|---|---|---|
    | **Ubuntu 24.04 Noble** | :material-star: Recommended (LTS) | v1.7.0 — 2026-04-23 | [![Download](https://img.shields.io/badge/Download-Noble_Desktop-E95420?logo=ubuntu&logoColor=white)](https://github.com/Yumi-Lab/SmartPi-armbian/releases/download/v1.7.0/Yumi-smartpi1-noble-ubuntu24.04-desktop-2026-04-23-0753.img.xz){ target=_blank } |
    | **Ubuntu 22.04 Jammy** | LTS | v1.7.0 — 2026-04-23 | [![Download](https://img.shields.io/badge/Download-Jammy_Desktop-E95420?logo=ubuntu&logoColor=white)](https://github.com/Yumi-Lab/SmartPi-armbian/releases/download/v1.7.0/Yumi-smartpi1-jammy-ubuntu22.04-desktop-2026-04-23-0753.img.xz){ target=_blank } |

---

## 4. Download — [Smart Pad](../KlipperSmartPad/SmartPad_specifications.md) (integrated touchscreen)

=== ":simple-debian: Debian — Server"

    | Version | Status | Release | Download |
    |---|---|---|---|
    | **Debian 13 Trixie** | :material-star: Recommended | v1.7.0 — 2026-04-23 | [![Download](https://img.shields.io/badge/Download-Trixie_Server-A81D33?logo=debian&logoColor=white)](https://github.com/Yumi-Lab/SmartPi-armbian/releases/download/v1.7.0/Yumi-smartpad-trixie-debian13-server-2026-04-23-0753.img.xz){ target=_blank } |
    | **Debian 12 Bookworm** | Stable | v1.7.0 — 2026-04-23 | [![Download](https://img.shields.io/badge/Download-Bookworm_Server-A81D33?logo=debian&logoColor=white)](https://github.com/Yumi-Lab/SmartPi-armbian/releases/download/v1.7.0/Yumi-smartpad-bookworm-debian12-server-2026-04-23-0753.img.xz){ target=_blank } |
    | **Debian 11 Bullseye** | EOL | v1.7.0 — 2026-04-23 | [![Download](https://img.shields.io/badge/Download-Bullseye_Server-A81D33?logo=debian&logoColor=white)](https://github.com/Yumi-Lab/SmartPi-armbian/releases/download/v1.7.0/Yumi-smartpad-bullseye-debian11-server-2026-04-23-0753.img.xz){ target=_blank } |

    !!! tip "Which version?"
        **Trixie (13)** is the current stable — recommended for new installations.
        **Bookworm (12)** remains a solid choice for proven stability.

=== ":simple-debian: Debian — Desktop"

    | Version | Status | Release | Download |
    |---|---|---|---|
    | **Debian 13 Trixie** | :material-star: Recommended | v1.7.0 — 2026-04-23 | [![Download](https://img.shields.io/badge/Download-Trixie_Desktop-A81D33?logo=debian&logoColor=white)](https://github.com/Yumi-Lab/SmartPi-armbian/releases/download/v1.7.0/Yumi-smartpad-trixie-debian13-desktop-2026-04-23-0753.img.xz){ target=_blank } |
    | **Debian 12 Bookworm** | Stable | v1.7.0 — 2026-04-23 | [![Download](https://img.shields.io/badge/Download-Bookworm_Desktop-A81D33?logo=debian&logoColor=white)](https://github.com/Yumi-Lab/SmartPi-armbian/releases/download/v1.7.0/Yumi-smartpad-bookworm-debian12-desktop-2026-04-23-0753.img.xz){ target=_blank } |

    !!! info "No Bullseye Desktop"
        Debian 11 Bullseye is end-of-life — no desktop image is provided for this version.

=== ":simple-ubuntu: Ubuntu — Server"

    | Version | Status | Release | Download |
    |---|---|---|---|
    | **Ubuntu 24.04 Noble** | :material-star: Recommended (LTS) | v1.7.0 — 2026-04-23 | [![Download](https://img.shields.io/badge/Download-Noble_Server-E95420?logo=ubuntu&logoColor=white)](https://github.com/Yumi-Lab/SmartPi-armbian/releases/download/v1.7.0/Yumi-smartpad-noble-ubuntu24.04-server-2026-04-23-0753.img.xz){ target=_blank } |
    | **Ubuntu 22.04 Jammy** | LTS | v1.7.0 — 2026-04-23 | [![Download](https://img.shields.io/badge/Download-Jammy_Server-E95420?logo=ubuntu&logoColor=white)](https://github.com/Yumi-Lab/SmartPi-armbian/releases/download/v1.7.0/Yumi-smartpad-jammy-ubuntu22.04-server-2026-04-23-0753.img.xz){ target=_blank } |

    !!! tip "Which version?"
        **Noble (24.04)** is the current LTS — recommended for new installations (supported until 2029).
        Jammy (22.04) standard support ends April 2027 — migrate to Noble when possible.

=== ":simple-ubuntu: Ubuntu — Desktop"

    | Version | Status | Release | Download |
    |---|---|---|---|
    | **Ubuntu 24.04 Noble** | :material-star: Recommended (LTS) | v1.7.0 — 2026-04-23 | [![Download](https://img.shields.io/badge/Download-Noble_Desktop-E95420?logo=ubuntu&logoColor=white)](https://github.com/Yumi-Lab/SmartPi-armbian/releases/download/v1.7.0/Yumi-smartpad-noble-ubuntu24.04-desktop-2026-04-23-0753.img.xz){ target=_blank } |
    | **Ubuntu 22.04 Jammy** | LTS | v1.7.0 — 2026-04-23 | [![Download](https://img.shields.io/badge/Download-Jammy_Desktop-E95420?logo=ubuntu&logoColor=white)](https://github.com/Yumi-Lab/SmartPi-armbian/releases/download/v1.7.0/Yumi-smartpad-jammy-ubuntu22.04-desktop-2026-04-23-0753.img.xz){ target=_blank } |

---

## 5. Release candidate — v1.8.0

!!! info "v1.8.0-rc3 — July 26, 2026 — release candidate"
    Validated on real Smart Pi One hardware, and the version our [DietPi image](OS/SmartPi_DietPi.md) is built from. Use it if you want SSH over USB; stay on v1.7.0 if you want the release we consider final.

    [:octicons-mark-github-16: v1.8.0-rc3 on GitHub](https://github.com/Yumi-Lab/SmartPi-armbian/releases/tag/v1.8.0-rc3){ .md-button target=_blank }

**What is new**

- **SSH over USB (OTG port)** — one cable powers the board *and* carries the network. The board answers at `172.22.1.1`; set `172.22.1.2/24` on the computer side. The gadget uses **CDC NCM**, supported natively by macOS, Linux and Windows. See [SSH over USB](OS/index.md#4-ssh-over-usb-otg-port).
- **Customizable boot logo** — U-Boot displays `/boot/boot.bmp` at power-on. The boot partition is FAT32 and mounts on macOS and Windows, so you can replace or delete the logo from any computer (uncompressed BMP, no larger than the display resolution).
- **Kernel packages published** — the exact `linux-image`, `linux-headers`, `linux-dtb` and `linux-u-boot` `.deb` files matching these images are attached to the release, for both kernel branches (`current` 6.18 and `legacy` 6.12). Install DKMS headers from there, **not** from `apt.armbian.com`, whose generic builds do not match this kernel.
- **One image for both boards** — the 4.3" 800x480 touchscreen is now detected at boot and the display rotated 180° only when it is found, so the `smartpi1` images also serve the Smart Pad. On an HDMI monitor the orientation is untouched.

**Downloads (Smart Pi One and Smart Pad)**

| Distribution | Server | Desktop |
|---|---|---|
| **Debian 13 Trixie** | [![Download](https://img.shields.io/badge/Download-Trixie_Server-A81D33?logo=debian&logoColor=white)](https://github.com/Yumi-Lab/SmartPi-armbian/releases/download/v1.8.0-rc3/Yumi-smartpi1-trixie-debian13-server-2026-07-26-2006.img.xz){ target=_blank } | [![Download](https://img.shields.io/badge/Download-Trixie_Desktop-A81D33?logo=debian&logoColor=white)](https://github.com/Yumi-Lab/SmartPi-armbian/releases/download/v1.8.0-rc3/Yumi-smartpi1-trixie-debian13-desktop-2026-07-26-2006.img.xz){ target=_blank } |
| **Debian 12 Bookworm** | [![Download](https://img.shields.io/badge/Download-Bookworm_Server-A81D33?logo=debian&logoColor=white)](https://github.com/Yumi-Lab/SmartPi-armbian/releases/download/v1.8.0-rc3/Yumi-smartpi1-bookworm-debian12-server-2026-07-26-2006.img.xz){ target=_blank } | [![Download](https://img.shields.io/badge/Download-Bookworm_Desktop-A81D33?logo=debian&logoColor=white)](https://github.com/Yumi-Lab/SmartPi-armbian/releases/download/v1.8.0-rc3/Yumi-smartpi1-bookworm-debian12-desktop-2026-07-26-2006.img.xz){ target=_blank } |
| **Ubuntu 24.04 Noble** | [![Download](https://img.shields.io/badge/Download-Noble_Server-E95420?logo=ubuntu&logoColor=white)](https://github.com/Yumi-Lab/SmartPi-armbian/releases/download/v1.8.0-rc3/Yumi-smartpi1-noble-ubuntu24.04-server-2026-07-26-2006.img.xz){ target=_blank } | [![Download](https://img.shields.io/badge/Download-Noble_Desktop-E95420?logo=ubuntu&logoColor=white)](https://github.com/Yumi-Lab/SmartPi-armbian/releases/download/v1.8.0-rc3/Yumi-smartpi1-noble-ubuntu24.04-desktop-2026-07-26-2006.img.xz){ target=_blank } |
| **Ubuntu 22.04 Jammy** | [![Download](https://img.shields.io/badge/Download-Jammy_Server-E95420?logo=ubuntu&logoColor=white)](https://github.com/Yumi-Lab/SmartPi-armbian/releases/download/v1.8.0-rc3/Yumi-smartpi1-jammy-ubuntu22.04-server-2026-07-26-2006.img.xz){ target=_blank } | — |
| **Debian 11 Bullseye** (EOL) | [![Download](https://img.shields.io/badge/Download-Bullseye_Server-A81D33?logo=debian&logoColor=white)](https://github.com/Yumi-Lab/SmartPi-armbian/releases/download/v1.8.0-rc3/Yumi-smartpi1-bullseye-debian11-server-2026-07-26-2006.img.xz){ target=_blank } | — |

---

## 6. Lighter alternative — DietPi

[![DietPi for Smart Pi One](/img/SmartPi/OS/dietpi-banner.svg)](OS/SmartPi_DietPi.md)

Built from the v1.8.0 Debian 13 trixie server image, the [DietPi variant](OS/SmartPi_DietPi.md) trades the desktop and part of the base system for memory: about **293 MB** compressed and roughly **87 MB of RAM at idle**, with a first boot that configures itself with no screen and no keyboard. Headless only, and currently a release candidate.

---

## 7. Comparison

| | Debian 13 Trixie | Debian 12 Bookworm | Ubuntu 24.04 Noble | DietPi |
|---|---|---|---|---|
| **Status** | :material-star: Current stable | Previous stable | Current LTS | Release candidate |
| **Best for** | New installations | Proven stability | Ease of use | Low memory footprint |
| **Support** | Until 2028 (+ LTS 2030) | Until June 2028 | LTS until 2029 | Follows Debian 13 |
| **Desktop available** | :material-check-bold: Yes | :material-check-bold: Yes | :material-check-bold: Yes | :material-close-thick: No |
| **RAM at idle** | ~528 MB (server) | ~528 MB (server) | ~528 MB (server) | **~87 MB** |
| **Package manager** | apt | apt | apt | apt + `dietpi-software` |

---

## 8. Verify your board

Whichever image you flash, two commands confirm you are running the YUMI build:

```bash
cat /proc/device-tree/model
# YUMi SmartPi One

cat /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_max_freq
# 1368000
```

![Verifying a YUMI Linux image over SSH](/img/SmartPi/OS/smartpi-linux-terminal.svg){ .off-glb }

Every image ships with the 1368 MHz CPU overclock, our custom U-Boot (DRAM 576 MHz, ZQ calibration, ODT) and the `YUMi SmartPi One` device tree. Kernel packages are held with `apt-mark hold` so an upgrade cannot replace them with generic Armbian builds — see [what every YUMI image includes](OS/index.md#3-what-every-yumi-image-includes).

---

## 9. Next Step — Flash the image

[:material-sd: Flash guide — balenaEtcher](SmartPi_Linux_flash_sd.md){ .md-button .md-button--primary }
