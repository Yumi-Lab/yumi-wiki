"""Publishes each page's raw Markdown source alongside its built HTML, and
tags the rendered article with the source path so the "Copy for LLM" button
(js/copy-for-llm.js) knows which .md file to fetch.
"""
import shutil
from pathlib import Path

SRC_ATTR = ' data-md-source-path="{src_uri}"'
ARTICLE_OPEN_TAG = '<article class="md-content__inner md-typeset">'


def on_post_build(config, **kwargs):
    docs_dir = Path(config["docs_dir"])
    site_dir = Path(config["site_dir"])
    for src in docs_dir.rglob("*.md"):
        rel = src.relative_to(docs_dir)
        if rel.parts[0] == "_snippets":
            continue
        dest = site_dir / rel
        dest.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(src, dest)


def on_post_page(output, page, config, **kwargs):
    tagged = ARTICLE_OPEN_TAG[:-1] + SRC_ATTR.format(src_uri=page.file.src_uri) + ">"
    return output.replace(ARTICLE_OPEN_TAG, tagged, 1)
