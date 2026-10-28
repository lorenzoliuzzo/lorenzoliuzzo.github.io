"""Each 3-wide layer adds two to the receptive field: the top unit sees 3, 5 and then 7 inputs."""
from kit import Fig

CX = 300
DX = 42
ROWS = [(5, 56, "output"), (7, 128, "layer 2"), (9, 200, "layer 1"), (11, 272, "input")]


def pos(n, i):
    return CX + (i - (n - 1) / 2) * DX


def build():
    f = Fig(760, 330)
    top = 2  # centre unit of the output row
    reach = {0: {top}}
    for r in range(1, 4):
        reach[r] = {j for i in reach[r - 1] for j in (i, i + 1, i + 2)}
    # connections of the highlighted units
    for r in range(3):
        n_up, y_up, _ = ROWS[r]
        n_dn, y_dn, _ = ROWS[r + 1]
        for i in sorted(reach[r]):
            for j in (i, i + 1, i + 2):
                f.line(pos(n_up, i), y_up, pos(n_dn, j), y_dn, "f-a-line")
    for r, (n, y, name) in enumerate(ROWS):
        for i in range(n):
            f.circle(pos(n, i), y, 8, "f-a-solid" if i in reach[r] else "f-box")
        f.text(14, y + 4, name, "f-muted", 13)
    f.text(560, 60, "1 unit", "f-ink", 13, weight=600)
    for r, size in ((1, 3), (2, 5), (3, 7)):
        f.text(560, ROWS[r][1] + 4, f"sees {size} {'units' if r < 3 else 'inputs'}", "f-ink", 13, weight=600 if r == 3 else None)
    f.text(60, 316, "One dimension for clarity; in two dimensions the 3×3 windows give 3×3, 5×5, 7×7.", "f-muted", 12.5)
    return f
