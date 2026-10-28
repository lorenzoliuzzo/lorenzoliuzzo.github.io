"""AdaBoost on the XOR problem: three axis-parallel stumps, each wrong on a point, combine into a classifier that is right on all four."""
import math
from kit import Fig

POINTS = [((1, 0), 1), ((-1, 0), 1), ((0, 1), -1), ((0, -1), -1)]
CUTS = (-2.0, -0.5, 0.5, 2.0)


def stumps():
    out = []
    for j in (0, 1):
        for th in (-0.5, 0.5):
            out.append(lambda p, j=j, th=th: 1 if p[j] > th else -1)
            out.append(lambda p, j=j, th=th: -1 if p[j] > th else 1)
    return out


def run():
    """Three rounds of AdaBoost; ties between stumps go to the first one, as a fixed rule."""
    hs, D, rounds = stumps(), [0.25] * 4, []
    for _ in range(3):
        errs = [sum(d for d, (p, y) in zip(D, POINTS) if h(p) != y) for h in hs]
        i = min(range(len(hs)), key=lambda i: errs[i])
        e = errs[i]
        a = 0.5 * math.log((1 - e) / e)
        rounds.append((hs[i], e, a))
        D = [d * math.exp(-a * y * hs[i](p)) for d, (p, y) in zip(D, POINTS)]
        z = sum(D)
        D = [d / z for d in D]
    return rounds


def panel(f, ax, fn, title, sub, wrong):
    for i in range(3):
        for j in range(3):
            cx, cy = (CUTS[i] + CUTS[i + 1]) / 2, (CUTS[j] + CUTS[j + 1]) / 2
            cls = "f-a-fill" if fn((cx, cy)) > 0 else "f-b-fill"
            f.rect(ax.X(CUTS[i]), ax.Y(CUTS[j + 1]), ax.X(CUTS[i + 1]) - ax.X(CUTS[i]), ax.Y(CUTS[j]) - ax.Y(CUTS[j + 1]), cls)
    f.rect(ax.x0, ax.y0, ax.w, ax.h, "f-axis")
    for (p, y) in POINTS:
        ax.point(p[0], p[1], 6, "f-a-solid" if y > 0 else "f-b-solid")
        if fn(p) != y:
            f.circle(ax.X(p[0]), ax.Y(p[1]), 11, "f-line")
    f.text(ax.x0, ax.y0 - 28, title, "f-ink", 13, weight=600)
    f.text(ax.x0, ax.y0 - 10, sub, "f-muted", 12)


def build():
    rounds = run()
    f = Fig(760, 262)
    for k, (h, e, a) in enumerate(rounds):
        ax = f.axes(14 + k * 186, 52, 150, 150, (-2, 2), (-2, 2))
        panel(f, ax, h, f"round {k + 1}", f"ε = {e:.3f}, α = {a:.2f}", None)
    ax = f.axes(14 + 3 * 186, 52, 150, 150, (-2, 2), (-2, 2))
    H = lambda p: 1 if sum(a * h(p) for h, e, a in rounds) > 0 else -1
    panel(f, ax, H, "weighted vote", "sign of Σ αₜ hₜ", None)
    f.text(14, 232, "Blue: class +1. Orange: class −1. Shading is each classifier's prediction; a ringed point is one it gets wrong.", "f-muted", 12.5)
    return f
