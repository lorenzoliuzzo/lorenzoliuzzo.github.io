"""Base rate: 1000 people, 1% sick, 95% sensitivity, 10% false-positive rate."""
from kit import Fig


def build():
    f = Fig(760, 262)
    px, x0, bar = 0.7, 30, 34  # pixels per person, left edge, bar height
    sick, healthy = 10, 990
    tp, fp = sick * 0.95, healthy * 0.10

    f.text(x0, 24, "Everyone tested", "f-muted", 13)
    y1 = 34
    f.rect(x0, y1, sick * px, bar, "f-a-solid")
    f.rect(x0 + sick * px, y1, healthy * px, bar, "f-box")
    f.text(x0 + sick * px + healthy * px / 2, y1 + 22, "990 healthy", "f-muted", 14, "middle")
    f.line(x0 + 3.5, y1 + bar, x0 + 3.5, y1 + bar + 12, "f-axis")
    f.text(x0, y1 + bar + 28, "10 sick (1%)", "f-a", 13, weight=600)

    y2 = 140
    f.text(x0, y2 - 10, "Tested positive", "f-muted", 13)
    f.rect(x0, y2, tp * px, bar, "f-a-solid")
    f.rect(x0 + tp * px, y2, fp * px, bar, "f-b-solid")
    f.line(x0 + tp * px / 2, y2 + bar, x0 + tp * px / 2, y2 + bar + 12, "f-axis")
    f.text(x0, y2 + bar + 28, "9.5 sick, correctly flagged (95% of 10)", "f-a", 13, weight=600)
    f.text(x0 + (tp + fp) * px + 12, y2 + 22, "99 healthy, wrongly flagged (10% of 990)", "f-b", 13, weight=600)

    f.text(x0, 250, "Among the 108.5 positives only 9.5 are sick:  P(sick | positive) = 9.5 / 108.5 ≈ 8.8%", "f-ink", 14)
    return f
