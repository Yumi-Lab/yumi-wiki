# Contributing to YUMI-LAB Documentation

Thank you for your interest in improving the YUMI-LAB wiki! Here's how to contribute.

## Getting Started

1. Fork the repository
2. Clone your fork:
   ```bash
   git clone https://github.com/<your-username>/yumi-wiki.git
   cd yumi-wiki
   ```
3. Create a branch:
   ```bash
   git checkout -b my-improvement
   ```
4. Set up the local dev environment:
   ```bash
   python3 -m venv venv
   source venv/bin/activate
   pip install -r requirements.txt
   mkdocs serve
   ```
5. Open [http://127.0.0.1:8000](http://127.0.0.1:8000) to preview your changes live.

## Writing Guidelines

### Page Structure
- Use `# Title` for the page title (h1) — only one per page
- Use `## N. Section` for numbered sections (appears in the TOC)
- Use `### Subsection` for sub-sections

### Images
- Place images in `img/<ProductCategory>/` (e.g., `img/SmartPi/`, `img/KlipperSmartPad/`)
- Reference images with absolute paths: `![alt text](/img/SmartPi/example.png)`
- Optimize images before committing — avoid PNG files larger than 1 MB (use WebP or compressed JPEG)

### Links
- External links must include `{ target=_blank }`:
  ```markdown
  [Link text](https://example.com){ target=_blank }
  ```
- Internal links use relative paths:
  ```markdown
  [See Flash Guide](SmartPi_Linux_flash_sd.md)
  ```

### Navigation
- When adding a new page, add it to `mkdocs.yml` under the appropriate section in the `nav:` block
- Section names use ALL CAPS (e.g., `SMART PI ONE:`, `DOCS:`, `TUTO:`)

## Submitting Changes

1. Commit your changes with a clear message:
   ```bash
   git commit -m "add guide for new sensor integration"
   ```
2. Push to your fork:
   ```bash
   git push origin my-improvement
   ```
3. Open a Pull Request against the `main` branch
4. Describe what you changed and why

## What to Contribute

- Fix typos or broken links
- Improve existing documentation clarity
- Add tutorials for new use cases
- Translate content
- Optimize images (convert large PNGs to WebP)

## Code of Conduct

Be respectful, constructive, and helpful. We're building documentation to help the community — keep it friendly.
