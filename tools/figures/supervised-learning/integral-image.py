"""Any rectangle sum from four values of the integral image: D = ii(4) + ii(1) - ii(2) - ii(3)."""
from kit import Fig


def build():
    f = Fig(760, 280)
    x0, y0, w, h = 60, 30, 330, 200
    cx, cy = x0 + 150, y0 + 80  # corner shared by the four regions
    ex, ey = x0 + 280, y0 + 170  # outer corner of D
    f.rect(x0, y0, w - 20, h, "f-box")
    f.rect(cx, cy, ex - cx, ey - cy, "f-b-fill")
    f.line(cx, y0, cx, y0 + h, "f-grid")
    f.line(x0, cy, x0 + w - 20, cy, "f-grid")
    f.line(ex, y0, ex, y0 + h, "f-grid")
    f.line(x0, ey, x0 + w - 20, ey, "f-grid")
    for (px, py, tag) in ((x0 + 60, y0 + 40, "A"), ((cx + ex) / 2, y0 + 40, "B"), (x0 + 60, (cy + ey) / 2 + 4, "C"), ((cx + ex) / 2, (cy + ey) / 2 + 4, "D")):
        f.text(px, py, tag, "f-ink" if tag != "D" else "f-b", 18, "middle", 600)
    for (px, py, tag, anchor) in ((cx, cy, "1", "end"), (ex, cy, "2", "start"), (cx, ey, "3", "end"), (ex, ey, "4", "start")):
        f.circle(px, py, 4.5, "f-a-solid")
        f.text(px + (-8 if anchor == "end" else 8), py + (-6 if tag in "12" else 16), tag, "f-a", 13, anchor, 600)
    f.text(x0, 22, "the image, with the top-left corner at its origin", "f-muted", 12.5)
    f.text(430, 70, "ii(1) = A", "f-ink", 13)
    f.text(430, 92, "ii(2) = A + B", "f-ink", 13)
    f.text(430, 114, "ii(3) = A + C", "f-ink", 13)
    f.text(430, 136, "ii(4) = A + B + C + D", "f-ink", 13)
    f.text(430, 178, "D = ii(4) + ii(1) − ii(2) − ii(3)", "f-b", 14, weight=600)
    f.text(430, 202, "Four lookups, whatever the size of D.", "f-muted", 12.5)
    return f
