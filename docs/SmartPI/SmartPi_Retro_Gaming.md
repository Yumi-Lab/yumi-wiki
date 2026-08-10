# RetroMi

![EmulationStation on a Smart Pi One](/img/SmartPi/Retro_Gaming/bootemulationstation.png)

## 1. Introduction

RetroMi is YUMI-LAB's retrogaming image for the Smart Pi One: a ready-to-flash Armbian Bookworm build with EmulationStation, RetroArch and over 100 pre-compiled emulator cores — Dreamcast, N64 and PSP included, plus PC game streaming via Moonlight. Everything ships pre-compiled for armhf, so there is nothing to build on the device itself.

!!! info "Actively developed"
    RetroMi is maintained by YUMI-LAB at [github.com/Yumi-Lab/RetroMi](https://github.com/Yumi-Lab/RetroMi){ target=_blank }. Report issues there.

Prefer a simpler, more polished out-of-the-box experience with RetroAchievements? See [Batocera](SmartPi_Retro_Batocera.md) instead.

## 2. What you get

| Feature | Detail |
|---|---|
| **EmulationStation** | EpicNoir theme pre-installed, 200+ additional themes via the built-in downloader |
| **RetroArch** | 100+ libretro cores, tuned for the Mali-400 GPU |
| **Controllers** | 237 gamepads recognised out of the box — PS3, PS4, PS5, Xbox, Switch Pro, 8BitDo, Logitech |
| **Dreamcast** | Flycast (GLES2) — playable on the H3 |
| **Moonlight** | Stream from a PC running Sunshine, with HEVC hardware decode |
| **File access** | Samba shares plus a web-based FileBrowser (port 80) for ROMs, BIOS and configs |
| **USB auto-mount** | Plug a USB drive with a `RetroPie/roms/<system>/` layout — ROMs are picked up automatically |
| **Bezels** | Decorative overlays for 19 systems, from TheBezelProject |

## 3. Supported systems

102 cores across 20 groups:

| Group | Systems |
|---|---|
| `nintendo` | NES, SNES, Game Boy / Color, GBA (13 cores) |
| `n64` | Nintendo 64, PC Engine / TurboGrafx (5 cores) |
| `sega` | Mega Drive, Sega CD, 32X, Master System, Game Gear, Neo Geo CD |
| `sony` | PlayStation 1 |
| `psp` | PlayStation Portable (PPSSPP) |
| `arcade` | FBNeo — Arcade, Neo Geo, CPS1-2-3 |
| `arcade-compat` | MAME 2000 / 2003 / 2003+ / 2010, FBAlpha2012 |
| `heavy` | Nintendo DS, Dreamcast, Saturn, 3DO, Jaguar |
| `amiga` | Amiga (uae4arm, PUAE) |
| `computers` | C64, MSX, Atari 8-bit, ZX Spectrum, Amstrad CPC, Atari ST, Apple II, BBC Micro, Enterprise 128 |
| `japan-computers` | PC-98, PC-88, X68000, Sharp X1 |
| `portables` | Neo Geo Pocket, Lynx, Virtual Boy, WonderSwan, Pokémon Mini, Arduboy, Vectrex, Game & Watch |
| `dosbox` | DOSBox Pure |
| `scummvm` | ScummVM — 250+ point-and-click adventures |
| `openbor` | OpenBOR (beat 'em up engine) |
| `misc` | Doom, Quake, Atari 2600, PICO-8, WASM-4, TIC-80, EasyRPG, Cave Story, Java ME |
| `moonlight` | PC game streaming (Sunshine / NVIDIA) |
| `skyscraper` | Game metadata and artwork scraper |
| `retroarch` | RetroArch frontend and assets |
| `emulationstation` | EmulationStation frontend |

## 4. Download and flash

**1. Download** both parts of the current release, `1.0.4`, from the [release page](https://github.com/Yumi-Lab/RetroMi/releases){ target=_blank } — the image is split in two to stay under GitHub's 2 GiB file limit:

| File | Size |
|---|---|
| [`2026-03-08-RetroMi-1.0.4-armbian-RetroMi.img.7z.001`](https://github.com/Yumi-Lab/RetroMi/releases/download/1.0.4/2026-03-08-RetroMi-1.0.4-armbian-RetroMi.img.7z.001){ target=_blank } | 1.99 GB |
| [`2026-03-08-RetroMi-1.0.4-armbian-RetroMi.img.7z.002`](https://github.com/Yumi-Lab/RetroMi/releases/download/1.0.4/2026-03-08-RetroMi-1.0.4-armbian-RetroMi.img.7z.002){ target=_blank } | 785 MB |

The matching `.sha256` files and the full changelog are on the release page.

**2. Extract** — both files must sit in the same folder:

=== "Linux"

    ```bash
    7z x 2026-03-08-RetroMi-1.0.4-armbian-RetroMi.img.7z.001
    sha256sum -c 2026-03-08-RetroMi-1.0.4-armbian-RetroMi.img.7z.sha256
    ```

=== "macOS"

    Open `.img.7z.001` with [Keka](https://www.keka.io/){ target=_blank } or [The Unarchiver](https://theunarchiver.com/){ target=_blank } — it picks up `.002` automatically.

=== "Windows"

    Right-click `.img.7z.001` → **Extract Here**, using [7-Zip](https://7-zip.org/){ target=_blank }.

**3. Flash** the extracted `.img` with [Raspberry Pi Imager](https://www.raspberrypi.com/software/){ target=_blank } (*Choose OS → Use custom*), [balenaEtcher](https://etcher.balena.io/){ target=_blank }, or `dd`:

```bash
sudo dd if=RetroMi-*.img of=/dev/sdX bs=4M status=progress
```

With `dd`, double-check `/dev/sdX`: writing to the wrong device will destroy it.

## 5. First boot

Insert the card into the Smart Pi One and power on. First boot takes 2 to 3 minutes while RetroMi finishes its initial setup, then EmulationStation starts.

## 6. Default accounts

| Service | User | Password |
|---|---|---|
| **SSH** | `pi` | `yumi` |
| **FileBrowser** (port 80) | `admin` | `RetroMi2026!` |
| **FileBrowser** (port 80) | `pi` | `YumiRetroMi25` |

!!! danger "Change the passwords"
    Change both, right after the first login.

## 7. Adding ROMs

Three ways in:

- **FileBrowser** — browse to `http://<device-ip>/`, navigate to `RetroPie/roms/<system>/` and upload your files
- **USB** — build the same `RetroPie/roms/<system>/` structure on a USB drive and plug it in; ROMs are detected and linked automatically
- **SCP** — `scp game.zip pi@<device-ip>:/home/pi/RetroPie/roms/<system>/`

Restart EmulationStation, or reboot, to refresh the game list.

## 8. WiFi

From the EmulationStation menu: **RetroPie → Wi-Fi**. Or over SSH:

```bash
sudo nmtui
```

## 9. Controller setup

The first time EmulationStation starts, it asks you to map a controller. The full walkthrough — button mapping, hotkeys, supported layouts, troubleshooting — has its own page:

[Controller Setup for RetroMi](SmartPi_Retro_Controller_Setup.md){ .md-button }

## 10. Architecture

RetroMi is built in three layers:

```
Layer 1 — SmartPi-armbian   : Armbian Bookworm server base (armhf)
Layer 2 — RetroMi-packages  : 102 pre-compiled libretro cores (20 groups)
Layer 3 — RetroMi           : themes, config, modules, controllers, bezels
```

Layer 2 is built separately via QEMU armhf in Docker, so nothing compiles on the device itself.

## 11. Notes

- **Status:** actively developed. Current release: **1.0.4** (2026-03-08).
- **Source:** [github.com/Yumi-Lab/RetroMi](https://github.com/Yumi-Lab/RetroMi){ target=_blank }. License: GPL-3.0.
- **Want RetroAchievements and a simpler, atomic-update system instead?** See [Batocera](SmartPi_Retro_Batocera.md) — fewer emulators (117 systems, standalone), but a more polished out-of-the-box experience.
