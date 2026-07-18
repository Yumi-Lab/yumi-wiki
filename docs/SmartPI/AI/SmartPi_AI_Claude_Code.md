# Claude Code CLI on Smart Pi One

![Claude Code CLI on Smart Pi One](/img/SmartPi/AI/claude-code-banner.svg){ .off-glb }

[Claude Code CLI](https://github.com/Yumi-Lab/claude-code-smartpi){ target=_blank } is Anthropic's official AI coding assistant, adapted by YUMI-LAB to run **natively** on the 32-bit ARM (armv7l) Smart Pi One and Smart Pad — hardware the standard installer rejects as incompatible.

> **Repository:** [github.com/Yumi-Lab/claude-code-smartpi](https://github.com/Yumi-Lab/claude-code-smartpi){ target=_blank }

## 1. How it works

There are **two install channels** — both run under Debian's own Node (no emulation), and neither needs a token or account to install:

- **Latest** — *any* current version (2.1.2xx…). Since 2.1.113 the official CLI ships as a Bun-compiled binary (64-bit only), but its readable JavaScript is embedded inside. The installer downloads the **official public binary** (~240 MB, no token), **extracts that JS on your device**, lowers the one modern syntax it uses (`using` declarations) to Node 20 with `esbuild --target=node20`, and runs it under Debian's Node 20 with a small (~15-function) Bun→Node shim. Re-run the installer to update.
- **Pinned** — **2.1.112**, the last npm release distributed as pure JavaScript. Lightest option (no big download), runs on any board with Node.js ≥ 18. This is the fallback channel.

Every launch goes through a small `taskset … nice -n 5` wrapper that runs Claude on all 4 cores at low priority by default.

!!! note "The old “never go past 2.1.112” rule is gone"
    Earlier this page said 2.1.112 was the ceiling on 32-bit. That was only because there was no known way to run the newer Bun binaries — the on-device extract-and-lower method above now runs the latest versions fine.

## 2. Requirements

- `armv7l` / 32-bit ARM CPU (Allwinner H3)
- At least **1 GB RAM**
- A Debian-based Linux distribution
    - **Latest** channel: **Node.js ≥ 20** (Debian 13 trixie armhf ships 20.x) plus `npm` and `ripgrep` — the installer adds them
    - **Pinned** channel: **Node.js ≥ 18**
- A **Claude Pro or Max** account (no API key needed)

## 3. Installation

Pick a channel and run its one-liner on your Smart Pi One.

**Latest version** — downloads the official binary, extracts and builds it on-device:

```bash
curl -fsSL https://raw.githubusercontent.com/Yumi-Lab/claude-code-smartpi/main/install-latest.sh | bash
```

Re-run it any time to move to the newest version, or pin a specific one:

```bash
curl -fsSL https://raw.githubusercontent.com/Yumi-Lab/claude-code-smartpi/main/install-latest.sh | bash -s -- 2.1.212
```

**Pinned 2.1.112** — lightest, pure-JS npm, no big download:

```bash
curl -fsSL https://raw.githubusercontent.com/Yumi-Lab/claude-code-smartpi/main/install.sh | bash
```

Both channels install `earlyoom` for memory safety on the 1 GB board.

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
| `claude-token-save <token>` | Persist the 1-year token (`~/.claude/.oauth_token` + `settings.json`) |
| `CLAUDE_CPUS=0,1 claude …` | Throttle to a CPU subset for this launch — no reinstall (default = all 4 cores) |

In agent mode, Claude Code can read and edit files and run commands on the board — ideal for writing GPIO scripts, configuring services, or debugging your Smart Pi projects.

![Example Claude Code session on a Smart Pi One](/img/SmartPi/AI/claude-code-terminal.svg){ .off-glb }
*Example session (illustration).*

## 6. Notes

- **Updating — latest channel:** re-run `install-latest.sh`; it fetches and builds the newest version (or `… | bash -s -- 2.1.212` to pin one).
- **Updating — pinned channel:** intentionally frozen. Do **not** run `claude update` (it would fetch a 64-bit binary); auto-update is disabled. Re-run `install.sh` to refresh it.
- **CPU control:** prefix any command with `CLAUDE_CPUS` to pin Claude to specific cores (the same knob as `GROK_CPUS` / `KIMI_CPUS`), e.g. `CLAUDE_CPUS=0,1 claude`. Default is all 4 cores.
- **Performance (measured on the H3):** the latest install downloads ~240 MB and runs esbuild once (~30 s); the built version then behaves like the pinned one. Pinned 2.1.112: `claude --version` ~6.6 s · one-shot answer ~23 s · multi-turn sessions stable.
- **`earlyoom`** is enabled as a memory safety net on the 1 GB board. Rule of thumb: run **one heavy CLI at a time**.
- **Licensing:** the scripts, shim, extractor and launcher in the repo are MIT (YUMI-LAB). The pinned build installs from the official npm registry; the latest build downloads the official binary from Anthropic and extracts its JS **locally, on your own device** — the resulting bundle stays on that device, is never redistributed, and remains subject to Anthropic's terms.
