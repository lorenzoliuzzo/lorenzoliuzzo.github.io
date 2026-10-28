"""Reduced van der Waals isotherms below, at and above the critical temperature, with the Maxwell construction for the lowest one."""
from kit import Fig


def p(v, t):
    return 8 * t / (3 * v - 1) - 3 / v ** 2


def roots(pr, t):
    out = []
    vs = [0.36 + i * 0.0005 for i in range(0, 8000)]
    for a, b in zip(vs, vs[1:]):
        fa, fb = p(a, t) - pr, p(b, t) - pr
        if fa * fb < 0:
            lo, hi = a, b
            for _ in range(50):
                mid = (lo + hi) / 2
                if (p(lo, t) - pr) * (p(mid, t) - pr) <= 0:
                    hi = mid
                else:
                    lo = mid
            out.append((lo + hi) / 2)
    return out


def area(pr, t):
    r = roots(pr, t)
    if len(r) < 3:
        return None
    v1, v3 = r[0], r[2]
    n = 800
    h = (v3 - v1) / n
    return sum((p(v1 + (i + 0.5) * h, t) - pr) * h for i in range(n)), v1, v3


def maxwell(t):
    lo, hi = 0.3, 0.7
    # pressure window where three roots exist: scan
    ps = [0.2 + i * 0.002 for i in range(400)]
    good = [x for x in ps if len(roots(x, t)) >= 3]
    lo, hi = good[0], good[-1]
    for _ in range(40):
        mid = (lo + hi) / 2
        a, _, _ = area(mid, t)
        if a > 0:
            lo = mid
        else:
            hi = mid
    pr = (lo + hi) / 2
    a, v1, v3 = area(pr, t)
    return pr, v1, v3


def build():
    f = Fig(760, 300)
    ax = f.axes(56, 24, 500, 230, (0.4, 3.6), (0, 1.5))
    ax.frame(xticks=(0.5, 1, 1.5, 2, 2.5, 3, 3.5), yticks=(0, 0.5, 1.0, 1.5), xlabel="reduced volume v", ylabel=None)
    for t, c in ((0.85, "b"), (1.0, "a"), (1.15, "c")):
        pts = [(ax.X(v), ax.Y(max(0.0, min(1.5, p(v, t))))) for v in [0.42 + 0.01 * i for i in range(319)]]
        f.poly(pts, f"f-{c}-line")
    pr, v1, v3 = maxwell(0.85)
    f.line(ax.X(v1), ax.Y(pr), ax.X(v3), ax.Y(pr), "f-line f-dash")
    ax.point(1.0, 1.0, 4.5, "f-a-solid")
    f.legend(590, 50, [("T = 0.85 Tc", "f-b-line"), ("T = Tc", "f-a-line"), ("T = 1.15 Tc", "f-c-line"), ("coexistence", "f-line f-dash")])
    f.text(590, 150, f"Maxwell line at p = {pr:.2f} pc.", "f-muted", 12.5)
    f.text(590, 168, "Dot: the critical point,", "f-muted", 12.5)
    f.text(590, 186, "where an isotherm has an", "f-muted", 12.5)
    f.text(590, 204, "inflection with zero slope.", "f-muted", 12.5)
    return f
