// Reading furniture for notes: the reference list, cross-reference numbering
// and the table-of-contents highlight. Loaded with `defer` from
// _includes/footer/custom.html, after bibtexParse.js — `defer` preserves order,
// so bibtexParse is already defined here and nothing has to poll for it.

/* Bibliography and cross-references
   ========================================================================== */
(function () {
  let bibData = {};
  // The keys this page actually cites, in order of first appearance. Both the
  // reference list and the in-text numbers read from it, so there is one
  // numbering rather than two that have to be kept in agreement.
  let citedKeys = [];
  // What citedKeys looked like when the list was last written out, so an
  // unrelated mutation does not cause a re-render. null until the first one.
  let renderedSignature = null;

  async function loadBibliography() {
    const container = document.getElementById('bib-container');
    if (!container) return;

    // Check if the URL is actually set!
    const url = container.getAttribute('data-src');
    if (!url || url === "/" || url.includes("include.url")) {
      container.innerHTML = `<p class="bib-error">Error: Bibliography URL is missing. Check your Jekyll variables.</p>`;
      return;
    }

    try {
      const response = await fetch(url);
      if (!response.ok) throw new Error(`Could not find .bib file at ${url}`);

      const text = await response.text();
      const parsed = bibtexParse.toJSON(text);

      parsed.forEach(entry => {
        // FIXED: Prevent crash on @comments or missing keys
        if (entry.citationKey) {
          bibData[entry.citationKey.toLowerCase()] = entry.entryTags;
        }
      });

      // With nothing parsed, refreshReferences would leave the loading line up
      // for good, since it holds off rendering until bibData has something.
      if (Object.keys(bibData).length === 0) {
        container.innerHTML = `<p class="bib-empty">No entries found in ${url}.</p>`;
        return;
      }

      // refreshReferences works out what is cited and renders from that.
      refreshReferences();
    } catch (e) {
      console.error("BibTeX Error:", e);
      container.innerHTML = `<p class="bib-error">Error: ${e.message}</p>`;
    }
  }

  function formatAuthors(authorString) {
    if (!authorString) return 'Unknown Author';

    // Split by the standard BibTeX " and " keyword
    const authors = authorString.split(' and ').map(a => a.trim());

    if (authors.length === 1) return authors[0];
    if (authors.length === 2) return `${authors[0]} & ${authors[1]}`;
    if (authors.length > 3) return `${authors[0]} et al`; // Use et al. for 4+ authors

    // For 3 authors, format as: First, Second, & Third
    return authors.slice(0, -1).join(', ') + ', & ' + authors[authors.length - 1];
  }

  // Walks the page in document order and collects the .bib keys it links to.
  // A work the note never cites stays out of the reference list — a shared .bib
  // would otherwise print the whole library under every note.
  function citedInOrder() {
    const order = [];
    document.querySelectorAll('a[href^="#"]').forEach(link => {
      const key = link.getAttribute('href').slice(1).toLowerCase();
      if (bibData[key] && order.indexOf(key) === -1) order.push(key);
    });
    return order;
  }

  function renderBibliography(container) {
    let html = "";

    if (citedKeys.length === 0) {
      container.innerHTML = "<p class='bib-empty'>No works cited yet.</p>";
      return;
    }

    citedKeys.forEach((key, index) => {
      const e = bibData[key];
      const cleanAuthors = formatAuthors(e.author);
      const refNumber = index + 1;

      let linkHtml = "";
      if (e.url) {
        // Sometimes BibTeX wraps URLs in \url{...} or {...}, so we strip those out
        const cleanUrl = e.url.replace(/\\url\{([^}]+)\}/g, '$1').replace(/(^\{|\}$)/g, '');
        linkHtml = ` <a href="${cleanUrl}" target="_blank" rel="noopener noreferrer" class="bib-link">[Link]</a>`;
      } else if (e.doi) {
        // If there's no URL but there is a DOI, we can generate a working link
        const cleanDoi = e.doi.replace(/(^\{|\}$)/g, '');
        linkHtml = ` <a href="https://doi.org/${cleanDoi}" target="_blank" rel="noopener noreferrer" class="bib-link">[DOI]</a>`;
      }

      html += `<div class="bib-entry" id="${key}">
        <div class="bib-number">[${refNumber}]</div>
        <div class="bib-text">
          <strong>${cleanAuthors}.</strong> (${e.year || 'n.d.'}).
          <em>${e.title || 'Untitled'}.</em> ${e.journal || e.publisher || ''}.${linkHtml}
        </div>
      </div>`;
    });
    container.innerHTML = html;
  }

  function applyReferenceLabels() {
    const allFigures = Array.from(document.querySelectorAll('.latex-like-figure'));
    const allTables = Array.from(document.querySelectorAll('.latex-like-table'));
    const allEquations = Array.from(document.querySelectorAll('.numbered-equation'));
    const links = document.querySelectorAll('a[href^="#"]');

    // Re-render only when the set of cited works has actually moved, so a
    // late-loading table that adds a citation is picked up without this
    // rewriting the list on every unrelated mutation. Waiting on bibData keeps
    // the pass that runs before the fetch resolves from replacing the loading
    // line with "no works cited".
    const container = document.getElementById('bib-container');
    const cited = citedInOrder();
    const signature = cited.join('|');
    if (container && Object.keys(bibData).length && signature !== renderedSignature) {
      citedKeys = cited;
      renderBibliography(container);
      renderedSignature = signature;
    }

    links.forEach(link => {
      const id = link.getAttribute('href').slice(1);
      const citeKey = id.toLowerCase();
      const txt = link.textContent.trim().toLowerCase();

      // Update Citations to use numbers: [1]
      // refIndex is 0 when the page cites a work but carries no reference list
      // to number it against; leaving the link alone beats printing "[0]".
      const refIndex = citedKeys.indexOf(citeKey) + 1;
      if (refIndex && (txt === "" || txt === "ref" || txt === "cite")) {
        link.textContent = `[${refIndex}]`;
        link.classList.add('cite-link');

        // Optional: Add the full reference as a tooltip when hovering over the number
        const e = bibData[citeKey];
        link.title = `${formatAuthors(e.author)} (${e.year}). ${e.title}.`;
      }
      // Update Figures and Tables
      else if (txt === "" || txt === "fig" || txt === "tab" || txt === "eq") {
        const targetEl = document.getElementById(id);
        if (!targetEl) return;

        if (targetEl.classList.contains('latex-like-figure')) {
          link.textContent = "Figure " + (allFigures.indexOf(targetEl) + 1);
        } else if (targetEl.classList.contains('latex-like-table')) {
          link.textContent = "Table " + (allTables.indexOf(targetEl) + 1);
        } else if (targetEl.classList.contains('numbered-equation')) {
          link.textContent = "(" + (allEquations.indexOf(targetEl) + 1) + ")";
        }
      }
    });
  }

  // applyReferenceLabels rewrites link text, which is itself a childList mutation.
  // Detaching across the update stops the observer from re-triggering on its own work.
  let pending = null;
  const observer = new MutationObserver(() => {
    clearTimeout(pending);
    pending = setTimeout(refreshReferences, 50);
  });

  function refreshReferences() {
    observer.disconnect();
    try {
      applyReferenceLabels();
    } finally {
      observer.observe(document.body, { childList: true, subtree: true });
    }
  }

  refreshReferences();
  loadBibliography();
})();

