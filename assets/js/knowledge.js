// Statement explorer: filter by kind, layer, course and text; group by course, kind or note.
// The filter state lives in the URL hash, so a view can be linked:
//   #kind=theorem&course=statistics&q=normal&group=kind
(function () {
  const root = document.getElementById("kx");
  if (!root) return;
  const list = document.getElementById("kx-list");
  const items = [...list.querySelectorAll(".kx-item")];
  const facets = [...root.querySelectorAll(".kx-f")];
  const q = document.getElementById("kx-q");
  const count = document.getElementById("kx-count"), empty = document.getElementById("kx-empty");
  const active = document.getElementById("kx-active"), clear = document.getElementById("kx-clear");
  const groupBtns = [...root.querySelectorAll(".kx-group button")];
  const results = document.getElementById("kx-results");
  const kindLabel = {}, layerOf = {};
  items.forEach(li => { kindLabel[li.dataset.kind] = li.querySelector(".kx-badge").textContent; layerOf[li.dataset.kind] = li.dataset.layer; });
  const kindOrder = [...root.querySelectorAll('.kx-f[data-f="kind"]')].map(b => b.dataset.v);
  const st = { q: "", layer: "", kind: "", course: "", group: "course" };
  const texts = items.map(li => li.textContent.toLowerCase());

  const read = () => new URLSearchParams(location.hash.slice(1)).forEach((v, k) => { if (k in st) st[k] = v; });
  const write = () => {
    const p = new URLSearchParams();
    Object.entries(st).forEach(([k, v]) => { if (v && !(k === "group" && v === "course")) p.set(k, v); });
    history.replaceState(null, "", location.pathname + (p.toString() ? "#" + p : ""));
  };
  const words = () => st.q.toLowerCase().split(/\s+/).filter(Boolean);
  // `skip` leaves one facet out, so its own counts show what choosing it would give.
  const match = (li, i, skip) => {
    if (skip !== "layer" && st.layer && li.dataset.layer !== st.layer) return false;
    if (skip !== "kind" && st.kind && li.dataset.kind !== st.kind) return false;
    if (skip !== "course" && st.course && li.dataset.course !== st.course) return false;
    return words().every(w => texts[i].includes(w));
  };

  function render() {
    const shown = items.map((li, i) => match(li, i));
    // facet counts
    facets.forEach(b => {
      const f = b.dataset.f, v = b.dataset.v;
      const n = items.filter((li, i) => match(li, i, f) && li.dataset[f === "layer" ? "layer" : f] === v).length;
      b.querySelector(".kx-f__n").textContent = n;
      b.dataset.n = n;
      b.setAttribute("aria-pressed", String(st[f] === v));
    });
    // grouping
    const groups = new Map();
    const keyOf = li => st.group === "kind" ? li.dataset.kind : st.group === "note" ? li.dataset.url : li.dataset.course;
    const nameOf = li => st.group === "kind" ? kindLabel[li.dataset.kind] : st.group === "note" ? li.dataset.note : li.dataset.courseTitle;
    items.forEach((li, i) => {
      li.hidden = !shown[i];
      if (!shown[i]) return;
      const k = keyOf(li);
      if (!groups.has(k)) groups.set(k, { name: nameOf(li), lis: [] });
      groups.get(k).lis.push(li);
    });
    let entries = [...groups.entries()];
    if (st.group === "kind") entries.sort((a, b) => kindOrder.indexOf(a[0]) - kindOrder.indexOf(b[0]));
    results.querySelectorAll(".kx-group-h, .kx-grouped").forEach(n => n.remove());
    list.hidden = true;
    entries.forEach(([, g]) => {
      const h = document.createElement("h2");
      h.className = "kx-group-h";
      h.textContent = g.name;
      const n = document.createElement("span"); n.textContent = g.lis.length; h.append(n);
      const ol = document.createElement("ol");
      ol.className = "kx-list kx-grouped";
      g.lis.sort((a, b) => a.dataset.order - b.dataset.order).forEach(li => ol.append(li));
      results.append(h, ol);
    });
    count.textContent = shown.filter(Boolean).length + " of " + items.length + " entries";
    empty.hidden = shown.some(Boolean);
    // active filter chips
    active.textContent = "";
    const chip = (label, key) => {
      const s = document.createElement("span"); s.className = "kx-chip"; s.append(label);
      const x = document.createElement("button"); x.type = "button"; x.setAttribute("aria-label", "Remove filter " + label); x.textContent = "×";
      x.addEventListener("click", () => { st[key] = ""; if (key === "q") q.value = ""; render(); });
      s.append(x); active.append(s);
    };
    if (st.layer) chip(root.querySelector(`.kx-f[data-f="layer"][data-v="${st.layer}"] .kx-f__name`).textContent, "layer");
    if (st.kind) chip(kindLabel[st.kind] || st.kind, "kind");
    if (st.course) chip(root.querySelector(`.kx-f[data-f="course"][data-v="${st.course}"] .kx-f__name`)?.textContent || st.course, "course");
    if (st.q) chip("“" + st.q + "”", "q");
    clear.hidden = !(st.layer || st.kind || st.course || st.q);
    groupBtns.forEach(b => b.setAttribute("aria-pressed", String(b.dataset.group === st.group)));
    // "Show more" only where the text is cut off
    requestAnimationFrame(() => items.forEach(li => {
      if (li.hidden) return;
      const t = li.querySelector(".kx-text"), m = li.querySelector(".kx-more");
      m.hidden = li.classList.contains("is-open") ? false : t.scrollHeight <= t.clientHeight + 2;
    }));
    write();
  }

  facets.forEach(b => b.addEventListener("click", () => {
    const f = b.dataset.f, v = b.dataset.v;
    st[f] = st[f] === v ? "" : v;
    // choosing a kind also fixes its layer; choosing a layer clears a kind of another layer
    if (f === "kind") st.layer = st.kind ? layerOf[st.kind] : "";
    if (f === "layer" && st.kind && layerOf[st.kind] !== st.layer) st.kind = "";
    render();
  }));
  groupBtns.forEach(b => b.addEventListener("click", () => { st.group = b.dataset.group; render(); }));
  q.addEventListener("input", () => { st.q = q.value; render(); });
  clear.addEventListener("click", () => { st.q = st.layer = st.kind = st.course = ""; q.value = ""; render(); });
  items.forEach(li => {
    li.querySelector(".kx-more").addEventListener("click", e => {
      li.classList.toggle("is-open");
      e.target.textContent = li.classList.contains("is-open") ? "Show less" : "Show more";
      e.target.hidden = false;
    });
    li.querySelector(".kx-copy").addEventListener("click", e => {
      const url = new URL(e.target.dataset.href, location.href).href;
      (navigator.clipboard ? navigator.clipboard.writeText(url) : Promise.reject()).then(() => { e.target.textContent = "Copied"; setTimeout(() => (e.target.textContent = "Copy link"), 1500); }, () => { e.target.textContent = "Copy failed"; });
    });
  });
  document.addEventListener("keydown", e => {
    if (e.key === "/" && !/input|textarea|select/i.test(document.activeElement.tagName)) { e.preventDefault(); q.focus(); }
    if (e.key === "Escape" && document.activeElement === q) { q.value = ""; st.q = ""; render(); }
  });
  read(); q.value = st.q; render();
})();
