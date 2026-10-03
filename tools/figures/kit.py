"""A small SVG kit for note figures. Standard library only.

A figure script builds one `Fig` out of axes, curves, bars and labels. `build.py`
renders it twice:

  site   _includes/fig/<course>/<name>.svg
         Classes only. _sass/_blocks.scss colours them from the site tokens, so the
         figure follows the light and dark themes. Included with {% include fig.html %}.
  print  assets/notes/<course>/figures/<name>.svg
         The same classes plus an embedded <style> with fixed colours, for Typst.

Colour has a meaning, not a rank. Series a (blue) is the thing the figure is about,
b (orange) its contrast or the thing to be wary of, c (green) a reference or true
value, d (violet) and e (rose) further series. Ink, muted and faint are for text,
axes and guides. Never write a colour in a figure script; use a class.
"""
import math
import re

# Fixed colours for the print rendering. Same hues as --hue-1..6 in _sass/_tokens.scss.
PRINT = {
    "ink": "#1b1f23", "muted": "#5f6971", "faint": "#8a939b", "grid": "#e3dfd5",
    "border": "#bdb7aa", "box": "#ffffff",
    "a": "#26647f", "b": "#b4581f", "c": "#2f7d52", "d": "#7b4f9d", "e": "#a63a62",
}
SERIES = "abcde"


def print_css():
    p = PRINT
    rules = [
        f".f-ink{{fill:{p['ink']}}}.f-muted{{fill:{p['muted']}}}.f-faint{{fill:{p['faint']}}}",
        ".f-i{font-style:italic}",
        f".f-axis{{stroke:{p['muted']};stroke-width:1.2;fill:none}}",
        f".f-grid{{stroke:{p['grid']};stroke-width:1;fill:none}}",
        f".f-line{{stroke:{p['ink']};stroke-width:1.4;fill:none}}",
        ".f-dash{stroke-dasharray:5 4}",
        f".f-arrow{{fill:{p['muted']}}}",
        f".f-box{{fill:{p['box']};stroke:{p['border']};stroke-width:1.2}}",
    ]
    for k in SERIES:
        c = p[k]
        rules += [
            f".f-{k}{{fill:{c}}}",
            f".f-{k}-line{{stroke:{c};stroke-width:2.2;fill:none}}",
            f".f-{k}-fill{{fill:{c};fill-opacity:.22;stroke:none}}",
            f".f-{k}-solid{{fill:{c};stroke:none}}",
        ]
    return "".join(rules)


def known_classes():
    names = {"f-ink", "f-muted", "f-faint", "f-i", "f-axis", "f-grid", "f-line", "f-dash", "f-arrow", "f-box"}
    for k in SERIES:
        names |= {f"f-{k}", f"f-{k}-line", f"f-{k}-fill", f"f-{k}-solid"}
    return names


def _esc(s):
    return s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")


def mark(s):
    """Tiny text markup: x_{sub}, x^{sup}, *italic*. Everything else is literal."""
    out, rise = [], 0
    for part in re.split(r"(_\{[^}]*\}|\^\{[^}]*\}|\*[^*]+\*)", s):
        if not part:
            continue
        pre = f' dy="{-rise}"' if rise else ""
        if part.startswith("_{"):
            out.append(f'<tspan font-size="75%" dy="{4 - rise}">{_esc(part[2:-1])}</tspan>')
            rise = -4
        elif part.startswith("^{"):
            out.append(f'<tspan font-size="75%" dy="{-5 - rise}">{_esc(part[2:-1])}</tspan>')
            rise = 5
        elif part.startswith("*"):
            out.append(f'<tspan class="f-i"{pre}>{_esc(part[1:-1])}</tspan>')
            rise = 0
        else:
            out.append(f"<tspan{pre}>{_esc(part)}</tspan>" if rise else _esc(part))
            rise = 0
    return "".join(out)


def _n(v):
    return f"{v:.1f}".rstrip("0").rstrip(".") if abs(v) < 1e5 else str(v)


