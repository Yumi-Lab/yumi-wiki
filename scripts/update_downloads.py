#!/usr/bin/env python3
"""Regenerate the image download tables from the GitHub releases.

Reads the published releases of Yumi-Lab/SmartPi-armbian and
Yumi-Lab/DietPi-SmartPi and rewrites the blocks delimited by

    <!-- BEGIN AUTO: <name> -->   ...   <!-- END AUTO: <name> -->

in docs/SmartPI/SmartPi_Linux.md and docs/SmartPI/OS/SmartPi_DietPi.md, so the
download links always point at the newest release instead of a version somebody
has to remember to bump.

Usage:
    python3 scripts/update_downloads.py [--check]

    --check   exit 1 if a file would change (for CI), without writing

Set GITHUB_TOKEN to raise the API rate limit (60 requests/hour anonymously).
"""

import argparse
import json
import os
import pathlib
import re
import sys
import urllib.error
import urllib.request

REPO_ROOT = pathlib.Path(__file__).resolve().parent.parent
ARMBIAN_REPO = "Yumi-Lab/SmartPi-armbian"
DIETPI_REPO = "Yumi-Lab/DietPi-SmartPi"

LINUX_PAGE = REPO_ROOT / "docs/SmartPI/SmartPi_Linux.md"
DIETPI_PAGE = REPO_ROOT / "docs/SmartPI/OS/SmartPi_DietPi.md"

# Display order and labels, newest-first within each distribution family.
DISTROS = [
    ("trixie", "Debian 13 Trixie", "A81D33", "debian"),
    ("bookworm", "Debian 12 Bookworm", "A81D33", "debian"),
    ("noble", "Ubuntu 24.04 Noble", "E95420", "ubuntu"),
    ("jammy", "Ubuntu 22.04 Jammy", "E95420", "ubuntu"),
    ("bullseye", "Debian 11 Bullseye (EOL)", "A81D33", "debian"),
]
BOARDS = [("smartpi1", "Smart Pi One"), ("smartpad", "Smart Pad")]

# Yumi-<board>-<codename>-<distro>-<edition>-<timestamp>.img.xz
ASSET_RE = re.compile(
    r"^Yumi-(?P<board>[a-z0-9]+)-(?P<codename>[a-z]+)-(?P<distro>[a-z0-9.]+)"
    r"-(?P<edition>server|desktop)-(?P<stamp>[\d-]+)\.img\.xz$"
)


def api(path):
    req = urllib.request.Request(
        f"https://api.github.com{path}",
        headers={
            "Accept": "application/vnd.github+json",
            "User-Agent": "yumi-wiki-update-downloads",
        },
    )
    token = os.environ.get("GITHUB_TOKEN")
    if token:
        req.add_header("Authorization", f"Bearer {token}")
    with urllib.request.urlopen(req, timeout=30) as resp:
        return json.load(resp)


def when(release):
    """Publication date, the only ordering the tag names agree on: the repo has
    used both v1.7.0-style and 20240302-2147-style tags."""
    return release.get("published_at") or release.get("created_at") or ""


def pick_releases(releases):
    """Most recent final release, and the prerelease after it if there is one."""
    published = sorted((r for r in releases if not r.get("draft")), key=when)
    finals = [r for r in published if not r["prerelease"]]
    pres = [r for r in published if r["prerelease"]]
    stable = finals[-1] if finals else None
    rc = pres[-1] if pres else None
    if stable and rc and when(rc) < when(stable):
        rc = None
    return stable, rc


def newest(releases):
    """Most recent release of any kind — for repos that ship only candidates."""
    published = [r for r in releases if not r.get("draft")]
    return max(published, key=when) if published else None


def parse_images(release):
    """{board: {codename: {edition: download_url}}} for the .img.xz assets."""
    images = {}
    for asset in release["assets"]:
        m = ASSET_RE.match(asset["name"])
        if not m:
            continue
        images.setdefault(m["board"], {}).setdefault(m["codename"], {})[
            m["edition"]
        ] = asset["browser_download_url"]
    return images


def badge(label, colour, logo, url):
    text = label.replace(" ", "_").replace("-", "--")
    return (f"[![Download](https://img.shields.io/badge/Download-{text}-{colour}"
            f"?logo={logo}&logoColor=white)]({url}){{ target=_blank }}")


