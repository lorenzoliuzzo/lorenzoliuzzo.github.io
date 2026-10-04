"""RANSAC fitting a line through 24 points, 8 of them outliers: a trial from two outliers gets 4 inliers, the best of 20 trials follows the true line and gets 17 inliers."""
import random
from kit import Fig

TOL = 0.55


def line_through(p, q):
    a = (q[1] - p[1]) / (q[0] - p[0])
    return a, p[1] - a * p[0]


def inliers(pts, a, b):
    return [p for p in pts if abs(p[1] - (a * p[0] + b)) <= TOL]


def build():
    rng = random.Random(6)
    good = [(x, 0.6 * x + 1.0 + rng.gauss(0, 0.18)) for x in [rng.uniform(0, 10) for _ in range(16)]]
    bad = [(rng.uniform(0, 10), rng.uniform(0, 8)) for _ in range(8)]
    pts = good + bad
    trials = []
    while len(trials) < 20:
        p, q = rng.sample(pts, 2)
        if abs(p[0] - q[0]) < 0.5:  # a near-vertical line is a bad hypothesis for y = ax + b
            continue
        a, b = line_through(p, q)
        trials.append((len(inliers(pts, a, b)), a, b, p, q))
    best = max(trials)
    first = min(trials[:6])
    f = Fig(760, 290)
    for k, ((n, a, b, p, q), title) in enumerate(((first, "a poor trial"), (best, "the best of %d trials" % len(trials)))):
        ax = f.axes(40 + k * 370, 44, 310, 210, (0, 10), (0, 8))
        ax.frame(xticks=(), yticks=(), grid=False, yaxis=False)
        f.line(ax.x0, ax.y0, ax.x0, ax.y0 + ax.h, "f-axis")
        f.text(ax.x0, 28, f"{title}: {n} inliers", "f-ink", 13, weight=600)
        f.poly([(ax.X(0), ax.Y(max(0, min(8, b - TOL)))), (ax.X(10), ax.Y(max(0, min(8, 10 * a + b - TOL)))),
                (ax.X(10), ax.Y(max(0, min(8, 10 * a + b + TOL)))), (ax.X(0), ax.Y(max(0, min(8, b + TOL))))], "f-c-fill", close=True)
        f.line(ax.X(0), ax.Y(max(0, min(8, b))), ax.X(10), ax.Y(max(0, min(8, 10 * a + b))), "f-c-line")
        inl = set(inliers(pts, a, b))
        for pt in pts:
            ax.point(pt[0], pt[1], 3.6, "f-a-solid" if pt in inl else "f-b-solid")
        for pt in (p, q):
            f.circle(ax.X(pt[0]), ax.Y(pt[1]), 8.5, "f-line")
    f.text(40, 280, "Ringed: the two points that define the trial line. Blue: inliers of that line. Orange: the rest.", "f-muted", 12.5)
    return f
