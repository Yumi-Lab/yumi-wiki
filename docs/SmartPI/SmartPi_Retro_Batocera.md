# Batocera for Smart Pi One

![Batocera](/img/SmartPi/Retro_Gaming/Batocera/batocera-logo.png){ .off-glb width="140" }

## 1. Introduction

[Batocera Linux](https://batocera.org/){ target=_blank } is a full retrogaming distribution that boots straight into EmulationStation — no desktop, no setup wizard. YUMI-LAB maintains a fork with Smart Pi One (Allwinner H3) board support added: [Batocera-SmartPiOne](https://github.com/Yumi-Lab/Batocera-SmartPiOne){ target=_blank }.

!!! info "A fork of upstream Batocera"
    Only board-level additions on top of stock Batocera — a boot script, U-Boot DRAM tuning, and a device tree. Zero changes to emulators or the Batocera core, so [the official Batocera documentation](https://wiki.batocera.org/){ target=_blank } applies as-is: controls, scraping, netplay, themes, RetroAchievements.

## 2. RetroMi or Batocera?

Two different retrogaming images are available for the Smart Pi One, same hardware, different trade-offs:

| | RetroMi | Batocera |
|---|---|---|
| **Base** | Armbian Bookworm | Batocera Linux (its own OS) |
| **Systems** | 102 cores, 20 groups | 117 systems |
| **RetroAchievements** | No | Yes |
| **Updates** | Reflash | Atomic — swaps a single squashfs file |
| **ROM transfer** | Web FileBrowser, Samba, USB auto-mount, SCP | Samba (SMB), USB |
| **WiFi** | Onboard driver support | USB dongle only (RTL8188EU tested) |
| **Download size** | About 2.7 GB, split archive | About 1.1 GB, single file |
| **Status** | Actively developed | v38 — board support stable |

Not sure which one? [RetroMi](SmartPi_Retro_Gaming.md) has the wider emulator coverage and more ways to get ROMs onto the board. Batocera is the simpler, more polished pick if RetroAchievements and netplay matter to you.

## 3. Hardware notes

| Spec | Value |
|---|---|
| **SoC** | Allwinner H3 — Cortex-A7 quad-core |
| **RAM** | 1 GB DDR3 (576 MHz, custom tuning) |
| **GPU** | Mali-400 MP2 — Lima / Mesa (GLES 2.0) |
| **WiFi** | USB dongle required (RTL8188EU tested) |
| **Storage** | MicroSD, image about 1.1 GB, expands to fill the card |
| **Kernel** | Linux 6.1.55 |

!!! note "What to expect performance-wise"
    The H3 is roughly comparable to a Raspberry Pi 2. NES, SNES, Game Boy / Color / Advance, Mega Drive and Master System run at full speed. PS1, arcade boards (CPS1, CPS2, Neo-Geo), DOS and ScummVM run well on most titles. N64 and Dreamcast only handle light titles. PSP is not recommended on this hardware.

## 4. Download and flash

[:octicons-mark-github-16: Batocera-SmartPiOne releases](https://github.com/Yumi-Lab/Batocera-SmartPiOne/releases){ .md-button .md-button--primary target=_blank }

| File | Size | Release |
|---|---|---|
| [`batocera-h3-smartpione-38-20231018.img.gz`](https://github.com/Yumi-Lab/Batocera-SmartPiOne/releases/download/v38/batocera-h3-smartpione-38-20231018.img.gz){ target=_blank } | 1.21 GB | v38 — 2026-04-07 |

**Flash** with [Raspberry Pi Imager](https://www.raspberrypi.com/software/){ target=_blank } or [balenaEtcher](https://etcher.balena.io/){ target=_blank } (both read `.img.gz` directly), or with `dd`:

```bash
gunzip batocera-h3-smartpione-38-20231018.img.gz
sudo dd if=batocera-h3-smartpione-38-20231018.img of=/dev/sdX bs=1M status=progress
sync
```

## 5. First boot

1. Insert the microSD card, connect HDMI and a gamepad, power on.
2. Batocera boots to EmulationStation in roughly 60 to 90 seconds.
3. Configure WiFi from the EmulationStation menu — a USB WiFi dongle is required, the Smart Pi One has no onboard WiFi.
4. Add ROMs over the network share (SMB) or a USB drive.

## 6. Supported systems (117)

| | | | |
|---|---|---|---|
| Abuse | Amiga 500 | Amiga 1200 | Amiga CD32 |
| Amiga CDTV | Amstrad CPC | Amstrad GX4000 | Apple II |
| Apple IIGS | Arduboy | Atari 2600 | Atari 5200 |
| Atari 7800 | Atari 800 | Atari Lynx | Atari ST |
| Atomiswave | Cannonball | Cave Story | C-Dogs SDL |
| Channel F | ColecoVision | Commodore 64 | Commodore 128 |
| Commodore PET | Commodore Plus/4 | Commodore VIC-20 | Commander Genius |
| Daphne | DevilutionX | DOS | Dreamcast |
| EasyRPG | Famicom Disk System | FinalBurn Neo | Flash |
| Game & Watch | Game Boy | Game Boy (2 Players) | Game Boy Advance |
| Game Boy Color | Game Boy Color (2P) | Game Gear | HCL |
| Hurrican | Intellivision | LowRes NX | Macintosh |
| MAME | Master System | Mega Drive | Mega Duck |
| Moonlight | Mr. Boom | MSU-MD | MSX |
| MSX2 | MSX2+ | MSX turboR | Multivision |
| Naomi | Neo-Geo | Neo-Geo CD | Neo-Geo Pocket |
| Neo-Geo Pocket Color | NES | Nintendo 64 | Nintendo 64DD |
| Odyssey² | OpenBOR | PC-88 | PC-98 |
| PC Engine | PC Engine CD | PICO-8 | Sega Pico |
| PlayStation | Pokémon Mini | Ports | PrBoom (Doom) |
| PSP | Quake III | SAM Coupé | Satellaview |
| ScummVM | SCV | SDLPoP (Prince of Persia) | Sega 32X |
| Sega CD | SG-1000 | Sharp X1 | Sharp X68000 |
| SNES | SNES MSU-1 | Solarus | Sonic Retro |
| Sufami Turbo | Super Bros War | Super Game Boy | SuperGrafx |
| Supervision | TheXTech | Thomson | TIC-80 |
| Tyrian | TyrQuake | Vectrex | Videopac+ |
| Virtual Boy | WonderSwan | WonderSwan Color | Xash3D FWGS (Half-Life) |
| XRick | ZC210 | ZX81 | ZX Spectrum |
| OD Commander | | | |

## 7. What YUMI-LAB changed

Board-level additions only — no changes to emulators or the Batocera core:

| File | Change |
|---|---|
| `board/batocera/allwinner/h3/smartpi-one/` | New board: boot script, genimage, extlinux |
| `package/batocera/boot/uboot-multiboard/nanopi_m1/` | U-Boot DRAM tuning (576 MHz, ZQ calibration, ODT) |
| `configs/batocera-h3.board` | Added the `sun8i-h3-nanopi-m1` device tree |

!!! note "Board profile"
    v38 builds on the `orangepi-pc` board profile, which is fully compatible with the Smart Pi One's H3 through the `nanopi_m1` device tree. A dedicated `smartpi-one` board profile is prepared for a future build.

## 8. Notes

- **Status:** v38, board support stable. Source: [github.com/Yumi-Lab/Batocera-SmartPiOne](https://github.com/Yumi-Lab/Batocera-SmartPiOne){ target=_blank }. License: MIT.
- **Full Batocera documentation** — controls, scraping, netplay, themes, RetroAchievements: [wiki.batocera.org](https://wiki.batocera.org/){ target=_blank }.
- **Want more emulators and more ways to move ROMs onto the board?** See [RetroMi](SmartPi_Retro_Gaming.md).