class Fig:
    def __init__(self, width=760, height=300):
        self.w, self.h = width, height
        self.items = []
        self.classes = set()

    def _c(self, cls):
        self.classes.update(cls.split())
        return cls

    def raw(self, s):
        self.items.append(s)

    def rect(self, x, y, w, h, cls="f-box", rx=0):
        self.raw(f'<rect x="{_n(x)}" y="{_n(y)}" width="{_n(w)}" height="{_n(h)}" rx="{rx}" class="{self._c(cls)}"/>')

    def line(self, x1, y1, x2, y2, cls="f-line"):
        self.raw(f'<line x1="{_n(x1)}" y1="{_n(y1)}" x2="{_n(x2)}" y2="{_n(y2)}" class="{self._c(cls)}"/>')

    def poly(self, pts, cls, close=False):
        d = "M" + " L".join(f"{_n(x)},{_n(y)}" for x, y in pts) + (" Z" if close else "")
        self.raw(f'<path d="{d}" class="{self._c(cls)}"/>')

    def circle(self, x, y, r, cls="f-a-solid"):
        self.raw(f'<circle cx="{_n(x)}" cy="{_n(y)}" r="{_n(r)}" class="{self._c(cls)}"/>')

    def text(self, x, y, s, cls="f-ink", size=13, anchor="start", weight=None):
        w = f' font-weight="{weight}"' if weight else ""
        self.raw(f'<text x="{_n(x)}" y="{_n(y)}" font-size="{size}" text-anchor="{anchor}"{w} class="{self._c(cls)}">{mark(s)}</text>')

    def arrow(self, x1, y1, x2, y2, cls="f-line"):
        self.line(x1, y1, x2, y2, cls)
        a = math.atan2(y2 - y1, x2 - x1)
        L, W = 8, 3.6
        p = [(x2, y2), (x2 - L * math.cos(a) + W * math.sin(a), y2 - L * math.sin(a) - W * math.cos(a)),
             (x2 - L * math.cos(a) - W * math.sin(a), y2 - L * math.sin(a) + W * math.cos(a))]
        self.poly(p, "f-arrow", close=True)

    def legend(self, x, y, entries, gap=20, size=12.5):
        """entries: [(label, line_class)] stacked from (x, y)."""
        for i, (label, cls) in enumerate(entries):
            yy = y + i * gap
            self.line(x, yy - 4, x + 26, yy - 4, cls)
            self.text(x + 34, yy, label, "f-muted", size)

    def axes(self, x, y, w, h, xlim, ylim):
        return Axes(self, x, y, w, h, xlim, ylim)

    def svg(self, theme="site"):
        head = f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {self.w} {self.h}" width="{self.w}" height="{self.h}" font-size="13">'
        if theme == "print":
            head += f'<style>{print_css()}text{{font-family:"Libertinus Serif","New Computer Modern",serif}}</style>'
        return head + "".join(self.items) + "</svg>"


class Axes:
    def __init__(self, fig, x, y, w, h, xlim, ylim):
        self.fig, self.x0, self.y0, self.w, self.h = fig, x, y, w, h
        self.xlim, self.ylim = xlim, ylim

    def X(self, v):
        return self.x0 + (v - self.xlim[0]) / (self.xlim[1] - self.xlim[0]) * self.w

    def Y(self, v):
        return self.y0 + self.h - (v - self.ylim[0]) / (self.ylim[1] - self.ylim[0]) * self.h

    def frame(self, xticks=(), yticks=(), xlabel=None, ylabel=None, grid=True, xfmt=None, yfmt=None, yaxis=True):
        f = self.fig
        xfmt = xfmt or (lambda v: f"{v:g}")
        yfmt = yfmt or (lambda v: f"{v:g}")
        yb = self.Y(self.ylim[0])
        if grid:
            for v in yticks:
                f.line(self.x0, self.Y(v), self.x0 + self.w, self.Y(v), "f-grid")
        f.line(self.x0, yb, self.x0 + self.w, yb, "f-axis")
        if yaxis:
            f.line(self.x0, self.y0, self.x0, yb, "f-axis")
        for v in xticks:
            f.line(self.X(v), yb, self.X(v), yb + 4, "f-axis")
            f.text(self.X(v), yb + 18, xfmt(v), "f-muted", 12, "middle")
        if yaxis:
            for v in yticks:
                f.text(self.x0 - 8, self.Y(v) + 4, yfmt(v), "f-muted", 12, "end")
        if xlabel:
            f.text(self.x0 + self.w / 2, yb + 38, xlabel, "f-muted", 13, "middle")
        if ylabel:
            f.text(self.x0 - 40, self.y0 - 8, ylabel, "f-muted", 13, "start")

    def _xs(self, x0, x1, n):
        return [x0 + (x1 - x0) * i / n for i in range(n + 1)]

    def curve(self, fn, x0=None, x1=None, cls="f-a-line", n=240):
        x0 = self.xlim[0] if x0 is None else x0
        x1 = self.xlim[1] if x1 is None else x1
        self.fig.poly([(self.X(x), self.Y(fn(x))) for x in self._xs(x0, x1, n)], cls)

    def area(self, fn, x0, x1, cls="f-a-fill", n=120):
        pts = [(self.X(x), self.Y(fn(x))) for x in self._xs(x0, x1, n)]
        pts = [(self.X(x0), self.Y(0))] + pts + [(self.X(x1), self.Y(0))]
        self.fig.poly(pts, cls, close=True)

    def bars(self, xs, ys, width, cls="f-a-fill", edge="f-a-line"):
        for x, y in zip(xs, ys):
            self.fig.rect(self.X(x) - width / 2, self.Y(y), width, self.Y(0) - self.Y(y), cls)

    def vline(self, x, y0=None, y1=None, cls="f-line f-dash"):
        y0 = self.ylim[0] if y0 is None else y0
        y1 = self.ylim[1] if y1 is None else y1
        self.fig.line(self.X(x), self.Y(y0), self.X(x), self.Y(y1), cls)

    def point(self, x, y, r=3.5, cls="f-a-solid"):
        self.fig.circle(self.X(x), self.Y(y), r, cls)

    def text(self, x, y, s, cls="f-ink", size=13, anchor="start", weight=None):
        self.fig.text(self.X(x), self.Y(y), s, cls, size, anchor, weight)
