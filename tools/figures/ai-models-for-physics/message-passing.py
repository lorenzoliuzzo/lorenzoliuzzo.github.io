"""The nodes that one node reads after one and two message-passing layers."""
from kit import Fig

EDGES = [(0, 1), (0, 2), (0, 3), (1, 4), (2, 5), (2, 6), (3, 7), (4, 8), (5, 8), (6, 7), (7, 9), (8, 9)]
POS = [(120, 140), (200, 70), (200, 140), (200, 215), (290, 50), (290, 120), (290, 175), (290, 240), (380, 85), (380, 215)]


def build():
    n = len(POS)
    nb = {i: set() for i in range(n)}
    for a, b in EDGES:
        nb[a].add(b)
        nb[b].add(a)
    d1 = nb[0]
    d2 = set().union(*(nb[u] for u in d1)) - d1 - {0}
    f = Fig(760, 280)
    for a, b in EDGES:
        f.line(*POS[a], *POS[b], "f-line")
    for i, (x, y) in enumerate(POS):
        cls = "f-b-solid" if i == 0 else ("f-a-solid" if i in d1 else ("f-c-solid" if i in d2 else "f-box"))
        f.circle(x, y, 13, cls)
    f.legend(520, 80, [("the node", "f-b-line"), ("1-hop: read by layer 1", "f-a-line"), ("2-hop: reached by layer 2", "f-c-line"), ("not reached yet", "f-line")], gap=24)
    return f
