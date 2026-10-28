"""The bipartite graph of a restricted Boltzmann machine."""
from kit import Fig


def build():
    f = Fig(760, 250)
    nv, nh = 5, 3
    xv = [140 + 80 * i for i in range(nv)]
    xh = [220 + 110 * j for j in range(nh)]
    yv, yh = 200, 70
    for x in xv:
        for xx in xh:
            f.line(x, yv, xx, yh, "f-line")
    for i, x in enumerate(xv):
        f.circle(x, yv, 14, "f-a-solid")
        f.text(x, yv + 34, f"v_{{{i + 1}}}", "f-ink", 13, "middle")
    for j, x in enumerate(xh):
        f.circle(x, yh, 14, "f-b-solid")
        f.text(x, yh - 24, f"h_{{{j + 1}}}", "f-ink", 13, "middle")
    f.text(20, yv + 4, "visible", "f-a", 13)
    f.text(20, yh + 4, "hidden", "f-b", 13)
    f.text(540, 60, "Each line carries a weight W.", "f-muted", 13)
    f.text(540, 80, "No couplings within a layer.", "f-muted", 13)
    return f
