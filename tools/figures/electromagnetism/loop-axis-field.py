"""On-axis field of a circular current loop against distance z, in units of its centre value, with the dipole law 1/z^3 that it approaches far away."""
from kit import Fig


def exact(z):
    return (1 + z * z) ** -1.5


def dipole(z):
    return z ** -3


def build():
    f = Fig(760, 290)
    ax = f.axes(52, 20, 520, 220, (0, 4), (0, 1.2))
    ax.frame(xticks=(0, 1, 2, 3, 4), yticks=(0, 0.5, 1.0), xlabel="distance along the axis *z*/*R*")
    ax.curve(dipole, 0.945, 4, "f-b-line f-dash")
    ax.curve(exact, 0, 4, "f-a-line")
    f.legend(600, 60, [("loop, exact", "f-a-line"), ("dipole law", "f-b-line f-dash")])
    f.text(600, 130, "*B*/*B*_{0} = (1 + *z*^{2}/*R*^{2})^{-3/2}", "f-muted", 12)
    f.text(600, 152, "falls as *R*^{3}/*z*^{3} for *z* ≫ *R*.", "f-muted", 12)
    f.text(600, 174, "*B*_{0} = μ_{0}*I*/2*R* at the centre.", "f-muted", 12)
    return f