/* Table-of-contents highlight
   ========================================================================== */
(function () {
  const menu = document.querySelector(".toc__menu");
  if (!menu) return;

  // Pair each entry with the heading it points at. A link whose target is
  // missing is dropped rather than guarded at every use below.
  const entries = Array.prototype.map
    .call(menu.querySelectorAll('a[href^="#"]'), link => ({
      link: link,
      heading: document.getElementById(
        decodeURIComponent(link.getAttribute("href").slice(1))
      )
    }))
    .filter(entry => entry.heading);

  if (!entries.length) return;

  // How far down the viewport the reading line sits. A heading counts as the
  // current section once it has scrolled above this, which is roughly where
  // the sticky masthead stops covering the text.
  const LINE = 100;
  let active = null;

  // The current section is the last heading that has passed the line, not the
  // topmost visible one: a section longer than the viewport has no heading on
  // screen at all, and picking by visibility would leave nothing highlighted.
  function sync() {
    let current = entries[0];
    entries.forEach(entry => {
      if (entry.heading.getBoundingClientRect().top <= LINE) current = entry;
    });

    if (current === active) return;
    if (active) active.link.classList.remove("active");
    current.link.classList.add("active");
    active = current;
  }

  // The observer is only a cue to re-measure — every boundary crossing that
  // changes the answer trips it, so this runs far less than a scroll handler
  // would. It also fires once on observe, which sets the initial highlight.
  const spy = new IntersectionObserver(sync, {
    rootMargin: -LINE + "px 0px 0px 0px",
    threshold: [0, 1]
  });
  entries.forEach(entry => spy.observe(entry.heading));

  // Figures have no intrinsic size until they decode, so on a note opened part
  // way down every heading moves once the images land. Re-measuring on load
  // settles the highlight after that shift; resize covers the same problem
  // when the column reflows.
  window.addEventListener("load", sync);
  window.addEventListener("resize", sync);
})();
