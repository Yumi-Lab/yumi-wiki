# AI on Smart Pi One

The Smart Pi One and Smart Pad are 32-bit ARM (Allwinner H3 / armv7l) single-board computers. Most modern AI command-line tools ship only for 64-bit machines and refuse to install on this architecture. YUMI-LAB maintains dedicated installers that bring today's leading AI coding assistants to the board — running an interactive AI agent directly in the terminal, on hardware with as little as 1 GB of RAM.

## 1. Available AI Assistants

[![Claude Code on Smart Pi One](/img/SmartPi/AI/claude-code-banner.svg)](SmartPi_AI_Claude_Code.md)

[![Grok CLI on Smart Pi One](/img/SmartPi/AI/grok-cli-banner.svg)](SmartPi_AI_Grok_CLI.md)

[![Vibe CLI on Smart Pi One](/img/SmartPi/AI/vibe-cli-banner.svg)](SmartPi_AI_Vibe_CLI.md)

| Tool | Provider | Sign-in | Guide |
| --- | --- | --- | --- |
| ![](/img/SmartPi/AI/claude-logo.svg){ .off-glb width="18" } **Claude Code** | Anthropic | Claude Pro or Max account (no API key) | [Claude Code](SmartPi_AI_Claude_Code.md) |
| ![](/img/SmartPi/AI/grok-logo.svg){ .off-glb width="18" } **Grok CLI** | xAI | grok.com / SuperGrok account (no API key) | [Grok CLI](SmartPi_AI_Grok_CLI.md) |
| ![](/img/SmartPi/AI/mistral-logo.svg){ .off-glb width="18" } **Vibe CLI** | Mistral AI | Mistral API key | [Vibe CLI](SmartPi_AI_Vibe_CLI.md) |

**Claude Code** and **Grok CLI** sign in with your existing subscription account through a browser-based flow — no API key, no separate developer billing. **Vibe CLI** instead uses a Mistral API key (created at [console.mistral.ai](https://console.mistral.ai/){ target=_blank }).

## 2. Requirements

- A Smart Pi One or Smart Pad running a Debian-based Linux (see [Install Linux](../SmartPi_Linux.md))
- `armv7l` / 32-bit ARM CPU (Allwinner H3)
- At least **1 GB RAM**
- An active internet connection
- Access to the matching provider: a **Claude Pro/Max** account (Claude Code), a **grok.com / SuperGrok** account (Grok CLI), or a **Mistral API key** (Vibe CLI)

## 3. What can you do with it?

These assistants run in **agent mode**: they can read and write files, run shell commands, and help you build and debug projects directly on the board. Typical uses on a Smart Pi One:

- Writing and fixing Python scripts for the GPIO sensors and modules
- Setting up services (Klipper, Home Assistant, media servers…)
- Explaining Linux commands and troubleshooting the system
- Prototyping small projects with a full conversational coding assistant

## 4. Which one should I choose?

All three give you an interactive terminal UI and one-shot (`-p "question"`) query mode. Pick the one that matches the account or key you already have:

- Choose **[Claude Code](SmartPi_AI_Claude_Code.md)** if you have a Claude Pro or Max account. It runs natively (no emulation) and is the fastest.
- Choose **[Grok CLI](SmartPi_AI_Grok_CLI.md)** if you have a grok.com / SuperGrok account. It runs the official binary under lightweight QEMU emulation.
- Choose **[Vibe CLI](SmartPi_AI_Vibe_CLI.md)** if you have a Mistral API key. It's a thin client — inference runs on Mistral's servers, so it's light on the board (but the first install compiles for ~15 min).

Nothing stops you from installing all three.
