# Vibe CLI on Smart Pi One

![Vibe CLI on Smart Pi One](/img/SmartPi/AI/vibe-cli-banner.svg){ .off-glb }

[Vibe CLI](https://github.com/Yumi-Lab/vibe-cli-smartpi){ target=_blank } is Mistral AI's official Vibe command-line assistant, packaged by YUMI-LAB to run on the 32-bit ARM (Allwinner H3 / armv7l) Smart Pi One and Smart Pad — hardware most modern AI CLIs cannot run on without emulation.

> **Repository:** [github.com/Yumi-Lab/vibe-cli-smartpi](https://github.com/Yumi-Lab/vibe-cli-smartpi){ target=_blank }

## 1. How it works

Vibe CLI is a **thin client**: the command-line tool runs locally on the board, but the AI inference happens remotely on Mistral's servers (model `mistral-vibe-cli-latest`). This keeps the heavy computation off the low-power Allwinner H3 — the board only handles the agent loop (tool calls, file edits, parsing), so there is **no emulation and no version pinning**. It installs as a native Python package via [uv](https://github.com/astral-sh/uv){ target=_blank }.

Because inference is remote, response latency is dominated by the Mistral API round-trip rather than the board's CPU.

## 2. Requirements

- `armv7l` / 32-bit ARM CPU (Allwinner H3 or compatible Cortex-A7)
- At least **1 GB RAM** (swap protection via `earlyoom`)
- A Debian-based Linux distribution with build essentials (tested on the Smart Pad — 4× Cortex-A7 @ 1.2 GHz, 1 GB RAM, Debian 13 armhf)
- A **Mistral API key** — create one at [console.mistral.ai](https://console.mistral.ai/){ target=_blank }

## 3. Installation

Run the one-line installer on your Smart Pi One **as a normal user (not root)**:

```bash
curl -fsSL https://raw.githubusercontent.com/Yumi-Lab/vibe-cli-smartpi/main/install.sh | bash
```

The first install compiles a few native dependencies from source and takes **~15 minutes** on the H3 (the build is bound to 2 CPU cores to keep temperatures in check). The installer adds `~/.local/bin` to your `PATH` via `~/.bashrc` and `~/.profile` — open a new shell afterwards.

## 4. Authentication

Vibe CLI needs a **Mistral API key** (unlike Claude Code and Grok CLI, which sign in with a subscription account). Provide it in one of three ways:

```bash
# 1. Interactive setup wizard
vibe --setup

# 2. Headless — write it to the env file
mkdir -p ~/.vibe && echo 'MISTRAL_API_KEY=sk-...' >> ~/.vibe/.env

# 3. Per-shell export
export MISTRAL_API_KEY=sk-...
```

## 5. Usage

| Command | Purpose |
| --- | --- |
| `vibe` | Full interactive TUI with prompts and session management |
| `vibe -p "your question"` | One-shot answer in programmatic mode |
| `vibe -p "your task" --yolo` | One-shot with auto-approval for all tool calls |
| `vibe --output streaming -p "…"` | Streaming, newline-delimited JSON output |
| `vibe -c` / `vibe --resume` | Continue or resume the previous session |
| `vibe --setup` | Configure your Mistral API key |
| `vibe --check-upgrade` | Check for and install updates |

In agent mode, Vibe CLI can read and edit files and run commands on the board — useful for scripting the GPIO sensors, configuring services, or working through Smart Pi projects.

![Example Vibe CLI session on a Smart Pi One](/img/SmartPi/AI/vibe-cli-terminal.svg){ .off-glb }
*Example session (illustration).*

## 6. Notes

- **Thin client:** your code and prompts are sent to Mistral's servers for inference. No large model runs on the board.
- **Thermals:** the one-time install compile is the hot part (~87 °C peak, 2-core bound); at rest the board sits around 68–70 °C.
- **Cold start:** the Python runtime adds a few seconds of startup latency per invocation (e.g. a version check takes ~7 s).
- Licensing: the installer scripts are MIT (YUMI-LAB); Mistral Vibe itself remains subject to Mistral AI's terms and is installed from the official distribution at runtime.
