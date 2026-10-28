"""Five-fold cross-validation: each round validates on a different fold and trains on the other four; the test set is never touched."""
from kit import Fig


def build():
    f = Fig(760, 250)
    x0, y0, w, h, gap = 96, 44, 76, 28, 4
    tx = x0 + 5 * (w + gap) + 24
    f.text(x0, 24, "labelled data, split into five folds", "f-ink", 13, weight=600)
    f.text(tx, 24, "test set", "f-ink", 13, weight=600)
    for r in range(5):
        y = y0 + r * (h + 8)
        f.text(x0 - 12, y + h / 2 + 4, f"round {r + 1}", "f-muted", 12.5, "end")
        for c in range(5):
            x = x0 + c * (w + gap)
            if c == r:
                f.rect(x, y, w, h, "f-b-fill")
                f.rect(x, y, w, h, "f-b-line")
            else:
                f.rect(x, y, w, h, "f-a-fill")
            f.text(x + w / 2, y + h / 2 + 4, "validate" if c == r else "train", "f-ink", 12, "middle")
        f.rect(tx, y, 92, h, "f-box f-dash")
        f.text(tx + 46, y + h / 2 + 4, "untouched", "f-faint", 12, "middle")
    f.text(x0, 236, "The estimate is the mean of the five validation errors.", "f-muted", 12.5)
    return f
