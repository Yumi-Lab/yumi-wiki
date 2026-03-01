# 1.3 Official Linux Image — Smart Pi One

Official Armbian-based images optimized for the **YUMI Smart Pi One** (Allwinner H3).

---

## Requirements

!!! warning "microSD Card Compatibility"
    - **Minimum:** 4 GB
    - **Maximum: 32 GB** — larger cards are not supported by the Smart Pi One

---

## Latest Release

!!! success "v1.6.0 — March 1, 2026"
    All images are server editions (headless). Choose your preferred Linux distribution below.

    [:octicons-mark-github-16: View all releases on GitHub](https://github.com/Yumi-Lab/SmartPi-armbian/releases/latest){ .md-button .md-button--primary }

---

## Download

=== ":simple-debian: Debian"

    | Version | Status | Download |
    |---|---|---|
    | **Debian 12 Bookworm** | :material-star: Recommended | [![Download](https://img.shields.io/badge/Download-Bookworm_Server-A81D33?logo=debian&logoColor=white)](https://github.com/Yumi-Lab/SmartPi-armbian/releases/download/1.6.0/Yumi-smartpi1-bookworm-debian12-server-2026-03-01-1826.img.xz) |
    | **Debian 11 Bullseye** | Stable (LTS) | [![Download](https://img.shields.io/badge/Download-Bullseye_Server-A81D33?logo=debian&logoColor=white)](https://github.com/Yumi-Lab/SmartPi-armbian/releases/download/1.6.0/Yumi-smartpi1-bullseye-debian11-server-2026-03-01-1826.img.xz) |
    | **Debian 13 Trixie** | Testing | [![Download](https://img.shields.io/badge/Download-Trixie_Server-A81D33?logo=debian&logoColor=white)](https://github.com/Yumi-Lab/SmartPi-armbian/releases/download/1.6.0/Yumi-smartpi1-trixie-debian13-server-2026-03-01-1826.img.xz) |

    !!! tip "Which Debian version to choose?"
        **Bookworm (12)** is the current stable release — use it for any new installation.
        Bullseye (11) is for existing setups. Trixie (13) is for advanced users who want the latest packages.

=== ":simple-ubuntu: Ubuntu"

    | Version | Status | Download |
    |---|---|---|
    | **Ubuntu 22.04 Jammy** | LTS | [![Download](https://img.shields.io/badge/Download-Jammy_Server-E95420?logo=ubuntu&logoColor=white)](https://github.com/Yumi-Lab/SmartPi-armbian/releases/download/1.6.0/Yumi-smartpi1-jammy-ubuntu22.04-server-2026-03-01-1826.img.xz) |
    | **Ubuntu 24.04 Noble** | LTS | [![Download](https://img.shields.io/badge/Download-Noble_Server-E95420?logo=ubuntu&logoColor=white)](https://github.com/Yumi-Lab/SmartPi-armbian/releases/download/1.6.0/Yumi-smartpi1-noble-ubuntu24.04-server-2026-03-01-1826.img.xz) |

    !!! tip "Which Ubuntu version to choose?"
        Both are **Long Term Support (LTS)** versions supported until 2027 and 2029 respectively.
        **Noble (24.04)** is the most recent — recommended for new installations.

---

## Comparison

| | Debian 12 Bookworm | Ubuntu 24.04 Noble |
|---|---|---|
| **Best for** | Stability, servers | Latest packages |
| **Support** | ~5 years | LTS until 2029 |
| **Package manager** | apt | apt |
| **Default shell** | bash | bash |
| **Recommended** | :material-check-bold: Yes | For advanced users |

---

## Next Step — Flash the image

Once downloaded, flash the image to your microSD card:

[:material-sd: Flash guide — balenaEtcher](https://wiki.yumi-lab.com/SmartPI/SmartPi_Linux_flash_sd/){ .md-button }
