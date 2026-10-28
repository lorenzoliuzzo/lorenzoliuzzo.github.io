"""Speed of a falling body with and without linear drag, approaching the terminal speed mg/b."""
import math
from kit import Fig

M, G, B = 1.0, 9.81, 1.0


def build():
    vt, tau = M * G / B, M / B
    f = Fig(760, 300)
    ax = f.axes(60, 20, 480, 220, (0, 4), (0, 25))
    ax.frame(xticks=(0, 1, 2, 3, 4), yticks=(0, 5, 10, 15, 20, 25), xlabel="time *t* (s)", ylabel="*v* (m/s)")
    ax.curve(lambda t: G * t, 0, 2.5, "f-b-line")
    ax.curve(lambda t: vt * (1 - math.exp(-t / tau)), 0, 4, "f-a-line")
    f.line(ax.X(0), ax.Y(vt), ax.X(4), ax.Y(vt), "f-line f-dash")
    ax.point(tau, vt * (1 - math.exp(-1)), 4)
    f.legend(570, 50, [("no drag, *v* = *gt*", "f-b-line"), ("linear drag −*bv*", "f-a-line")])
    f.text(570, 120, "*m* = 1 kg, *b* = 1 kg/s", "f-muted", 12.5)
    f.text(570, 138, f"*v*_{{t}} = *mg*/*b* = {vt:.2f} m/s", "f-muted", 12.5)
    f.text(570, 156, f"*v*(τ) = {vt*(1-math.exp(-1)):.2f} m/s", "f-muted", 12.5)
    return f
