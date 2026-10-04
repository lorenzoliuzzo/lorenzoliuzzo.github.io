"""Scale-normalized response of a second-derivative-of-Gaussian detector at the centre of a bar: it peaks when σ equals the bar's half-width, at the same height for any size."""
import math
from kit import Fig


def response(h, s):
    # |sigma^2 * (G'' * bar)(0)| for a bar of half-width h, in closed form: 2h G(h; sigma)
    return 2 * h * math.exp(-h * h / (2 * s * s)) / (s * math.sqrt(2 * math.pi))


def build():
    f = Fig(760, 300)
    ax = f.axes(60, 24, 470, 228, (0.5, 24), (0, 0.6))
    ax.frame(xticks=(2, 4, 8, 12, 16, 20, 24), yticks=(0, 0.2, 0.4, 0.6), xlabel="scale σ of the detector", ylabel="response")
    for h, cls, solid, tag in ((4, "f-a-line", "f-a-solid", "narrow bar"), (12, "f-b-line", "f-b-solid", "wide bar")):
        ax.curve(lambda s, h=h: response(h, s), cls=cls)
        ax.vline(h, 0, response(h, h), "f-line f-dash")
        ax.point(h, response(h, h), 4.5, solid)
    f.legend(572, 70, [("bar of half-width 4", "f-a-line"), ("bar of half-width 12", "f-b-line")])
    f.text(572, 120, "Each curve peaks when σ equals", "f-muted", 12.5)
    f.text(572, 137, "the half-width, and both peaks", "f-muted", 12.5)
    f.text(572, 154, f"have the same height ({response(4, 4):.2f}), so", "f-muted", 12.5)
    f.text(572, 171, "the best σ reads off the size.", "f-muted", 12.5)
    return f
