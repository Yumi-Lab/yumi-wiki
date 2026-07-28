# Debian 13 Trixie with i3

![Debian 13 Trixie with i3](/img/SmartPi/OS/debian13-trixie-i3-banner.svg){ .off-glb .banner }

A desktop image built around **i3**, a tiling window manager, instead of XFCE. Same Debian 13 base, same kernel, same hardware stack — the difference is what runs on top of Xorg, and it costs **133 MB less memory**.

!!! info "Not released yet"
    This image is being prepared and does not appear on the [download page](../SmartPi_Linux.md) yet. The figures below were measured on a working build; the page will link to the image as soon as it ships.

## 1. Why a tiling desktop on this board

The Smart Pi One has 960 MB of usable RAM. A conventional desktop spends a large part of it before you open anything:

| Desktop image | RAM at idle | Available |
|---|---|---|
| Debian 13 Trixie — XFCE | 378 MB | 581 MB |
| **Debian 13 Trixie — i3** | **245 MB** | **714 MB** |

There is no panel, no desktop icon manager, no compositor and no tray applets — so the memory goes to your work instead. Windows are tiled automatically: they fill the screen, side by side, with no overlapping and no manual resizing.

## 2. What you see at first boot

The screen is deliberately bare. There is **no start menu and no taskbar** — that is normal, not a fault:

- a thin **status bar at the bottom** (i3bar): IP address, memory, CPU load, date
- a **workspace number** at the bottom left — `1` is the workspace you are on
- nothing else until you open something

Everything happens with the keyboard.

## 3. The keys you need

The modifier is **Alt** on this image.

| Keys | Action |
|---|---|
| ++alt+enter++ | Open a terminal (Terminator) |
| ++alt+d++ | Application launcher (dmenu) — type a few letters, press ++enter++ |
| ++alt+shift+q++ | Close the focused window |
| ++alt+f++ | Fullscreen the focused window |
| ++alt+left++ / ++alt+right++ / ++alt+up++ / ++alt+down++ | Move the focus between tiled windows |
| ++alt+1++ … ++alt+9++ | Switch workspace |
| ++alt+shift+1++ … ++alt+shift+9++ | Send the window to another workspace |
| ++alt+shift+e++ | Log out of i3 (asks for confirmation) |

Open a second window and i3 splits the screen automatically. Nothing to drag, nothing to arrange.

## 4. Same base as the other images

Everything from the [shared hardware stack](index.md#3-what-every-yumi-image-includes) applies: overclocked kernel, custom U-Boot, `YUMi SmartPi One` device tree, SSH over the USB cable, kernel packages held. Only the desktop layer changes, so anything written for the Debian 13 images works here.

## 5. Who it is for

- **You want a screen and the memory too** — 714 MB free against 581 MB with XFCE, on a board where a single browser tab can take 300 MB.
- **You work with the keyboard** — a terminal, an editor, a browser side by side, no mouse.
- **Prefer XFCE** if you want a menu, a taskbar, drag-and-drop and a familiar desktop: see the [Debian 13 desktop image](../SmartPi_Linux.md).

Full i3 documentation, including how to change the keys: [i3wm.org/docs](https://i3wm.org/docs/userguide.html){ target=_blank }.
