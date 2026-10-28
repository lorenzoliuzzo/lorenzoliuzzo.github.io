"""Field of a uniformly charged sphere from Gauss's law: linear inside, inverse square outside."""
from kit import Fig


def E(r):
    return r if r < 1 else 1 / (r * r)


def build():
    f = Fig(760, 290)
    ax = f.axes(70, 20, 470, 220, (0, 4), (0, 1.1))
    ax.frame(xticks=(0, 1, 2, 3, 4), yticks=(0, 0.5, 1.0), xlabel="distance *r* / *R*")
    ax.curve(E, 0, 4, "f-a-line", 400)
    ax.curve(lambda r: 1 / (r * r), 1, 4, "f-b-line f-dash", 100) if False else None
    ax.vline(1.0, 0, 1.1)
    ax.point(1.0, 1.0, 4)
    f.legend(570, 50, [("*E*(*r*) / *E*(*R*)", "f-a-line")])
    f.text(570, 100, "inside: *E* ∝ *r*", "f-muted", 12.5)
    f.text(570, 118, "(enclosed charge ∝ *r*^{3},", "f-muted", 12.5)
    f.text(570, 136, "area ∝ *r*^{2})", "f-muted", 12.5)
    f.text(570, 164, "outside: *E* = *Q* / (4π*ε*_{0}*r*^{2})", "f-muted", 12.5)
    return f
