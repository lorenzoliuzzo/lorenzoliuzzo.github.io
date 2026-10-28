"""Entropy bookkeeping when 1000 J flows from a reservoir at 400 K to one at 300 K: the hot one loses 2.50 J/K, the cold one gains 3.33 J/K, the total rises by 0.83 J/K."""
from kit import Fig

Q, TH, TC = 1000.0, 400.0, 300.0


def build():
    f = Fig(760, 280)
    ax = f.axes(70, 24, 400, 200, (0, 3), (-3.2, 4.2))
    ax.frame(yticks=(-2, 0, 2, 4), ylabel="entropy change (J/K)", grid=True)
    vals = [(-Q / TH, "f-b-fill", "f-b-line", "hot reservoir"), (Q / TC, "f-a-fill", "f-a-line", "cold reservoir"),
            (Q / TC - Q / TH, "f-c-fill", "f-c-line", "total")]
    for i, (v, fill, edge, name) in enumerate(vals):
        y0, y1 = sorted((ax.Y(0), ax.Y(v)))
        f.rect(ax.X(i + 0.5) - 34, y0, 68, y1 - y0, fill)
        ax.text(i + 0.5, v + (0.35 if v > 0 else -0.55), f"{v:+.2f}", "f-ink", 13, "middle")
        f.text(ax.X(i + 0.5), 244, name, "f-muted", 12.5, "middle")
    f.text(510, 90, "*Q* = 1000 J flows from", "f-muted", 12.5)
    f.text(510, 108, "400 K to 300 K.", "f-muted", 12.5)
    f.text(510, 140, "Each reservoir changes by", "f-muted", 12.5)
    f.text(510, 158, "*Q*/*T*; the colder one gains more", "f-muted", 12.5)
    f.text(510, 176, "than the hotter one loses.", "f-muted", 12.5)
    return f
