// Course formulary: filter the concept rows by name, show only those with gaps, open all.
// Without this script every row is there and opens by itself.
(function () {
  const root = document.querySelector("[data-cf]");
  if (!root) return;
  const tools = root.querySelector(".cf__tools");
  const search = tools.querySelector("input[type=search]");
  
  const openAll = tools.querySelector("[data-open]");
  const rows = [...root.querySelectorAll(".cf__row")];
  tools.hidden = false;
  function apply() {
    const q = search.value.trim().toLowerCase();
    rows.forEach(r => {
      const hit = !q || r.dataset.find.includes(q);
      r.hidden = !hit;
    });
  }
  search.addEventListener("input", apply);
  let open = false;
  openAll.addEventListener("click", () => {
    open = !open;
    rows.forEach(r => { r.querySelector("details").open = open; });
    openAll.textContent = open ? "Close all" : "Open all";
  });
  // Arrive from the glossary or a link with #concept-id: open that row.
  const want = decodeURIComponent(location.hash.slice(1));
  const hit = want && rows.find(r => r.id === want);
  if (hit) { hit.querySelector("details").open = true; hit.scrollIntoView(); }
})();
