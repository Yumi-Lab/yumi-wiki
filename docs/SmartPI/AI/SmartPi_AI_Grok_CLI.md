# Grok CLI on Smart Pi One

![Grok CLI on Smart Pi One](/img/SmartPi/AI/grok-cli-banner.svg){ .off-glb }

[Grok CLI](https://github.com/Yumi-Lab/grok-cli-smartpi){ target=_blank } is xAI's official Grok command-line assistant, packaged by YUMI-LAB to run on the 32-bit ARM (Allwinner H3 / armv7l) Smart Pi One and Smart Pad — hardware the standard installer normally rejects as unsupported.

> **Repository:** [github.com/Yumi-Lab/grok-cli-smartpi](https://github.com/Yumi-Lab/grok-cli-smartpi){ target=_blank }

## 1. How it works

The official Grok CLI is a static Rust binary built for 64-bit ARM. This project runs it through **user-mode QEMU emulation** (QEMU 7.2 from Debian bookworm, vendored with the installer — the last version that can emulate a 64-bit guest on a 32-bit host). A wrapper manages CPU affinity across the cores, and the TUI is rebuilt on top of the headless streaming mode for reliability. Startup on the board is around ~1.3 seconds.

## 2. Requirements

- `armv7l` / 32-bit ARM CPU (Allwinner H3)
- At least **1 GB RAM** recommended
- A Debian-based Linux distribution (tested on the Smart Pad — 4× Cortex-A7 @ 1.2 GHz, 1 GB RAM, Debian 13)
- An **X (x.com)** or **grok.com / SuperGrok** account — a standard X subscription works; no API key needed

## 3. Installation

Run the one-line installer on your Smart Pi One:

```bash
curl -fsSL https://raw.githubusercontent.com/Yumi-Lab/grok-cli-smartpi/main/install.sh | bash
```

The installer downloads the official Grok binary from xAI at install time, alongside the vendored QEMU runtime.

## 4. Authentication

Grok CLI signs in with your X (x.com) / grok.com account through a device-flow authorization — a standard X subscription works, no API key required, and no browser needed on the board itself.

```bash
grok login --device-auth
```

The CLI displays an `accounts.x.ai` URL and a verification code. Open the URL on **any** machine, enter the code to approve access, and the CLI detects the authorization automatically.

## 5. Usage

| Command | Purpose |
| --- | --- |
| `grok` | Interactive interface — menu navigation, live streaming, session resume (++ctrl+s++), scrolling, interrupt (++esc++) |
| `grok -p "your question"` | Single-shot answer, with agent mode enabled |
| `grok-live -p "your task"` | Streaming output with visible reasoning |
| `grok-chat` | Minimal conversation REPL |
| `grok models` | Show your account and available model information |

In agent mode, Grok CLI can read and edit files and run commands on the board — useful for scripting the GPIO sensors, configuring services, or working through Smart Pi projects.

![Example Grok CLI session on a Smart Pi One](/img/SmartPi/AI/grok-cli-terminal.svg){ .off-glb }
*Example session (illustration).*

## 6. Notes

- **Performance (measured on the H3):** ~1.3 s startup · `grok models` ~12 s · one-shot generation ~40 s · 68 °C idle, 78 °C peak on 2 cores.
- **Thermals:** because Grok runs under emulation, sustained loads run hot — a 4-core run once drove the H3 to ~102 °C and froze the machine. CPU allocation is set with `GROK_CPUS` (default `0,1,2,3` = all 4 cores); on a fanless board use `GROK_CPUS=0,1` to throttle without reinstalling.
- **Do not run `grok update`.** A self-update would fetch a 64-bit binary that cannot run on the board — to update, re-run the installer (`install.sh`) instead.
- Grok's native TUI is unstable under emulation, so the interactive interface is rebuilt on top of Grok's headless streaming mode (`grok-tui`) for reliability.
- **`earlyoom`** is enabled as a memory safety net on the 1 GB board. Rule of thumb: run **one heavy CLI at a time**.
- Licensing: the installer scripts are MIT; the vendored QEMU is GPL-2.0; the official Grok binary is downloaded from xAI at install time and remains subject to xAI's terms.
