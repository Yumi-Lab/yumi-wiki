# 1.3 Official Linux Image

Official Armbian-based images for **YUMI Smart Pi One** and **YUMI Smart Pad** (Allwinner H3).

We offer several Linux distributions optimized for our boards, in both **Server** (headless) and **Desktop** (GUI) editions. Choose the one that best fits your needs:

- **Debian 12 Bookworm** (the YUMI team's choice) — Previous stable release, supported until June 2028. Proven stability and security, ideal for production environments. Extensive package catalog and strong community support.
- **Debian 13 Trixie** — Current stable release (since August 2025). Latest packages, supported until 2028 + LTS until 2030. Recommended for new installations that want the most up-to-date software.
- **Debian 11 Bullseye** — End-of-life (EOL). Provided for legacy compatibility only, no longer recommended for new installations. Server only.
- **Ubuntu 24.04 Noble** — Current LTS release, supported until April 2029. User-friendly with abundant documentation, ideal for beginners.
- **Ubuntu 22.04 Jammy** — Previous LTS, standard support until April 2027. Use Noble (24.04) for new installations.

!!! tip "Debian or Ubuntu?"
    **Debian** is preferred for its proven stability and lightweight footprint. **Ubuntu** shines for its ease of use and quick access to new features. Both use `apt` as package manager.

Once you have downloaded the image of your choice, follow the [flash guide](SmartPi_Linux_flash_sd.md) to transfer it to a microSD card.

---

## Requirements

!!! warning "microSD Card Compatibility"
    - **Minimum:** 4 GB
    - **Maximum: 32 GB** — larger cards are not supported

---

## Latest Release

!!! success "v1.6.0 — March 1, 2026"
    Server and Desktop editions available. Select your device and preferred Linux distribution below.

    [:octicons-mark-github-16: View all releases on GitHub](https://github.com/Yumi-Lab/SmartPi-armbian/releases/latest){ .md-button .md-button--primary target=_blank }

---

## Download — Smart Pi One (screenless / external display)

=== ":simple-debian: Debian — Server"

    | Version | Status | Release | Download |
    |---|---|---|---|
    | **Debian 12 Bookworm** | :material-star: Recommended | v1.6.0 — 2026-03-01 | [![Download](https://img.shields.io/badge/Download-Bookworm_Server-A81D33?logo=debian&logoColor=white)](https://github.com/Yumi-Lab/SmartPi-armbian/releases/download/v1.6.0/Yumi-smartpi1-bookworm-debian12-server-2026-03-01-2139.img.xz){ target=_blank } |
    | **Debian 13 Trixie** | Stable | v1.6.0 — 2026-03-01 | [![Download](https://img.shields.io/badge/Download-Trixie_Server-A81D33?logo=debian&logoColor=white)](https://github.com/Yumi-Lab/SmartPi-armbian/releases/download/v1.6.0/Yumi-smartpi1-trixie-debian13-server-2026-03-01-2139.img.xz){ target=_blank } |
    | **Debian 11 Bullseye** | EOL | v1.6.0 — 2026-03-01 | [![Download](https://img.shields.io/badge/Download-Bullseye_Server-A81D33?logo=debian&logoColor=white)](https://github.com/Yumi-Lab/SmartPi-armbian/releases/download/v1.6.0/Yumi-smartpi1-bullseye-debian11-server-2026-03-01-2139.img.xz){ target=_blank } |

    !!! tip "Which version?"
        **Trixie (13)** is the current stable release — recommended for new installations.
        **Bookworm (12)** remains a solid choice for proven stability.
        Bullseye (11) is end-of-life — only use it for legacy setups.

=== ":simple-debian: Debian — Desktop"

    | Version | Status | Release | Download |
    |---|---|---|---|
    | **Debian 12 Bookworm** | :material-star: Recommended | v1.6.0 — 2026-03-01 | [![Download](https://img.shields.io/badge/Download-Bookworm_Desktop-A81D33?logo=debian&logoColor=white)](https://github.com/Yumi-Lab/SmartPi-armbian/releases/download/v1.6.0/Yumi-smartpi1-bookworm-debian12-desktop-2026-03-01-2139.img.xz){ target=_blank } |
    | **Debian 13 Trixie** | Stable | v1.6.0 — 2026-03-01 | [![Download](https://img.shields.io/badge/Download-Trixie_Desktop-A81D33?logo=debian&logoColor=white)](https://github.com/Yumi-Lab/SmartPi-armbian/releases/download/v1.6.0/Yumi-smartpi1-trixie-debian13-desktop-2026-03-01-2139.img.xz){ target=_blank } |

    !!! info "No Bullseye Desktop"
        Debian 11 Bullseye is end-of-life — no desktop image is provided for this version.

=== ":simple-ubuntu: Ubuntu — Server"

    | Version | Status | Release | Download |
    |---|---|---|---|
    | **Ubuntu 24.04 Noble** | :material-star: Recommended (LTS) | v1.6.0 — 2026-03-01 | [![Download](https://img.shields.io/badge/Download-Noble_Server-E95420?logo=ubuntu&logoColor=white)](https://github.com/Yumi-Lab/SmartPi-armbian/releases/download/v1.6.0/Yumi-smartpi1-noble-ubuntu24.04-server-2026-03-01-2139.img.xz){ target=_blank } |
    | **Ubuntu 22.04 Jammy** | LTS | v1.6.0 — 2026-03-01 | [![Download](https://img.shields.io/badge/Download-Jammy_Server-E95420?logo=ubuntu&logoColor=white)](https://github.com/Yumi-Lab/SmartPi-armbian/releases/download/v1.6.0/Yumi-smartpi1-jammy-ubuntu22.04-server-2026-03-01-2139.img.xz){ target=_blank } |

    !!! tip "Which version?"
        **Noble (24.04)** is the current LTS — recommended for new installations (supported until 2029).
        Jammy (22.04) standard support ends April 2027 — migrate to Noble when possible.

=== ":simple-ubuntu: Ubuntu — Desktop"

    | Version | Status | Release | Download |
    |---|---|---|---|
    | **Ubuntu 24.04 Noble** | :material-star: Recommended (LTS) | v1.6.0 — 2026-03-01 | [![Download](https://img.shields.io/badge/Download-Noble_Desktop-E95420?logo=ubuntu&logoColor=white)](https://github.com/Yumi-Lab/SmartPi-armbian/releases/download/v1.6.0/Yumi-smartpi1-noble-ubuntu24.04-desktop-2026-03-01-2139.img.xz){ target=_blank } |
    | **Ubuntu 22.04 Jammy** | LTS | v1.6.0 — 2026-03-01 | [![Download](https://img.shields.io/badge/Download-Jammy_Desktop-E95420?logo=ubuntu&logoColor=white)](https://github.com/Yumi-Lab/SmartPi-armbian/releases/download/v1.6.0/Yumi-smartpi1-jammy-ubuntu22.04-desktop-2026-03-01-2139.img.xz){ target=_blank } |

---

## Download — [Smart Pad](../KlipperSmartPad/SmartPad_specifications.md) (integrated touchscreen)

=== ":simple-debian: Debian — Server"

    | Version | Status | Release | Download |
    |---|---|---|---|
    | **Debian 12 Bookworm** | :material-star: Recommended | v1.6.0 — 2026-03-01 | [![Download](https://img.shields.io/badge/Download-Bookworm_Server-A81D33?logo=debian&logoColor=white)](https://github.com/Yumi-Lab/SmartPi-armbian/releases/download/v1.6.0/Yumi-smartpad-bookworm-debian12-server-2026-03-01-2139.img.xz){ target=_blank } |
    | **Debian 13 Trixie** | Stable | v1.6.0 — 2026-03-01 | [![Download](https://img.shields.io/badge/Download-Trixie_Server-A81D33?logo=debian&logoColor=white)](https://github.com/Yumi-Lab/SmartPi-armbian/releases/download/v1.6.0/Yumi-smartpad-trixie-debian13-server-2026-03-01-2139.img.xz){ target=_blank } |
    | **Debian 11 Bullseye** | EOL | v1.6.0 — 2026-03-01 | [![Download](https://img.shields.io/badge/Download-Bullseye_Server-A81D33?logo=debian&logoColor=white)](https://github.com/Yumi-Lab/SmartPi-armbian/releases/download/v1.6.0/Yumi-smartpad-bullseye-debian11-server-2026-03-01-2139.img.xz){ target=_blank } |

    !!! tip "Which version?"
        **Trixie (13)** is the current stable — recommended for new installations.
        **Bookworm (12)** remains a solid choice for proven stability.

=== ":simple-debian: Debian — Desktop"

    | Version | Status | Release | Download |
    |---|---|---|---|
    | **Debian 12 Bookworm** | :material-star: Recommended | v1.6.0 — 2026-03-01 | [![Download](https://img.shields.io/badge/Download-Bookworm_Desktop-A81D33?logo=debian&logoColor=white)](https://github.com/Yumi-Lab/SmartPi-armbian/releases/download/v1.6.0/Yumi-smartpad-bookworm-debian12-desktop-2026-03-01-2139.img.xz){ target=_blank } |
    | **Debian 13 Trixie** | Stable | v1.6.0 — 2026-03-01 | [![Download](https://img.shields.io/badge/Download-Trixie_Desktop-A81D33?logo=debian&logoColor=white)](https://github.com/Yumi-Lab/SmartPi-armbian/releases/download/v1.6.0/Yumi-smartpad-trixie-debian13-desktop-2026-03-01-2139.img.xz){ target=_blank } |

    !!! info "No Bullseye Desktop"
        Debian 11 Bullseye is end-of-life — no desktop image is provided for this version.

=== ":simple-ubuntu: Ubuntu — Server"

    | Version | Status | Release | Download |
    |---|---|---|---|
    | **Ubuntu 24.04 Noble** | :material-star: Recommended (LTS) | v1.6.0 — 2026-03-01 | [![Download](https://img.shields.io/badge/Download-Noble_Server-E95420?logo=ubuntu&logoColor=white)](https://github.com/Yumi-Lab/SmartPi-armbian/releases/download/v1.6.0/Yumi-smartpad-noble-ubuntu24.04-server-2026-03-01-2139.img.xz){ target=_blank } |
    | **Ubuntu 22.04 Jammy** | LTS | v1.6.0 — 2026-03-01 | [![Download](https://img.shields.io/badge/Download-Jammy_Server-E95420?logo=ubuntu&logoColor=white)](https://github.com/Yumi-Lab/SmartPi-armbian/releases/download/v1.6.0/Yumi-smartpad-jammy-ubuntu22.04-server-2026-03-01-2139.img.xz){ target=_blank } |

    !!! tip "Which version?"
        **Noble (24.04)** is the current LTS — recommended for new installations (supported until 2029).
        Jammy (22.04) standard support ends April 2027 — migrate to Noble when possible.

=== ":simple-ubuntu: Ubuntu — Desktop"

    | Version | Status | Release | Download |
    |---|---|---|---|
    | **Ubuntu 24.04 Noble** | :material-star: Recommended (LTS) | v1.6.0 — 2026-03-01 | [![Download](https://img.shields.io/badge/Download-Noble_Desktop-E95420?logo=ubuntu&logoColor=white)](https://github.com/Yumi-Lab/SmartPi-armbian/releases/download/v1.6.0/Yumi-smartpad-noble-ubuntu24.04-desktop-2026-03-01-2139.img.xz){ target=_blank } |
    | **Ubuntu 22.04 Jammy** | LTS | v1.6.0 — 2026-03-01 | [![Download](https://img.shields.io/badge/Download-Jammy_Desktop-E95420?logo=ubuntu&logoColor=white)](https://github.com/Yumi-Lab/SmartPi-armbian/releases/download/v1.6.0/Yumi-smartpad-jammy-ubuntu22.04-desktop-2026-03-01-2139.img.xz){ target=_blank } |

---

## Comparison

| | Debian 13 Trixie | Debian 12 Bookworm | Ubuntu 24.04 Noble |
|---|---|---|---|
| **Status** | :material-star: Current stable | Previous stable | Current LTS |
| **Best for** | New installations | Proven stability | Ease of use |
| **Support** | Until 2028 (+ LTS 2030) | Until June 2028 | LTS until 2029 |
| **Desktop available** | :material-check-bold: Yes | :material-check-bold: Yes | :material-check-bold: Yes |
| **Package manager** | apt | apt | apt |
| **Recommended** | :material-check-bold: Yes | :material-check-bold: Yes | For Ubuntu users |

---

## Next Step — Flash the image

[:material-sd: Flash guide — balenaEtcher](https://wiki.yumi-lab.com/SmartPI/SmartPi_Linux_flash_sd/){ .md-button target=_blank }
