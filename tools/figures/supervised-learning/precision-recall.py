"""Precision-recall curve of ten ranked detections for six objects, and the area under its monotone envelope, the average precision."""
from kit import Fig

HITS = [1, 1, 0, 1, 1, 0, 0, 1, 0, 0]  # 1 = true positive, in order of decreasing confidence
OBJECTS = 6


def points():
    tp, out = 0, []
    for i, h in enumerate(HITS, 1):
        tp += h
        out.append((tp / OBJECTS, tp / i))
    return out


def envelope(pts):
    """Step function: at recall r, the best precision among points with recall >= r."""
    steps, prev = [], 0.0
    for r in sorted({p[0] for p in pts}):
        steps.append((prev, r, max(p[1] for p in pts if p[0] >= r)))
        prev = r
    return steps


def average_precision():
    return sum((r1 - r0) * p for r0, r1, p in envelope(points()))


def build():
    pts = points()
    f = Fig(760, 300)
    ax = f.axes(60, 24, 300, 228, (0, 1), (0, 1.05))
    ax.frame(xticks=(0, 0.5, 1), yticks=(0, 0.5, 1), xlabel="recall", ylabel="precision")
    for r0, r1, p in envelope(pts):
        f.rect(ax.X(r0), ax.Y(p), ax.X(r1) - ax.X(r0), ax.Y(0) - ax.Y(p), "f-a-fill")
    f.poly([(ax.X(r), ax.Y(p)) for r, p in pts], "f-b-line")
    for (r, p), h in zip(pts, HITS):
        ax.point(r, p, 3.6, "f-b-solid" if h else "f-line")
    f.text(404, 60, "ranked detections", "f-ink", 13, weight=600)
    for i, h in enumerate(HITS):
        x = 404 + i * 30
        f.rect(x, 70, 26, 26, "f-a-fill" if h else "f-b-fill")
        f.text(x + 13, 88, "TP" if h else "FP", "f-ink", 11.5, "middle")
    f.text(404, 130, f"6 objects in the images, 5 of them found.", "f-muted", 12.5)
    f.text(404, 154, "Orange: precision after each detection", "f-muted", 12.5)
    f.text(404, 171, "(ring: after a false positive).", "f-muted", 12.5)
    f.text(404, 194, "Blue area: the same curve with each", "f-muted", 12.5)
    f.text(404, 211, "value replaced by the best one at", "f-muted", 12.5)
    f.text(404, 228, "equal or higher recall.", "f-muted", 12.5)
    f.text(404, 262, f"average precision = {average_precision():.2f}", "f-ink", 13.5, weight=600)
    return f
