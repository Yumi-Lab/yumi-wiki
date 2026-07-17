# Kimi CLI on Smart Pi One

![Kimi CLI on Smart Pi One](/img/SmartPi/AI/kimi-cli-banner.svg){ .off-glb }

[Kimi CLI](https://github.com/Yumi-Lab/kimi-cli-smartpi){ target=_blank } is Moonshot AI's official Kimi command-line assistant, packaged by YUMI-LAB to run on the 32-bit ARM (Allwinner H3 / armv7l) Smart Pi One and Smart Pad — hardware Moonshot ships no 32-bit build for.

> **Repository:** [github.com/Yumi-Lab/kimi-cli-smartpi](https://github.com/Yumi-Lab/kimi-cli-smartpi){ target=_blank }

## 1. How it works

Moonshot's official installer has no 32-bit ARM build, but the `kimi-cli` PyPI package ships as a **pure-Python wheel** (`py3-none-any`). YUMI-LAB installs it with [uv](https://github.com/astral-sh/uv){ target=_blank } (`uv tool install kimi-cli`), so Kimi CLI runs **natively — no emulation and no version pinning**. Only a couple of C dependencies (Pillow) compile from source with the armhf toolchain during install; `earlyoom` is added for memory safety on the 1 GB board.

## 2. Requirements

- `armv7l` / 32-bit ARM SBC with at least **1 GB RAM**
- A Debian-based Linux distribution (tested on the Smart Pad — Debian 13 trixie armhf, Python 3.13)
- `~/.local/bin` on your `$PATH`
- A **Kimi account** (Moonshot AI) — sign in with OAuth or an API key

## 3. Installation

Run the one-line installer on your Smart Pi One **as a normal user (not root)**:

```bash
curl -fsSL https://raw.githubusercontent.com/Yumi-Lab/kimi-cli-smartpi/main/install.sh | bash
```

The first install compiles Pillow from source (a few minutes; 4 cores by default). The installer is **idempotent** — re-running it skips work that's already done.

### Fanless boards

On a board with no active cooling, cap the compile to 2 cores to avoid thermal throttling (peaks ~88 °C instead of ~102 °C at 4 cores):

```bash
KIMI_BUILD_CPUS=0,1 curl -fsSL https://raw.githubusercontent.com/Yumi-Lab/kimi-cli-smartpi/main/install.sh | bash
```

## 4. Authentication

```bash
kimi login
```

Follow the OAuth prompt, or provide an API key. Credentials are stored in `~/.kimi/`.

## 5. Usage

| Command | Purpose |
| --- | --- |
| `kimi` | Full interactive agent TUI (native execution) |
| `kimi -p "your question"` | Start from a prompt, then continue interactively |
| `kimi --quiet -p "your task"` | One-shot mode — final answer only |
| `kimi login` | Sign in to your Kimi account |
| `kimi --version` | Version check (~0.9 s) |

In agent mode, Kimi CLI can read and edit files and run commands on the board — useful for scripting the GPIO sensors, configuring services, or working through Smart Pi projects.

### Limiting runtime CPU cores

Use `KIMI_CPUS` to pin the agent to specific cores at runtime (the counterpart of `GROK_CPUS`), keeping the board cool and responsive:

```bash
KIMI_CPUS=0,1 kimi -p "explain this error"
```

![Example Kimi CLI session on a Smart Pi One](/img/SmartPi/AI/kimi-cli-terminal.svg){ .off-glb }
*Example session (illustration).*

## 6. Notes

- **Native, no emulation:** unlike Grok CLI (which runs under QEMU), Kimi CLI runs directly as a Python tool. Startup is fast (~0.9 s); one-shot latency is bounded by Moonshot's remote inference, not the board.
- **Updating Kimi:** do **not** re-run `uv tool install kimi-cli` over an existing install. Update with `uv tool upgrade kimi-cli`, then re-run the installer once to restore the YUMI-LAB wrappers.
- **CPU control:** `KIMI_BUILD_CPUS` bounds the one-time compile; `KIMI_CPUS` bounds the running agent. Both default to 4 cores.
- Licensing: the installer scripts are MIT (YUMI-LAB); Kimi CLI itself remains subject to Moonshot AI's terms and is installed from the official PyPI package at runtime.
