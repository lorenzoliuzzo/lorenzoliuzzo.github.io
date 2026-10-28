"""A cascade of four stages, each passing 30% of the windows it receives: almost all windows are rejected by the cheap early stages."""
from kit import Fig

PASS = 0.3
START = 100000


def build():
    f = Fig(760, 270)
    n, x0, y0, w, h, gap = START, 36, 54, 118, 60, 38
    f.text(x0, 28, "windows reaching each stage, if every stage passes 30% of them", "f-ink", 13, weight=600)
    labels = ["stage 1", "stage 2", "stage 3", "stage 4"]
    notes = ["cheapest", "", "", "costliest"]
    for i, name in enumerate(labels):
        x = x0 + i * (w + gap)
        f.rect(x, y0, w, h, "f-a-fill")
        f.rect(x, y0, w, h, "f-a-line")
        f.text(x + w / 2, y0 + 25, name, "f-ink", 13.5, "middle", 600)
        if notes[i]:
            f.text(x + w / 2, y0 + 45, notes[i], "f-muted", 12, "middle")
        f.text(x + w / 2, y0 - 8, f"{round(n):,}", "f-ink", 13, "middle")
        if i:
            f.arrow(x - gap + 4, y0 + h / 2, x - 4, y0 + h / 2, "f-line")
        rejected = round(n * (1 - PASS))
        f.arrow(x + w / 2, y0 + h + 4, x + w / 2, y0 + h + 58, "f-b-line")
        f.text(x + w / 2, y0 + h + 76, f"rejected: {rejected:,}", "f-b", 12.5, "middle")
        n *= PASS
    x = x0 + 4 * (w + gap) - gap + 10
    f.arrow(x - 14, y0 + h / 2, x + 10, y0 + h / 2, "f-line")
    f.text(x - 2, y0 + h / 2 - 12, f"{round(n):,}", "f-ink", 13, "start")
    f.text(x - 2, y0 + h / 2 + 18, "passed all:", "f-muted", 12, "start")
    f.text(x - 2, y0 + h / 2 + 34, "faces", "f-muted", 12, "start")
    f.text(x0, 250, "A window that survives every stage is reported as a face; one that fails any stage is dropped at once.", "f-muted", 12.5)
    return f
