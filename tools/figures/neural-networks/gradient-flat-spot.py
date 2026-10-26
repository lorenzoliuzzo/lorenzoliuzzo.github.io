"""A logistic unit started in its saturated region barely moves under plain gradient descent; momentum and Rprop leave the flat spot sooner."""
import math

from kit import Fig

T = 60


def logistic(z):
    return 1 / (1 + math.exp(-max(-50.0, min(50.0, z))))


def error(w):
    return logistic(w) ** 2


def grad(w):
    s = logistic(w)
    return 2 * s * s * (1 - s)


def plain(eta=1.0, w=4.0):
    out = [error(w)]
    for _ in range(T):
        w -= eta * grad(w)
        out.append(error(w))
    return out


def momentum(eta=1.0, beta=0.9, w=4.0):
    out, d = [error(w)], 0.0
    for _ in range(T):
        d = -eta * grad(w) + beta * d
        w += d
        out.append(error(w))
    return out


def rprop(step=0.1, w=4.0, up=1.2, down=0.5):
    """Step size per weight, grown while the gradient keeps its sign and halved when it flips; only the sign of the gradient is used."""
    out, prev = [error(w)], 0.0
    for _ in range(T):
        g = grad(w)
        if g * prev > 0:
            step = min(step * up, 50.0)
        elif g * prev < 0:
            step = max(step * down, 1e-6)
        w -= math.copysign(step, g) if g else 0.0
        prev = g
        out.append(error(w))
    return out


def build():
    f = Fig(760, 290)
    ax = f.axes(60, 26, 480, 210, (0, T), (-8, 0))
    ax.frame(xticks=range(0, T + 1, 10), yticks=range(-8, 1, 2), xlabel="iteration", ylabel="log₁₀ error", yfmt=lambda v: f"{v:g}")
    runs = [("plain, η = 1", plain(), "f-a-line"), ("momentum, β = 0.9", momentum(), "f-d-line"), ("Rprop", rprop(), "f-e-line")]
    for _, series, cls in runs:
        f.poly([(ax.X(i), ax.Y(max(-8, math.log10(max(v, 1e-30))))) for i, v in enumerate(series)], cls)
    f.legend(570, 80, [(n, c) for n, _, c in runs])
    f.text(570, 150, "One weight, error e = σ(w)²,", "f-muted", 12.5)
    f.text(570, 168, "started at w = 4 where the", "f-muted", 12.5)
    f.text(570, 186, "logistic function is flat.", "f-muted", 12.5)
    return f
