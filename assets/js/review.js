// Flashcards over the concept definitions. State: which cards are known (localStorage, optional).
(function () {
  const root = document.querySelector("[data-review]");
  if (!root) return;
  const KEY = "review-known";
  const cards = [...root.querySelectorAll(".rc")].map(el => ({
    id: el.dataset.id, name: el.dataset.name, course: el.dataset.course,
    courseTitle: el.dataset.courseTitle, url: el.dataset.url, html: el.innerHTML
  }));
  let known = new Set();
  try { known = new Set(JSON.parse(localStorage.getItem(KEY) || "[]")); } catch (e) {}
  const save = () => { try { localStorage.setItem(KEY, JSON.stringify([...known])); } catch (e) {} };
  const $ = id => document.getElementById(id);
  const pick = $("review-pick");
  let course = "", queue = [], cur = null, shown = false;

  const courses = [...new Map(cards.filter(c => c.course).map(c => [c.course, c.courseTitle]))];
  pick.hidden = false;
  [["", "All courses"], ...courses].forEach(([slug, title]) => {
    const b = document.createElement("button");
    b.type = "button"; b.textContent = title; b.setAttribute("aria-pressed", String(slug === course));
    b.addEventListener("click", () => {
      course = slug;
      pick.querySelectorAll("button").forEach(x => x.setAttribute("aria-pressed", String(x === b)));
      build(); next();
    });
    pick.appendChild(b);
  });

  function build() {
    queue = cards.filter(c => (!course || c.course === course) && !known.has(c.id));
    for (let i = queue.length - 1; i > 0; i--) { const j = Math.floor(Math.random() * (i + 1)); [queue[i], queue[j]] = [queue[j], queue[i]]; }
  }
  function render() {
    const total = cards.filter(c => !course || c.course === course).length;
    $("review-count").textContent = cur ? (queue.length + 1) + " left of " + total : "";
    $("review-meta").textContent = cur ? cur.courseTitle : "";
    $("review-q").textContent = cur ? "What is " + cur.name + "?" : "All done for this selection.";
    const a = $("review-a");
    a.hidden = !cur || !shown;
    a.innerHTML = cur && shown ? cur.html + '<p><a href="' + cur.url + '">Concept page &rarr;</a></p>' : "";
    $("review-flip").hidden = !cur || shown;
    $("review-again").hidden = $("review-known").hidden = !cur || !shown;
  }
  function next() { cur = queue.shift() || null; shown = false; render(); }
  $("review-flip").addEventListener("click", () => { shown = true; render(); });
  $("review-known").addEventListener("click", () => { known.add(cur.id); save(); next(); });
  $("review-again").addEventListener("click", () => { queue.push(cur); next(); });
  $("review-reset").addEventListener("click", () => { known = new Set(); save(); build(); next(); });
  build(); next();
})();
