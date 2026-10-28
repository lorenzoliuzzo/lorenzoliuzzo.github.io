"""Geometry of the free energy F = U - T S: the tangent to U(S) with slope T meets the vertical axis at F, so F(T) records U(S) as a family of tangent lines."""
from kit import Fig


def U(s):
    return 0.35 + 0.5 * s * s


def build():
    f = Fig(760, 300)
    ax = f.axes(60, 20, 460, 236, (0, 3), (-1.3, 4.4))
    ax.frame(xticks=(0, 1, 2, 3), yticks=(-1, 0, 1, 2, 3, 4), xlabel="entropy *S*")
    ax.curve(U, 0, 2.95, "f-a-line")
    for s0, cls in ((1.0, "f-c-line f-dash"), (2.0, "f-b-line")):
        ax.curve(lambda s, s0=s0: U(s0) + s0 * (s - s0), 0, 3, cls)
        ax.point(s0, U(s0), 4, "f-b-solid" if s0 == 2.0 else "f-c-solid")
    s0 = 2.0
    ax.point(0, U(s0) - s0 * s0, 4.5, "f-b-solid")
    f.text(ax.X(0.12), ax.Y(U(s0) - s0 * s0) + 5, "*F* = *U* − *TS*", "f-b", 12.5)
    f.text(ax.X(2.1), ax.Y(U(2.95)) + 12, "*U*(*S*)", "f-a", 13)
    f.legend(560, 60, [("*U*(*S*)", "f-a-line"), ("tangent, slope *T* = 2", "f-b-line"), ("tangent, slope *T* = 1", "f-c-line f-dash")])
    f.text(560, 150, "The intercept of the tangent", "f-muted", 12.5)
    f.text(560, 168, "is the free energy, a function", "f-muted", 12.5)
    f.text(560, 186, "of the slope *T* instead of *S*.", "f-muted", 12.5)
    return f
