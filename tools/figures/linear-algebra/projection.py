"""Orthogonal projection of v onto the line spanned by u: the residual is perpendicular to u."""
import math
from kit import Fig

V = (3.0, 2.0)
U = (4.0, 1.0)


def build():
    f = Fig(760, 300)
    s, ox, oy = 70, 90, 240
    P = lambda x, y: (ox + x * s, oy - y * s)
    t = (V[0] * U[0] + V[1] * U[1]) / (U[0] ** 2 + U[1] ** 2)
    p = (t * U[0], t * U[1])
    f.line(*P(-0.5, -0.5 / 4), *P(4.6, 4.6 / 4), "f-grid")
    f.line(*P(*p), *P(*V), "f-b-line f-dash")
    f.arrow(*P(0, 0), *P(*V), "f-a-line")
    f.arrow(*P(0, 0), *P(*p), "f-c-line")
    f.arrow(*P(0, 0), *P(*U), "f-line")
    f.text(*P(V[0] + 0.1, V[1] + 0.1), "*v*", "f-ink", 14)
    f.text(*P(p[0] + 0.1, p[1] - 0.3), "proj *v*", "f-ink", 13)
    f.text(*P(U[0] + 0.1, U[1] - 0.05), "*u*", "f-ink", 14)
    f.text(*P(p[0] + 0.1, (p[1] + V[1]) / 2), "*v* − proj *v*", "f-muted", 12.5)
    dot = (V[0] - p[0]) * U[0] + (V[1] - p[1]) * U[1]
    f.text(430, 70, "proj *v* = (*v*·*u* / *u*·*u*) *u*", "f-ink", 13)
    f.text(430, 96, "*v* = (3, 2), *u* = (4, 1)", "f-muted", 12.5)
    f.text(430, 114, f"*v*·*u* / *u*·*u* = {t:.4f}", "f-muted", 12.5)
    f.text(430, 132, f"proj *v* = ({p[0]:.3f}, {p[1]:.3f})", "f-muted", 12.5)
    f.text(430, 150, "(*v* − proj *v*)·*u* = 0", "f-muted", 12.5)
    return f
