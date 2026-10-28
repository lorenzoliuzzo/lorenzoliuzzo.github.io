"""A flat loop of area A = 0.01 m^2 turning at 50 Hz in a uniform field B = 0.5 T. Flux = B A cos(wt), emf = -dPhi/dt = B A w sin(wt), peak 1.57 V. Time in ms over one period (20 ms)."""
import math
from kit import Fig

B, A, W = 0.5, 0.01, 2 * math.pi * 50
PHI0, EMF0 = B * A, B * A * W


def build():
    f = Fig(760, 300)
    ax = f.axes(52, 20, 480, 232, (0, 20), (-1.15, 1.15))
    ax.frame(xticks=(0, 5, 10, 15, 20), yticks=(-1, 0, 1), xlabel="time (ms)", ylabel="fraction of the peak")
    ax.curve(lambda t: math.cos(W * t * 1e-3), cls="f-b-line")
    ax.curve(lambda t: math.sin(W * t * 1e-3), cls="f-a-line")
    f.legend(560, 50, [("flux  5 mWb × cos ωt", "f-b-line"), ("emf  1.57 V × sin ωt", "f-a-line")])
    f.text(560, 120, "The emf is largest when the flux", "f-muted", 12.5)
    f.text(560, 138, "is zero, because that is when it", "f-muted", 12.5)
    f.text(560, 156, "changes fastest. Flux and emf", "f-muted", 12.5)
    f.text(560, 174, "are a quarter period apart.", "f-muted", 12.5)
    return f
