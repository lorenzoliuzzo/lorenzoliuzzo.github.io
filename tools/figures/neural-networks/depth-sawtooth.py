"""Composing a two-unit ReLU tent k times gives 2^k linear pieces from 2k units; one hidden layer with m ReLU units has at most m + 1 pieces."""
from kit import Fig


def relu(z):
    return max(0.0, z)


def tent(x):
    return 2 * relu(x) - 4 * relu(x - 0.5)


def compose(x, k):
    for _ in range(k):
        x = tent(x)
    return x


def build():
    f = Fig(760, 250)
    for j, k in enumerate((1, 2, 3)):
        ax = f.axes(40 + j * 245, 62, 180, 130, (0, 1), (0, 1.05))
        f.text(ax.x0, 26, f"depth {k}", "f-ink", 14, weight=600)
        f.text(ax.x0, 46, f"{2 * k} ReLU units, {2 ** k} pieces", "f-muted", 12.5)
        ax.frame(xticks=(0, 1), yticks=(0, 1), grid=False)
        ax.curve(lambda x: compose(x, k), cls="f-a-line", n=2 ** (k + 4) * 4)
    f.text(40, 236, "A one-hidden-layer ReLU network needs at least 2^{k} − 1 units for the same number of pieces.", "f-muted", 12.5)
    return f
