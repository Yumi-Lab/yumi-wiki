# AI on Smart Pi One

The Smart Pi One and Smart Pad are 32-bit ARM (Allwinner H3 / armv7l) single-board computers. Most modern AI command-line tools ship only for 64-bit machines and refuse to install on this architecture. YUMI-LAB maintains dedicated installers that bring today's leading AI coding assistants to the board — running an interactive AI agent directly in the terminal, on hardware with as little as 1 GB of RAM.

## 1. Available AI Assistants

| Tool | Provider | Account needed | Guide |
| --- | --- | --- | --- |
| **Claude Code** | Anthropic | Claude Pro or Max | [Claude Code](SmartPi_AI_Claude_Code.md) |
| **Grok CLI** | xAI | grok.com / SuperGrok | [Grok CLI](SmartPi_AI_Grok_CLI.md) |

Both tools run **without an API key** — you sign in with your existing subscription account through a browser-based authentication flow, so no billing is tied to a separate developer key.

## 2. Requirements

- A Smart Pi One or Smart Pad running a Debian-based Linux (see [Install Linux](../SmartPi_Linux.md))
- `armv7l` / 32-bit ARM CPU (Allwinner H3)
- At least **1 GB RAM**
- An active internet connection
- An account with the matching provider (Anthropic for Claude Code, xAI for Grok)

## 3. What can you do with it?

These assistants run in **agent mode**: they can read and write files, run shell commands, and help you build and debug projects directly on the board. Typical uses on a Smart Pi One:

- Writing and fixing Python scripts for the GPIO sensors and modules
- Setting up services (Klipper, Home Assistant, media servers…)
- Explaining Linux commands and troubleshooting the system
- Prototyping small projects with a full conversational coding assistant

## 4. Which one should I choose?

Both give you an interactive terminal UI and one-shot (`-p "question"`) query mode. Pick the one that matches the subscription you already have:

- Choose **[Claude Code](SmartPi_AI_Claude_Code.md)** if you have a Claude Pro or Max account. It runs natively (no emulation) and is the fastest of the two.
- Choose **[Grok CLI](SmartPi_AI_Grok_CLI.md)** if you have a grok.com / SuperGrok account.

Nothing stops you from installing both.
