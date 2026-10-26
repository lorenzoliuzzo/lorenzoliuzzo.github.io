"""A single hidden layer of steep logistic units reproduces a continuous function as a staircase; more units shrink the error."""
import math

from kit import Fig


def target(x):
    return 0.5 + 0.35 * math.sin(2 * math.pi * x) + 0.1 * x


def logistic(z):
    return 1 / (1 + math.exp(-max(-60.0, min(60.0, z))))


def network(n):
    """Hidden unit i switches at the midpoint s_i of two nodes with output weight f(t_i) - f(t_{i-1}); the slope k makes each step sharp."""
    nodes = [i / n for i in range(n + 1)]
    switches = [(nodes[i - 1] + nodes[i]) / 2 for i in range(1, n + 1)]
    jumps = [target(nodes[i]) - target(nodes[i - 1]) for i in range(1, n + 1)]
    k = 12 * n

    def out(x):
        return target(0) + sum(d * logistic(k * (x - s)) for d, s in zip(jumps, switches))

    return out, switches


def build():
    f = Fig(760, 300)
    for j, n in enumerate((6, 24)):
        out, switches = network(n)
        ax = f.axes(50 + j * 370, 46, 300, 190, (0, 1), (0, 1))
        err = max(abs(out(i / 400) - target(i / 400)) for i in range(401))
        f.text(ax.x0, 26, f"{n} hidden units", "f-ink", 14, weight=600)
        ax.frame(xticks=(0, 0.5, 1), yticks=(0, 0.5, 1), grid=False)
        for s in switches:
            ax.vline(s, 0, 0.06, "f-line f-dash")
        ax.curve(target, cls="f-c-line")
        ax.curve(out, cls="f-a-line", n=500)
        ax.text(0.97, 0.14, f"largest error {err:.2f}", "f-muted", 12.5, "end")
    f.text(50, 284, "Green: the function. Blue: the network output. Dashes at the bottom mark where each hidden unit switches.", "f-muted", 12.5)
    return f
