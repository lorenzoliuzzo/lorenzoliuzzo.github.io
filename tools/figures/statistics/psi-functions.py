"""What a residual costs (left) and how hard it pulls (right) under squared error, Huber and Tukey's biweight."""
from kit import Fig

K, C = 1.345, 4.685


def sq(u):
    return 0.5 * u * u


def hub(u):
    return 0.5 * u * u if abs(u) <= K else K * abs(u) - 0.5 * K * K


def tuk(u):
    return C * C / 6 * (1 - (1 - (u / C) ** 2) ** 3) if abs(u) <= C else C * C / 6


def psi_hub(u):
    return max(-K, min(K, u))


def psi_tuk(u):
    return u * (1 - (u / C) ** 2) ** 2 if abs(u) <= C else 0.0


def build():
    f = Fig(760, 292)
    R = 4.8
    ax = f.axes(52, 34, 280, 206, (-R, R), (0, 12))
    ax.frame(xticks=(-4, -2, 0, 2, 4), yticks=(0, 4, 8, 12), xlabel="residual u")
    ax.curve(sq, cls="f-b-line")
    ax.curve(hub, cls="f-a-line")
    ax.curve(tuk, cls="f-d-line")
    f.text(52, 22, "loss ρ(u): what a residual costs", "f-ink", 13.5, weight=600)
    f.text(ax.X(R) + 6, ax.Y(sq(R)) + 4, "squared", "f-b", 13, "start", 600)
    f.text(ax.X(R) + 6, ax.Y(hub(R)) + 4, "Huber", "f-a", 13, "start", 600)
    f.text(ax.X(R) + 6, ax.Y(tuk(R)) + 4, "biweight", "f-d", 13, "start", 600)
    bx = f.axes(420, 34, 280, 206, (-R, R), (-5, 5))
    bx.frame(xticks=(-4, -2, 0, 2, 4), yticks=(-4, 0, 4), xlabel="residual u")
    bx.curve(lambda u: u, cls="f-b-line", n=2)
    bx.curve(psi_hub, cls="f-a-line", n=300)
    bx.curve(psi_tuk, cls="f-d-line", n=300)
    f.text(420, 22, "ψ(u) = ρ′(u): how hard it pulls", "f-ink", 13.5, weight=600)
    f.text(bx.X(R) + 6, bx.Y(R) + 4, "squared", "f-b", 13, "start", 600)
    f.text(bx.X(R) + 6, bx.Y(K) + 4, "Huber", "f-a", 13, "start", 600)
    f.text(bx.X(R) + 6, bx.Y(0) + 4, "biweight", "f-d", 13, "start", 600)
    return f
