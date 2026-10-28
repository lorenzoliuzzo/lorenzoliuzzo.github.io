// Course map: overview of the course DAG and a focus view for one course.
// Data: assets/data/graph.json (tools/graph.rb). Vanilla JS, SVG, no dependencies.
(function () {
  const root = document.getElementById("map");
  if (!root) return;
  const stage = document.getElementById("map-stage");
  const bar = document.getElementById("map-bar");
  const back = document.getElementById("map-back");
  const crumb = document.getElementById("map-crumb");
  const base = root.dataset.base;
  const NS = "http://www.w3.org/2000/svg";
  let G;

  const el = (tag, attrs, parent, text) => {
    const n = document.createElementNS(NS, tag);
    for (const k in attrs || {}) n.setAttribute(k, attrs[k]);
    if (text != null) n.textContent = text;
    if (parent) parent.appendChild(n);
    return n;
  };
  const h = (tag, attrs, parent, text) => {
    const n = document.createElement(tag);
    for (const k in attrs || {}) n.setAttribute(k, attrs[k]);
    if (text != null) n.textContent = text;
    if (parent) parent.appendChild(n);
    return n;
  };
  const hue = c => `--c:var(--hue-${c.hue})`;
  const noteUrl = n => base + "notes/" + n.k + "/";
  const courseUrl = c => base + "notes/" + c.slug + "/";

  fetch(root.dataset.graph).then(r => r.json()).then(data => { G = data; prepare(); route(); }).catch(() => {
    stage.textContent = "The map data could not be loaded.";
  });
  window.addEventListener("hashchange", route);

  function prepare() {
    G.byNote = G.notes;
    // Edges between courses, by weight. From = course that defines, to = course that uses.
    const w = new Map();
    G.edges.forEach(([f, t, name]) => {
      const a = G.notes[f].c, b = G.notes[t].c;
      if (a === b) return;
      const key = a + ">" + b;
      const e = w.get(key) || { a, b, n: 0, names: [] };
      e.n++;
      e.names.push(name);
      w.set(key, e);
    });
    G.cross = [...w.values()];
    // Break cycles: drop the lighter direction of mutual pairs, then any remaining back edge.
    const keep = G.cross.filter(e => { const r = w.get(e.b + ">" + e.a); return !r || e.n > r.n || (e.n === r.n && e.a < e.b); });
    const out = G.courses.map(() => []);
    keep.forEach(e => out[e.a].push(e));
    const state = G.courses.map(() => 0), dag = [];
    const visit = u => { state[u] = 1; out[u].forEach(e => { if (state[e.b] === 1) return; dag.push(e); if (!state[e.b]) visit(e.b); }); state[u] = 2; };
    G.courses.forEach((_, u) => { if (!state[u]) visit(u); });
    G.dag = dag.filter((e, i) => dag.findIndex(x => x.a === e.a && x.b === e.b) === i);
    const depth = G.courses.map(() => 0);
    for (let i = 0; i < G.courses.length; i++) G.dag.forEach(e => { if (depth[e.b] < depth[e.a] + 1) depth[e.b] = depth[e.a] + 1; });
    G.depth = depth;
    G.linked = G.courses.map((_, i) => G.cross.some(e => e.a === i || e.b === i));
  }

  function route() {
    const slug = decodeURIComponent(location.hash.slice(1));
    const i = G.courses.findIndex(c => c.slug === slug);
    stage.innerHTML = "";
    bar.hidden = false;
    if (i < 0) { back.hidden = true; crumb.textContent = "All courses"; overview(); }
    else { back.hidden = false; crumb.textContent = G.courses[i].full; focus(i); }
  }
  back.addEventListener("click", () => { location.hash = ""; history.replaceState(null, "", location.pathname); route(); });

  /* Overview ---------------------------------------------------------------- */
  function overview() {
    const BW = 190, BH = 50, GX = 70, GY = 16, PAD = 10, TOP = 26;
    const cols = [];
    G.courses.forEach((c, i) => { if (G.linked[i]) (cols[G.depth[i]] = cols[G.depth[i]] || []).push(i); });
    // Order within a column: by mean position of linked courses in the previous column, then by domain.
    const pos = {};
    cols.forEach((col, d) => {
      if (!col) return;
      const score = i => {
        const ps = G.dag.filter(e => e.b === i && pos[e.a] != null).map(e => pos[e.a]);
        return ps.length ? ps.reduce((s, x) => s + x, 0) / ps.length : 1e3 + i;
      };
      col.sort((x, y) => score(x) - score(y) || x - y);
      col.forEach((i, k) => (pos[i] = k));
    });
    const maxRows = Math.max(...cols.filter(Boolean).map(c => c.length));
    const loose = G.courses.map((_, i) => i).filter(i => !G.linked[i]);
    const looseCols = Math.max(1, Math.floor(((cols.length) * (BW + GX) - GX) / (BW + 14)));
    const looseRows = Math.ceil(loose.length / looseCols);
    const W = cols.length * (BW + GX) - GX + PAD * 2;
    const H1 = TOP + maxRows * (BH + GY) + PAD;
    const H = H1 + (loose.length ? 36 + looseRows * (BH + GY) : 0);
    const svg = el("svg", { viewBox: `0 0 ${W} ${H}`, width: W, height: H, role: "group" }, stage);
    const xy = {};
    cols.forEach((col, d) => col && col.forEach((i, k) => {
      const free = maxRows - col.length;
      xy[i] = [PAD + d * (BW + GX), TOP + (k + free / 2) * (BH + GY)];
    }));
    loose.forEach((i, k) => { xy[i] = [PAD + (k % looseCols) * (BW + 14), H1 + 36 + Math.floor(k / looseCols) * (BH + GY)]; });
    cols.forEach((col, d) => col && el("text", { x: PAD + d * (BW + GX), y: 14, class: "col-label" }, svg, d === 0 ? "Foundations" : d === cols.length - 1 ? "Applications" : "Level " + (d + 1)));
    if (loose.length) el("text", { x: PAD, y: H1 + 22, class: "col-label" }, svg, "Not yet linked to other courses");

    const edges = G.cross.map(e => {
      const [x1, y1] = xy[e.a], [x2, y2] = xy[e.b];
      const fwd = G.depth[e.b] > G.depth[e.a];
      const sx = fwd ? x1 + BW : x1, ex = fwd ? x2 : x2 + BW;
      const sy = y1 + BH / 2, ey = y2 + BH / 2;
      const dx = Math.max(40, Math.abs(ex - sx) / 2) * (fwd ? 1 : -1);
      const p = el("path", { d: `M${sx},${sy} C${sx + dx},${sy} ${ex - dx},${ey} ${ex},${ey}`, class: "me", "stroke-width": (0.8 + Math.sqrt(e.n) * 0.7).toFixed(1) }, svg);
      const ang = Math.atan2(0, ex - (ex - dx));
      const hd = el("path", { d: `M${ex},${ey} l${-7 * Math.sign(dx)},-3.5 l0,7 z`, class: "mh" }, svg);
      const t = el("title", {}, p, `${G.courses[e.a].title} → ${G.courses[e.b].title}: ${e.n} link${e.n > 1 ? "s" : ""} (${[...new Set(e.names)].slice(0, 6).join(", ")})`);
      return { e, p, hd };
    });
    const boxes = {};
    G.courses.forEach((c, i) => {
      const [x, y] = xy[i];
      const g = el("g", { class: "mc", tabindex: 0, role: "link", "aria-label": `${c.full}: ${c.written} of ${c.total} notes written`, style: hue(c) }, svg);
      el("rect", { class: "box", x, y, width: BW, height: BH, rx: 6 }, g);
      el("text", { x: x + 10, y: y + 20 }, g, c.title.length > 26 ? c.title.slice(0, 25) + "…" : c.title);
      el("text", { x: x + 10, y: y + 36, class: "sub" }, g, `${c.written}/${c.total} written`);
      el("rect", { class: "bar-bg", x: x + 100, y: y + 31, width: BW - 110, height: 5, rx: 2 }, g);
      if (c.total) el("rect", { class: "bar", x: x + 100, y: y + 31, width: (BW - 110) * c.written / c.total, height: 5, rx: 2 }, g);
      boxes[i] = g;
      const open = () => { location.hash = c.slug; };
      g.addEventListener("click", open);
      g.addEventListener("keydown", ev => { if (ev.key === "Enter" || ev.key === " ") { ev.preventDefault(); open(); } });
      const on = () => lit(i), off = () => lit(null);
      g.addEventListener("mouseenter", on); g.addEventListener("focus", on);
      g.addEventListener("mouseleave", off); g.addEventListener("blur", off);
    });
    function lit(i) {
      const near = new Set([i]);
      edges.forEach(({ e, p, hd }) => {
        const hot = i != null && (e.a === i || e.b === i);
        if (hot) { near.add(e.a); near.add(e.b); }
        p.classList.toggle("hot", hot); hd.classList.toggle("hot", hot);
        p.classList.toggle("dim", i != null && !hot); hd.classList.toggle("dim", i != null && !hot);
      });
      G.courses.forEach((_, k) => boxes[k].classList.toggle("dim", i != null && !near.has(k)));
    }
  }

  /* Focus view -------------------------------------------------------------- */
  function focus(ci) {
    const course = G.courses[ci];
    const mine = G.notes.map((n, k) => k).filter(k => G.notes[k].c === ci);
    const left = new Set(), right = new Set(), adj = new Map();
    const link = (a, b) => { (adj.get(a) || adj.set(a, new Set()).get(a)).add(b); (adj.get(b) || adj.set(b, new Set()).get(b)).add(a); };
    const used = [];
    G.edges.forEach(([f, t, name]) => {
      const cf = G.notes[f].c, ct = G.notes[t].c;
      if (cf !== ci && ct !== ci) return;
      used.push([f, t, name]);
      link(f, t);
      if (cf !== ci) left.add(f);
      if (ct !== ci) right.add(t);
    });

    const wrap = h("div", { class: "fv" }, stage);
    const svg = el("svg", { class: "links" }, wrap);
    const nodeOf = {};
    const mk = (parent, k, extra) => {
      const n = G.notes[k];
      const li = h("li", {}, parent);
      const a = h(n.w ? "a" : "span", { class: "fn" + (n.w ? "" : " plan") + (extra || ""), style: hue(G.courses[n.c]), tabindex: 0 }, li, n.t);
      if (n.w) a.href = noteUrl(n);
      a.dataset.k = k;
      nodeOf[k] = a;
      const on = () => lit(k), off = () => lit(null);
      a.addEventListener("mouseenter", on); a.addEventListener("focus", on);
      a.addEventListener("mouseleave", off); a.addEventListener("blur", off);
      return a;
    };
    const side = (title, set, cls) => {
      const col = h("div", {}, wrap);
      h("h3", {}, col, title);
      if (!set.size) { h("p", { class: "fv-empty" }, col, cls === "l" ? "Starts from nothing in other courses." : "Nothing downstream yet."); return; }
      const byCourse = new Map();
      [...set].sort((a, b) => a - b).forEach(k => { const c = G.notes[k].c; (byCourse.get(c) || byCourse.set(c, []).get(c)).push(k); });
      [...byCourse.entries()].sort((a, b) => G.depth[a[0]] - G.depth[b[0]] || a[0] - b[0]).forEach(([c, ks]) => {
        const hh = h("h4", { style: hue(G.courses[c]) }, col);
        h("a", { href: "#" + G.courses[c].slug }, hh, G.courses[c].title);
        const ul = h("ul", {}, col);
        ks.forEach(k => mk(ul, k));
      });
    };
    side("Draws on", left, "l");
    const mid = h("div", {}, wrap);
    h("h3", {}, mid, course.full);
    const open = h("p", { class: "fv-empty" }, mid);
    h("a", { href: courseUrl(course) }, open, "Open the course page");
    open.append(` · ${course.written} of ${course.total} notes written`);
    let part = -1, ul;
    mine.forEach(k => {
      const n = G.notes[k];
      if (n.p !== part) { part = n.p; h("h4", { style: hue(course) }, mid, course.parts[part] || ""); ul = h("ul", {}, mid); }
      mk(ul, k, " mine");
    });
    side("Opens up", right, "r");

    const paths = used.map(([f, t, name]) => ({ f, t, p: el("path", { class: "fl" }, svg), name }));
    paths.forEach(o => { o.p.append(Object.assign(document.createElementNS(NS, "title"), { textContent: `${G.notes[o.f].t} → ${G.notes[o.t].t}: ${o.name}` })); });
    function draw() {
      const r0 = wrap.getBoundingClientRect();
      paths.forEach(o => {
        const a = nodeOf[o.f].getBoundingClientRect(), b = nodeOf[o.t].getBoundingClientRect();
        const same = G.notes[o.f].c === ci && G.notes[o.t].c === ci;
        let x1, x2;
        if (same) { x1 = a.right - r0.left; x2 = b.right - r0.left; }
        else { x1 = a.right - r0.left; x2 = b.left - r0.left; }
        const y1 = a.top + a.height / 2 - r0.top, y2 = b.top + b.height / 2 - r0.top;
        const d = same ? 30 : Math.max(30, (x2 - x1) / 2);
        o.p.setAttribute("d", same ? `M${x1},${y1} C${x1 + d},${y1} ${x2 + d},${y2} ${x2},${y2}` : `M${x1},${y1} C${x1 + d},${y1} ${x2 - d},${y2} ${x2},${y2}`);
        o.p.style.display = same ? "none" : "";
        o.same = same;
      });
    }
    function lit(k) {
      const near = new Set(k != null ? [k, ...(adj.get(k) || [])] : []);
      Object.entries(nodeOf).forEach(([key, a]) => {
        a.classList.toggle("sel", k != null && +key === k);
        a.classList.toggle("dim", k != null && !near.has(+key));
      });
      paths.forEach(o => {
        const hot = k != null && (o.f === k || o.t === k);
        o.p.classList.toggle("hot", hot);
        o.p.classList.toggle("dim", k != null && !hot);
        o.p.style.display = hot || !o.same ? "" : "none";
      });
    }
    draw();
    window.addEventListener("resize", draw);
    new ResizeObserver(draw).observe(wrap);
  }
})();