def table(per_distro):
    rows = ["| Distribution | Server | Desktop |", "|---|---|---|"]
    for codename, name, colour, logo in DISTROS:
        editions = per_distro.get(codename)
        if not editions:
            continue
        cells = []
        for edition in ("server", "desktop"):
            url = editions.get(edition)
            short = name.split(" (")[0].split()[-1]
            cells.append(badge(f"{short} {edition.capitalize()}", colour, logo, url)
                         if url else "—")
        rows.append(f"| **{name}** | {cells[0]} | {cells[1]} |")
    return "\n".join(rows)


def date_of(release):
    return (release.get("published_at") or "")[:10]


def armbian_block(release, kind):
    """Markdown for one release: callout, per-board tables, release link."""
    images = parse_images(release)
    tag, date = release["tag_name"], date_of(release)
    out = []

    if kind == "stable":
        out += [f'!!! success "{tag} — latest stable release, {date}"', ""]
    else:
        out += [f'!!! info "{tag} — release candidate, {date}"', ""]

    boards = [(key, label) for key, label in BOARDS if key in images]
    if len(boards) == 1 and boards[0][0] == "smartpi1":
        out += ["    One image serves both the Smart Pi One and the Smart Pad — "
                "the touchscreen is detected at boot.", ""]
    out += [f"    [:octicons-mark-github-16: {tag} on GitHub]"
            f"(https://github.com/{ARMBIAN_REPO}/releases/tag/{tag})"
            f"{{ .md-button target=_blank }}", ""]

    for key, label in boards:
        if len(boards) > 1:
            out += [f"**{label}**", ""]
        out += [table(images[key]), ""]

    return "\n".join(out).rstrip()


def dietpi_block(release):
    """The newest image of the release — a candidate release can carry several
    rebuilds of the same image, and only the last one is worth downloading."""
    tag, date = release["tag_name"], date_of(release)
    images = [a for a in release["assets"] if a["name"].endswith(".img.xz")]
    if not images:
        raise SystemExit(f"no .img.xz asset in {DIETPI_REPO} {tag}")
    asset = max(images, key=lambda a: a.get("created_at", a["name"]))
    size = f"{asset['size'] / 1_000_000:.0f} MB"
    return "\n".join([
        "| File | Size | Release |",
        "|---|---|---|",
        f"| [`{asset['name']}`]({asset['browser_download_url']})"
        f"{{ target=_blank }} | {size} | {tag} — {date} |",
        "",
        "The matching `.sha256` file is on the "
        f"[release page](https://github.com/{DIETPI_REPO}/releases/tag/{tag})"
        "{ target=_blank }.",
    ])


def replace_block(text, name, body):
    begin, end = f"<!-- BEGIN AUTO: {name} -->", f"<!-- END AUTO: {name} -->"
    pattern = re.compile(re.escape(begin) + r".*?" + re.escape(end), re.DOTALL)
    if not pattern.search(text):
        raise SystemExit(f"marker '{name}' not found — nothing to update")
    return pattern.sub(f"{begin}\n\n{body}\n\n{end}", text)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--check", action="store_true",
                    help="exit 1 if a page would change, without writing")
    args = ap.parse_args()

    try:
        armbian = api(f"/repos/{ARMBIAN_REPO}/releases?per_page=30")
        dietpi = api(f"/repos/{DIETPI_REPO}/releases?per_page=30")
    except urllib.error.HTTPError as exc:
        raise SystemExit(f"GitHub API error: {exc}")

    stable, rc = pick_releases(armbian)
    if not stable:
        raise SystemExit(f"no final release found in {ARMBIAN_REPO}")

    linux = LINUX_PAGE.read_text()
    linux = replace_block(linux, "armbian-stable", armbian_block(stable, "stable"))
    rc_body = (armbian_block(rc, "rc") if rc else
               "*No release candidate is open at the moment — the stable "
               "release above is the newest build.*")
    linux = replace_block(linux, "armbian-rc", rc_body)

    dp_release = newest(dietpi)
    if not dp_release:
        raise SystemExit(f"no release found in {DIETPI_REPO}")
    dietpi_page = replace_block(DIETPI_PAGE.read_text(), "dietpi-release",
                                dietpi_block(dp_release))

    changed = []
    for path, new in ((LINUX_PAGE, linux), (DIETPI_PAGE, dietpi_page)):
        if path.read_text() != new:
            changed.append(path.relative_to(REPO_ROOT))
            if not args.check:
                path.write_text(new)

    tags = f"armbian {stable['tag_name']}" + (f" + {rc['tag_name']}" if rc else "")
    print(f"{tags}, dietpi {dp_release['tag_name']}")
    print("updated: " + (", ".join(map(str, changed)) if changed else "nothing"))
    if args.check and changed:
        sys.exit(1)


if __name__ == "__main__":
    main()
