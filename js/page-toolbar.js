/* Page header toolbar: a breadcrumb trail built from the sidebar's active
   nav path (left) plus a "Copy for LLM" button (right). Rebuilt on every
   page load and every instant-navigation swap via Material's document$.
   The .md sibling file and the data-md-source-path attribute the copy
   button relies on are produced at build time by hooks/copy_markdown.py. */
(() => {
  const RESET_DELAY_MS = 2000;

  const ICON_COPY =
    '<svg viewBox="0 0 24 24" width="16" height="16" aria-hidden="true" focusable="false">' +
    '<path fill="currentColor" d="M16 1H4c-1.1 0-2 .9-2 2v14h2V3h12V1Zm3 4H8c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h11c1.1 0 2-.9 2-2V7c0-1.1-.9-2-2-2Zm0 16H8V7h11v14Z"/>' +
    "</svg>";
  const ICON_CHECK =
    '<svg viewBox="0 0 24 24" width="16" height="16" aria-hidden="true" focusable="false">' +
    '<path fill="currentColor" d="M9 16.17 4.83 12l-1.42 1.41L9 19l12-12-1.41-1.42z"/>' +
    "</svg>";

  function label(icon, text) {
    return icon + "<span>" + text + "</span>";
  }

  function buildBreadcrumb() {
    const items = document.querySelectorAll(
      ".md-sidebar--primary li.md-nav__item--active"
    );
    if (!items.length) return null;

    const nav = document.createElement("nav");
    nav.className = "md-breadcrumb";
    nav.setAttribute("aria-label", "Breadcrumb");

    items.forEach((li, index) => {
      const textEl = li.querySelector(".md-ellipsis");
      if (!textEl) return;
      const text = textEl.textContent.trim();
      const isLast = index === items.length - 1;
      // A section's own page link, if it has one, always appears before its
      // nested <nav> of children in the DOM — so the first link found here
      // is either that own page, or (for a pure category with no page of
      // its own) the first page reachable under it, which is the next best
      // thing to jump to.
      const linkEl = li.querySelector("a[href]");

      if (nav.childElementCount) {
        const sep = document.createElement("span");
        sep.className = "md-breadcrumb__sep";
        sep.textContent = "/";
        sep.setAttribute("aria-hidden", "true");
        nav.appendChild(sep);
      }

      let item;
      if (!isLast && linkEl) {
        item = document.createElement("a");
        item.href = linkEl.getAttribute("href");
      } else {
        item = document.createElement("span");
        if (isLast) item.setAttribute("aria-current", "page");
      }
      item.className = "md-breadcrumb__item";
      item.textContent = text;
      nav.appendChild(item);
    });

    return nav.childElementCount ? nav : null;
  }

  async function copyForLLM(button, sourcePath) {
    const pageUrl = window.location.href;
    button.disabled = true;
    try {
      const res = await fetch("/" + sourcePath, { credentials: "omit" });
      if (!res.ok) throw new Error("fetch failed: " + res.status);
      const markdown = await res.text();
      await navigator.clipboard.writeText(
        "Source: " + pageUrl + "\n\n" + markdown
      );
      button.classList.remove("is-error");
      button.classList.add("is-done");
      button.innerHTML = label(ICON_CHECK, "Copied");
    } catch (err) {
      button.classList.remove("is-done");
      button.classList.add("is-error");
      button.innerHTML = label(ICON_COPY, "Copy failed");
    } finally {
      setTimeout(() => {
        button.disabled = false;
        button.classList.remove("is-done", "is-error");
        button.innerHTML = label(ICON_COPY, "Copy for LLM");
      }, RESET_DELAY_MS);
    }
  }

  function buildCopyButton(sourcePath) {
    const button = document.createElement("button");
    button.type = "button";
    button.className = "md-copy-llm";
    button.innerHTML = label(ICON_COPY, "Copy for LLM");
    button.addEventListener("click", () => copyForLLM(button, sourcePath));
    return button;
  }

  function mount() {
    const article = document.querySelector(
      ".md-content__inner[data-md-source-path]"
    );
    if (!article) return;

    // Rebuilt from scratch on every call instead of mounted once: Material
    // may reuse the same <article> node across instant-navigation swaps, so
    // a "mounted" flag on that node can go stale and skip re-mounting on
    // the next page.
    const existing = article.querySelector(":scope > .md-page-toolbar");
    if (existing) existing.remove();

    const bar = document.createElement("div");
    bar.className = "md-page-toolbar";

    const crumb = buildBreadcrumb();
    if (crumb) bar.appendChild(crumb);
    bar.appendChild(buildCopyButton(article.dataset.mdSourcePath));

    article.insertBefore(bar, article.firstChild);
  }

  if (window.document$) {
    document$.subscribe(mount);
  } else {
    document.addEventListener("DOMContentLoaded", mount);
  }
})();
