# AI on Smart Pi One

The Smart Pi One and Smart Pad are 32-bit ARM (Allwinner H3 / armv7l) single-board computers. Most modern AI command-line tools ship only for 64-bit machines and refuse to install on this architecture. YUMI-LAB maintains dedicated installers that bring five of today's leading AI coding assistants to the board — running an interactive AI agent directly in the terminal, on hardware with as little as 1 GB of RAM.

## 1. Available AI Assistants

[![Claude Code CLI on Smart Pi One](/img/SmartPi/AI/claude-code-banner.svg)](SmartPi_AI_Claude_Code.md)

[![Grok CLI on Smart Pi One](/img/SmartPi/AI/grok-cli-banner.svg)](SmartPi_AI_Grok_CLI.md)

[![Kimi Code CLI on Smart Pi One](/img/SmartPi/AI/kimi-code-banner.svg)](SmartPi_AI_Kimi_Code.md)

[![Kimi CLI on Smart Pi One](/img/SmartPi/AI/kimi-cli-banner.svg)](SmartPi_AI_Kimi_CLI.md)

[![Vibe CLI on Smart Pi One](/img/SmartPi/AI/vibe-cli-banner.svg)](SmartPi_AI_Vibe_CLI.md)

## 2. At a glance

| Tool | Runs on the board | Sign-in | Core throttle | Repository |
| --- | --- | --- | --- | --- |
| ![](/img/SmartPi/AI/claude-logo.svg){ .off-glb width="18" } **[Claude Code CLI](SmartPi_AI_Claude_Code.md)** | **Native** — Node.js, no emulation | Claude Pro/Max account (OAuth, no API key) | `CLAUDE_CPUS` | [claude-code-smartpi](https://github.com/Yumi-Lab/claude-code-smartpi){ target=_blank } |
| ![](/img/SmartPi/AI/grok-logo.svg){ .off-glb width="18" } **[Grok CLI](SmartPi_AI_Grok_CLI.md)** | **Emulated** — QEMU user-mode (aarch64) | X (x.com) / grok.com account (device-auth, no API key) | `GROK_CPUS` | [grok-cli-smartpi](https://github.com/Yumi-Lab/grok-cli-smartpi){ target=_blank } |
| ![](/img/SmartPi/AI/kimi-logo.svg){ .off-glb width="18" } **[Kimi Code CLI](SmartPi_AI_Kimi_Code.md)** | **Native** — npm / Node 22 (TypeScript) | Kimi account (OAuth) or API key | `KIMI_CPUS` (`KIMI_CODE_CPUS`) | [kimi-code-smartpi](https://github.com/Yumi-Lab/kimi-code-smartpi){ target=_blank } |
| ![](/img/SmartPi/AI/kimi-logo.svg){ .off-glb width="18" } **[Kimi CLI](SmartPi_AI_Kimi_CLI.md)** | **Native** — Python via uv (lighter) | Kimi Code plan (OAuth) or `KIMI_API_KEY` | `KIMI_CPUS` + `KIMI_BUILD_CPUS` | [kimi-cli-smartpi](https://github.com/Yumi-Lab/kimi-cli-smartpi){ target=_blank } |
| ![](/img/SmartPi/AI/mistral-logo.svg){ .off-glb width="18" } **[Vibe CLI](SmartPi_AI_Vibe_CLI.md)** | **Native** — Python thin client | Mistral browser sign-in (PKCE) or `MISTRAL_API_KEY` | `VIBE_CPUS` + `VIBE_BUILD_CPUS` | [vibe-cli-smartpi](https://github.com/Yumi-Lab/vibe-cli-smartpi){ target=_blank } |

All five can sign in with your existing **provider account** — no API key, no separate developer billing. **Kimi Code CLI**, **Kimi CLI** and **Vibe CLI** additionally accept a direct API key if you prefer. (Kimi CLI and Kimi Code CLI are two separate Moonshot tools — see [which to choose](#6-which-one-should-i-choose).)

**Always the latest version.** Every project installs the **newest published release** of its CLI, natively where the platform allows (Grok is the exception: its official binary is 64-bit only, so it runs under emulation). The installer **is also the updater** — re-run it to move to the latest. Each repo ships a `<cli>-check-update` probe that prints `{installed, latest, update_available}`, and you can pin a specific version if you ever need to.

### Controlling CPU usage

Every CLI runs through a `taskset` / `nice` wrapper, so you can bound how much of the board it takes. There are two knobs:

- **`<CLI>_CPUS`** — cores used by the **running agent**: `CLAUDE_CPUS`, `GROK_CPUS`, `KIMI_CPUS` (`KIMI_CODE_CPUS`), `VIBE_CPUS`.
- **`<CLI>_BUILD_CPUS`** — cores used by the **one-time install compile**, where there is one: `KIMI_BUILD_CPUS`, `VIBE_BUILD_CPUS`.

Both default to **all 4 cores**. Capping them makes the board run cooler and stay responsive for other work — worth doing on a passively-cooled unit, or whenever a sustained load would otherwise heat the SoC enough to throttle or freeze it:

```bash
GROK_CPUS=0,1 grok                  # run the agent on 2 cores
KIMI_BUILD_CPUS=0,1 curl … | bash   # install/compile on 2 cores
```

On the 1 GB board the installers also enable **`earlyoom`** as a memory safety net, and the rule of thumb is **one heavy CLI at a time** (Claude Code, Grok and Kimi Code additionally ship a job daemon for running batches safely).

## 3. Install

Each tool installs with a single command on the board (run as a normal user, not root):

```bash
# Claude Code CLI
curl -fsSL https://raw.githubusercontent.com/Yumi-Lab/claude-code-smartpi/main/install.sh | bash

# Grok CLI
curl -fsSL https://raw.githubusercontent.com/Yumi-Lab/grok-cli-smartpi/main/install.sh | bash

# Kimi Code CLI (TypeScript)
curl -fsSL https://raw.githubusercontent.com/Yumi-Lab/kimi-code-smartpi/main/install.sh | bash

# Kimi CLI (Python)
curl -fsSL https://raw.githubusercontent.com/Yumi-Lab/kimi-cli-smartpi/main/install.sh | bash

# Vibe CLI
curl -fsSL https://raw.githubusercontent.com/Yumi-Lab/vibe-cli-smartpi/main/install.sh | bash
```

Re-run any of these later to update to the latest version. To keep the board cool during a compile, prefix the installer with its build knob — see [Controlling CPU usage](#controlling-cpu-usage).

## 4. Requirements

- A Smart Pi One or Smart Pad running a Debian-based Linux (see [Install Linux](../SmartPi_Linux.md))
- `armv7l` / 32-bit ARM CPU (Allwinner H3)
- At least **1 GB RAM**
- An active internet connection
- Access to the matching provider: a **Claude Pro/Max** account (Claude Code), an **X (x.com) or grok.com / SuperGrok** account (Grok CLI), a **Kimi account or API key** (Kimi Code CLI / Kimi CLI), or a **Mistral account or API key** (Vibe CLI)

## 5. What can you do with it?

These assistants run in **agent mode**: they can read and write files, run shell commands, and help you build and debug projects directly on the board. Typical uses on a Smart Pi One:

- Writing and fixing Python scripts for the GPIO sensors and modules
- Setting up services (Klipper, Home Assistant, media servers…)
- Explaining Linux commands and troubleshooting the system
- Prototyping small projects with a full conversational coding assistant

## 6. Which one should I choose?

All five give you an interactive terminal UI and one-shot (`-p "question"`) query mode. Pick the one that matches the account or key you already have:

- Choose **[Claude Code CLI](SmartPi_AI_Claude_Code.md)** if you have a Claude Pro or Max account. It runs natively as a Node.js tool (no emulation) and ships a job daemon for running many agents safely.
- Choose **[Grok CLI](SmartPi_AI_Grok_CLI.md)** if you have an X (x.com) or grok.com / SuperGrok account. It runs the official binary under QEMU emulation, with a warm daemon to keep repeat calls fast — watch thermals on long runs.
- Choose **[Kimi Code CLI](SmartPi_AI_Kimi_Code.md)** for Moonshot's newest tool (TypeScript, `kimi-code`) — local web UI, ACP, plugins, and a job daemon for batches. Native via npm + Node 22, at the cost of a heavier warm start per session.
- Choose **[Kimi CLI](SmartPi_AI_Kimi_CLI.md)** for the lighter Moonshot option (Python, `kimi`) — the quickest to start on a 1 GB board.
- Choose **[Vibe CLI](SmartPi_AI_Vibe_CLI.md)** if you have a Mistral account (or API key). It's a thin client — inference runs on Mistral's servers, so it's light on the board (the first install compiles for a few minutes).

**Two Moonshot tools:** `kimi-code` (Code CLI) is the TypeScript successor with the new features; `kimi` (Kimi CLI) is the lighter Python original. Both install side by side. Nothing stops you from installing all of them — just remember to run **one heavy CLI at a time**.
