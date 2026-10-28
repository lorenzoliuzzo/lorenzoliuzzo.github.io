"""Two prototypes per class, trained by LVQ1 on two overlapping classes, and the decision regions they imply (seed chosen for the typical case)."""
import math
import random
from kit import Fig

X0, X1, Y0, Y1 = -3.4, 3.4, -2.6, 2.6


def build():
    rng = random.Random(4)
    A = [(rng.gauss(-1.0, 0.85), rng.gauss(0.0, 0.85)) for _ in range(60)]
    B = [(rng.gauss(1.0, 0.85), rng.gauss(0.3, 0.85)) for _ in range(60)]
    data = [(p, 0) for p in A] + [(p, 1) for p in B]
    protos = [[list(A[0]), 0], [list(A[1]), 0], [list(B[0]), 1], [list(B[1]), 1]]
    steps = 4000
    for t in range(steps):
        eta = 0.2 * (0.005 / 0.2) ** (t / steps)
        (x, y), lab = data[rng.randrange(len(data))]
        c = min(protos, key=lambda p: (p[0][0] - x) ** 2 + (p[0][1] - y) ** 2)
        sgn = 1 if c[1] == lab else -1
        c[0][0] += sgn * eta * (x - c[0][0])
        c[0][1] += sgn * eta * (y - c[0][1])
    f = Fig(760, 300)
    ax = f.axes(48, 28, 520, 240, (X0, X1), (Y0, Y1))
    f.rect(ax.x0, ax.y0, ax.w, ax.h, "f-box")
    nx, ny = 104, 56
    for j in range(ny):
        y = Y0 + (j + 0.5) * (Y1 - Y0) / ny
        run, start = None, 0
        for i in range(nx + 1):
            lab = None
            if i < nx:
                x = X0 + (i + 0.5) * (X1 - X0) / nx
                lab = min(protos, key=lambda p: (p[0][0] - x) ** 2 + (p[0][1] - y) ** 2)[1]
            if lab != run:
                if run is not None:
                    xa = X0 + start * (X1 - X0) / nx
                    xb = X0 + i * (X1 - X0) / nx
                    ya = Y0 + j * (Y1 - Y0) / ny
                    yb = Y0 + (j + 1) * (Y1 - Y0) / ny
                    f.rect(ax.X(xa), ax.Y(yb), ax.X(xb) - ax.X(xa), ax.Y(ya) - ax.Y(yb), "f-a-fill" if run == 0 else "f-b-fill")
                run, start = lab, i
    for (x, y), lab in data:
        if not (X0 < x < X1 and Y0 < y < Y1):
            continue
        ax.point(x, y, 2.8, "f-a-solid" if lab == 0 else "f-b-solid")
    for (x, y), lab in protos:
        f.circle(ax.X(x), ax.Y(y), 9, "f-box")
        f.circle(ax.X(x), ax.Y(y), 5.5, "f-a-solid" if lab == 0 else "f-b-solid")
    f.text(596, 70, "Small dots: training data.", "f-muted", 12.5)
    f.text(596, 88, "Rings: four prototypes.", "f-muted", 12.5)
    f.text(596, 118, "Shading: the class of the", "f-muted", 12.5)
    f.text(596, 136, "nearest prototype.", "f-muted", 12.5)
    return f
