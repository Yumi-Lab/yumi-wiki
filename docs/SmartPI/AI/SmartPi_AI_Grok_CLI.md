# Grok CLI on Smart Pi One

![Grok CLI on Smart Pi One](/img/SmartPi/AI/grok-cli-banner.svg){ .off-glb }

[Grok CLI](https://github.com/Yumi-Lab/grok-cli-smartpi){ target=_blank } is xAI's official Grok command-line assistant, packaged by YUMI-LAB to run on the 32-bit ARM (Allwinner H3 / armv7l) Smart Pi One and Smart Pad — hardware the standard installer rejects as unsupported.

> **Repository:** [github.com/Yumi-Lab/grok-cli-smartpi](https://github.com/Yumi-Lab/grok-cli-smartpi){ target=_blank }

## 1. How it works

The official Grok CLI is a static Rust binary built for 64-bit ARM, so this project runs it through **user-mode QEMU emulation**. Two engines are installed: **YUMI-LAB's QEMU fork** (default — patched for correct 64-bit atomics on the Cortex-A7, which is what keeps the official native TUI and long multi-threaded runs stable) and a **vendored QEMU 7.2** as the automatic fallback (force it with `GROK_QEMU=7.2`). A wrapper runs the emulation at low priority across the cores (`GROK_CPUS`). The installer fetches the latest published Grok and **doubles as the updater** — re-run it to update.

Because a cold start pays an emulated bootstrap, a small **warm daemon** keeps one agent process ready so repeat `grok -p` calls answer quickly; it stops itself when idle.

## 2. Requirements

- `armv7l` / 32-bit ARM CPU (Allwinner H3)
- At least **1 GB RAM**
- A Debian-based Linux distribution (tested on the Smart Pad — Debian 13 trixie armhf)
- An **X (x.com)** or **grok.com / SuperGrok** account — a standard X subscription works; no API key needed
- root/sudo for the **first** install only (installs into `/opt/grok`); updates then run unprivileged

## 3. Installation

```bash
curl -fsSL https://raw.githubusercontent.com/Yumi-Lab/grok-cli-smartpi/main/install.sh | bash
```

Re-run it any time to move to the latest. To pin a version: `GROK_VERSION=<version> …`. The installer also enables `earlyoom` for memory safety on the 1 GB board.

## 4. Authentication

Grok CLI signs in with your X (x.com) / grok.com account through a device-flow authorization — a standard X subscription works, no API key required, and no browser needed on the board itself.

```bash
grok login --device-auth
```

The CLI displays an `accounts.x.ai` URL and a verification code. Open the URL on **any** machine, enter the code to approve access, and the CLI detects the authorization automatically.

## 5. Usage

| Command | Purpose |
| --- | --- |
| `grok` | The native interactive TUI — the official interface (falls back to the legacy `grok-tui` on the 7.2 engine or with `GROK_TUI=python`) |
| `grok -p "your question"` | One-shot answer through the **warm daemon** — fast once warm (`GROK_DAEMON=0` for the old direct behaviour) |
| `grok-daemon status\|stop` | Inspect / stop the warm agent daemon (stops itself when idle) |
| `grok-live -p "your task"` | One-shot with readable streaming (dimmed reasoning) |
| `grok-chat` | Minimal multi-turn REPL |
| `grok models` | Show the signed-in account and model |
| `grok-check-update` | OTA probe — one JSON line |
| `GROK_CPUS=0,1 grok …` | Run on a CPU subset for this launch (default = all 4 cores) |

Engine selection: the YUMI-LAB QEMU fork is the default; `GROK_QEMU=7.2` forces the vendored 7.2 engine (also the automatic fallback).

![Grok CLI interface on a Smart Pi One](/img/SmartPi/AI/grok-cli-terminal.svg){ .off-glb }
*Live interface captured on a Yumi board (armv7l, Yumi OS 26.05).*

## 6. Updating (OTA)

- **Update:** re-run `install.sh` — that *is* the updater (exits fast when already newest; `GROK_FORCE=1` to reinstall, `GROK_VERSION=<version>` to pin).
- **Check:** `grok-check-update` prints one JSON line (`{installed, latest, update_available}`).
- ⚠️ **Never run `grok update`** — it would install a binary outside the wrapper; re-run `install.sh` instead.

## 7. Notes

- **Emulated, so mind the start:** a cold one-shot pays an emulated bootstrap and is slow; the **warm daemon** makes repeat `grok -p` calls fast. The interactive TUI stays responsive on the fork engine.
- **Thermals:** sustained emulated loads run hot and can freeze the board — cap the cores with `GROK_CPUS` (e.g. `GROK_CPUS=0,1`) to run cooler. Default is all 4 cores.
- **`earlyoom`** is enabled as a memory safety net on the 1 GB board. Rule of thumb: run **one heavy CLI at a time**.
- Licensing: the installer scripts are MIT (YUMI-LAB); the vendored QEMU is GPL-2.0; the official Grok binary is downloaded from xAI at install time and is not redistributed here.
