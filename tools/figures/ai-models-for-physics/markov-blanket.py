"""A grid Markov random field with one node and its neighbours highlighted."""
from kit import Fig


def build():
    R, C, s = 5, 7, 52
    f = Fig(760, 280)
    ox, oy = 90, 30
    hot = (2, 3)
    nbr = {(1, 3), (3, 3), (2, 2), (2, 4)}
    for r in range(R):
        for c in range(C):
            if c + 1 < C:
                f.line(ox + c * s, oy + r * s, ox + (c + 1) * s, oy + r * s, "f-line")
            if r + 1 < R:
                f.line(ox + c * s, oy + r * s, ox + c * s, oy + (r + 1) * s, "f-line")
    for r in range(R):
        for c in range(C):
            cls = "f-b-solid" if (r, c) == hot else ("f-a-solid" if (r, c) in nbr else "f-box")
            f.circle(ox + c * s, oy + r * s, 11, cls)
    f.text(480, 252, "", "f-muted", 12)
    f.legend(500, 60, [("the variable", "f-b-line"), ("its neighbours", "f-a-line"), ("conditionally independent of it", "f-line")], gap=24)
    return f
