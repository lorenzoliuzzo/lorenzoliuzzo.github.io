---
name: note-figure
description: Create or change a figure for a course note or technical reference. Use when a note needs a diagram or plot (a distribution, a process, a comparison, a simulation), when a figure on the site or in the PDF looks wrong, or when asked to add figures to a note. One Python script per figure produces both the themed site SVG and the print SVG for Typst.
---

# Figures for the notes

A figure is **one script**, `tools/figures/<course>/<name>.py`, that builds a figure with a small standard-library kit (`tools/figures/kit.py`) and is rendered twice by `tools/figures/build.py`:

| Output | Path | Used by |
|---|---|---|
| site | `_includes/fig/<course>/<name>.svg` | `{% include fig.html src="<course>/<name>" ... %}` in a note. Inlined, classes only: the page's CSS colours it from the theme tokens, so it follows light and dark mode |
| print | `assets/notes/<course>/figures/<name>.svg` | `#fig("/<course>/figures/<name>.svg", ...)` in the Typst reference. Fixed colours embedded |

Both outputs are committed (the Pages build has no Python). CI reruns the build and fails if the committed files differ.

## When to draw one

Draw a figure when it carries an argument that words and formulas carry badly: the shape of a distribution or the tails of two, what an interval's coverage means, base rates as areas, a likelihood sharpening with data, an error region and power. Do not draw decoration, a table in disguise, or anything that is only a restatement of a formula. A note has one **anchor figure**, at most three.

Each figure makes **one point**, and the point is the first thing the caption says: "At n = 2 the skew is obvious, by n = 30 the curves are hard to tell apart."

## Writing the script

```python
from kit import Fig
from dist import norm_pdf, t_pdf          # density helpers; add to dist.py if you need more

def build():
    f = Fig(760, 300)                                      # width x height in viewBox units
    ax = f.axes(52, 22, 520, 232, (-4, 4), (0, 0.42))      # left, top, width, height, xlim, ylim
    ax.frame(xticks=range(-4, 5, 2), yticks=(0, 0.2, 0.4), xlabel="value", ylabel="density")
    ax.curve(norm_pdf, cls="f-a-line")
    ax.curve(lambda x: t_pdf(x, 3), cls="f-b-line")
    f.legend(600, 70, [("normal", "f-a-line"), ("t, 3 df", "f-b-line")])
    return f
```

Kit: `Fig.rect/line/poly/circle/text/arrow/legend/axes`; `Axes.frame/curve/area/bars/vline/point/text` (data coordinates). Text markup: `x_{sub}`, `x^{sup}`, `*italic*`; Greek and symbols as Unicode (α β λ μ σ θ ≈ ≤ ∈). There is no LaTeX in an SVG.

### Style rules

- **Size**: wide figures `Fig(760, 250..330)`, margin figures `Fig(380, 230)`. The site scales them to the column; do not fix pixel sizes elsewhere.
- **Colour has a meaning, never a rank.** `a` blue: the subject of the figure. `b` orange: the contrast, or what to be wary of. `c` green: a reference or true value. `d` violet, `e` rose: further series. Ink, muted, faint for text, axes, guides. **Never write a colour value in a script**: use the classes `f-<a..e>-line` (stroke), `f-<a..e>-fill` (translucent area), `f-<a..e>-solid` (opaque), `f-<a..e>` (text), `f-line`, `f-dash` (add to a line class), `f-axis`, `f-grid`, `f-ink/f-muted/f-faint` (text), `f-box`.
- At most three series colours in one figure. Label curves directly or in a legend at the right of the plot, never in a separate key.
- Text 12 to 14 units. Labels at most four words. Axis labels only when the quantity is not obvious.
- Annotate the point (a critical value, the peak, the one missed interval), not everything.
- The plot area sits in the left 70% of a wide figure; the right 30% holds the legend and a two- to four-line remark in `f-muted`.
- **Deterministic**: simulations use `random.Random(seed)`; pick the seed that shows the *typical* case and say so in the docstring. The same script must give identical output on every machine (coordinates are rounded to 0.1).
- Docstring on the module: one line saying what the figure shows.

## Build and look

```bash
python3 tools/figures/build.py <course>       # writes both SVGs for every script of the course
```

Look at the result before using it: the print SVG renders standalone in any browser, or write a small HTML sheet and screenshot it with Playwright. Check for clipped labels, overlapping text, curves leaving the frame, legends colliding with curves, and that nothing relies on colour alone (a dashed line plus a label is fine).

## Using it

In a note:

```markdown
{% include fig.html src="statistics/clt" id="fig-clt" alt="Densities of the standardized mean of n exponential variables for n = 2, 5 and 30 against the standard normal. The curves approach the normal as n grows." caption="Standardized mean of $n$ exponential variables. At $n=2$ the skew is obvious, by $n=30$ the two curves are hard to tell apart." %}
```
`alt` says what is plotted and the visible result (a screen reader's only access); `caption` says what to look at. Both required, at least a full sentence. `place="margin"` for a small figure beside the text. Introduce the figure in the sentence before it.

In the reference: `#fig("/statistics/figures/clt.svg", caption: [...])` with a self-contained caption.

Commit the script **and both SVGs**.
