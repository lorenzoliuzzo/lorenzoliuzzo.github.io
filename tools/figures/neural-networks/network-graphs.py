"""The same vocabulary describes an acyclic graph (feed-forward) and a graph with a cycle (recurrent)."""
from kit import Fig


def node(f, x, y, kind):
    fill, line = {"in": ("f-c-fill", "f-c-line"), "hid": ("f-box", "f-line"), "out": ("f-b-fill", "f-b-line")}[kind]
    f.circle(x, y, 15, fill)
    f.circle(x, y, 15, line)


def link(f, a, b, r=15):
    import math
    dx, dy = b[0] - a[0], b[1] - a[1]
    d = math.hypot(dx, dy)
    ux, uy = dx / d, dy / d
    f.arrow(a[0] + ux * r, a[1] + uy * r, b[0] - ux * (r + 2), b[1] - uy * (r + 2), "f-line")


def build():
    f = Fig(760, 270)
    f.text(36, 26, "feed-forward: no cycle", "f-ink", 13, weight=600)
    f.text(420, 26, "recurrent: a cycle among the hidden units", "f-ink", 13, weight=600)

    ins = [(60, 90), (60, 170)]
    hid = [(160, 60), (160, 130), (160, 200)]
    out = [(260, 130)]
    for a in ins:
        for b in hid:
            link(f, a, b)
    for a in hid:
        link(f, a, out[0])
    for p in ins:
        node(f, *p, "in")
    for p in hid:
        node(f, *p, "hid")
    node(f, *out[0], "out")
    f.text(60, 122, "U_{in}", "f-c", 12, "middle")
    f.text(160, 238, "U_{hid}", "f-muted", 12, "middle")
    f.text(260, 162, "U_{out}", "f-b", 12, "middle")

    ins2 = [(430, 130)]
    a, b, c = (530, 70), (630, 130), (530, 200)
    out2 = [(720, 130)]
    link(f, ins2[0], a)
    link(f, a, b)
    link(f, b, c)
    link(f, c, a)
    link(f, b, out2[0])
    node(f, *ins2[0], "in")
    for p in (a, b, c):
        node(f, *p, "hid")
    node(f, *out2[0], "out")
    f.text(430, 162, "U_{in}", "f-c", 12, "middle")
    f.text(720, 162, "U_{out}", "f-b", 12, "middle")
    f.text(36, 262, "Left: one pass in topological order computes everything. Right: the outputs must be recomputed until they stop changing.", "f-muted", 12.5)
    return f
