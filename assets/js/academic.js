// Reading furniture for notes: cross-reference numbering and the table-of-contents
// highlight. Loaded with `defer` from _includes/footer/custom.html.

/* Cross-reference numbering
   ========================================================================== */
// Figures, tables and equations are numbered here, in document order, and the empty links
// that point at them ([](#fig-clt)) are given their text. Citations are not handled here:
// they are rendered at build time by _plugins/citations.rb.
(function () {
  function applyReferenceLabels() {
    const allFigures = Array.from(document.querySelectorAll('.latex-like-figure'));
    const allTables = Array.from(document.querySelectorAll('.latex-like-table'));
    const allEquations = Array.from(document.querySelectorAll('.numbered-equation'));
    // Theorem-like blocks (_sass/_context.scss). Definition, theorem, lemma, proposition and
    // corollary share one count, as in a paper; the others count separately.
    const shared = ['definition', 'theorem', 'lemma', 'proposition', 'corollary'];
    const results = Array.from(document.querySelectorAll('blockquote')).filter(
      b => shared.some(c => b.classList.contains(c)));
    const separate = ['example', 'exercise', 'algorithm'];

    document.querySelectorAll('a[href^="#"]').forEach(link => {
      const id = decodeURIComponent(link.getAttribute('href').slice(1));
      const txt = link.textContent.trim().toLowerCase();
      if (!(txt === "" || txt === "fig" || txt === "tab" || txt === "eq")) return;

      const targetEl = document.getElementById(id);
      if (!targetEl) return;

      if (targetEl.classList.contains('latex-like-figure')) {
        link.textContent = "Figure " + (allFigures.indexOf(targetEl) + 1);
      } else if (targetEl.classList.contains('latex-like-table')) {
        link.textContent = "Table " + (allTables.indexOf(targetEl) + 1);
      } else if (targetEl.classList.contains('numbered-equation')) {
        link.textContent = "(" + (allEquations.indexOf(targetEl) + 1) + ")";
      } else if (results.indexOf(targetEl) !== -1) {
        const kind = shared.find(c => targetEl.classList.contains(c));
        link.textContent = kind.charAt(0).toUpperCase() + kind.slice(1) + " " + (results.indexOf(targetEl) + 1);
      } else {
        const kind = separate.find(c => targetEl.classList.contains(c));
        if (!kind) return;
        const same = Array.from(document.querySelectorAll('blockquote.' + kind));
        link.textContent = kind.charAt(0).toUpperCase() + kind.slice(1) + " " + (same.indexOf(targetEl) + 1);
      }
    });
  }

  // Tables from a CSV are filled in after load, and the link text is itself a mutation,
  // so the observer is detached while the labels are written.
  let pending = null;
  const observer = new MutationObserver(() => {
    clearTimeout(pending);
    pending = setTimeout(refresh, 50);
  });

  function refresh() {
    observer.disconnect();
    try {
      applyReferenceLabels();
    } finally {
      observer.observe(document.body, { childList: true, subtree: true });
    }
  }

  refresh();
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
