// Curator table: filter by name and course, show only rows with gaps (the default).
(function () {
  const tools = document.getElementById("audit-tools");
  if (!tools) return;
  const q = document.getElementById("audit-q");
  const gaps = document.getElementById("audit-gaps");
  const course = document.getElementById("audit-course");
  const count = document.getElementById("audit-count");
  const rows = [...document.querySelectorAll(".audit tbody tr")];
  tools.hidden = false;
  function apply() {
    const t = q.value.trim().toLowerCase();
    let n = 0;
    rows.forEach(r => {
      const ok = (!t || r.dataset.find.includes(t)) && (!course.value || r.dataset.course === course.value) &&
        (!gaps.checked || r.dataset.gaps.trim() !== "");
      r.hidden = !ok;
      if (ok) n++;
    });
    count.textContent = n + " of " + rows.length;
  }
  [q, gaps, course].forEach(e => e.addEventListener("input", apply));
  apply();
})();
