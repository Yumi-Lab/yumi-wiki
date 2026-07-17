# Claude Code on Smart Pi One

[Claude Code](https://github.com/Yumi-Lab/claude-code-smartpi){ target=_blank } is Anthropic's official AI coding assistant, adapted by YUMI-LAB to run **natively** on the 32-bit ARM (armv7l) Smart Pi One and Smart Pad — hardware the standard installer rejects as incompatible.

> **Repository:** [github.com/Yumi-Lab/claude-code-smartpi](https://github.com/Yumi-Lab/claude-code-smartpi){ target=_blank }

## 1. How it works

Claude Code version **2.1.112** is the last npm release distributed as pure JavaScript — later versions switched to 64-bit-only Bun binaries. This project pins that version, so it runs on any board with Node.js ≥ 18, **with no emulation**. It runs directly on the CPU, which makes it the fastest AI assistant option on the board.

## 2. Requirements

- Node.js **≥ 18**
- `armv7l` / 32-bit ARM CPU (Allwinner H3)
- At least **1 GB RAM**
- A Debian-based Linux distribution
- A **Claude Pro or Max** account (no API key needed)

## 3. Installation

Run the one-line installer on your Smart Pi One:

```bash
curl -fsSL https://raw.githubusercontent.com/Yumi-Lab/claude-code-smartpi/main/install.sh | bash
```

The installer pins version 2.1.112, disables auto-updates (newer releases are 64-bit only), and installs `earlyoom` for memory safety on low-RAM boards.

## 4. Authentication

Claude Code signs in with your Claude Pro/Max account — no API key required.

Start the OAuth flow:

```bash
claude setup-token
```

This prints a URL. Open it in a browser on **any** machine, approve access, and copy the one-time code. Then save the token on the board:

```bash
claude-token-save sk-ant-oat01-…
```

The generated token is valid for **one year**.

## 5. Usage

| Command | Purpose |
| --- | --- |
| `claude` | Interactive assistant with the full terminal UI |
| `claude -p "your question"` | Single-shot answer, with agent mode enabled |
| `claude setup-token` | Start the OAuth authentication flow |
| `claude-token-save <token>` | Save your authentication token |

In agent mode, Claude Code can read and edit files and run commands on the board — ideal for writing GPIO scripts, configuring services, or debugging your Smart Pi projects.

## 6. Notes

- **Auto-update is disabled on purpose.** Do not upgrade Claude Code past 2.1.112 — newer versions are 64-bit only and will not run on the Smart Pi One.
- Two environment variables enable 32-bit compatibility: `USE_BUILTIN_RIPGREP=0` (use the system `ripgrep`) and `DISABLE_AUTOUPDATER=1` (prevent an incompatible downgrade/upgrade).
- The installer scripts are MIT-licensed; Claude Code itself remains subject to Anthropic's terms, as it is installed from official sources.
