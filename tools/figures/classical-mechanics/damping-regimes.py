"""Displacement of a damped oscillator released from rest at x = 1 (omega_0 = 1): underdamped (gamma = 0.4), critically damped (gamma = 2) and overdamped (gamma = 4)."""
import math
from kit import Fig


def under(g):
    wd = math.sqrt(1 - g * g / 4)
    return lambda t: math.exp(-g * t / 2) * (math.cos(wd * t) + g / (2 * wd) * math.sin(wd * t))


def critical(g):
    return lambda t: math.exp(-g * t / 2) * (1 + g * t / 2)


def over(g):
    r = math.sqrt(g * g / 4 - 1)
    lp, lm = -g / 2 + r, -g / 2 - r
    return lambda t: (lp * math.exp(lm * t) - lm * math.exp(lp * t)) / (lp - lm)


def build():
    f = Fig(760, 290)
    ax = f.axes(52, 20, 520, 220, (0, 16), (-0.7, 1.1))
    ax.frame(xticks=(0, 4, 8, 12, 16), yticks=(-0.5, 0, 0.5, 1), xlabel="time *t* (in units of 1/ω_{0})")
    ax.curve(under(0.4), 0, 16, "f-a-line", 400)
    ax.curve(critical(2.0), 0, 16, "f-c-line", 200)
    ax.curve(over(4.0), 0, 16, "f-b-line", 200)
    f.legend(600, 60, [("underdamped, γ = 0.4", "f-a-line"), ("critical, γ = 2", "f-c-line"), ("overdamped, γ = 4", "f-b-line")])
    f.text(600, 150, "Critical damping returns", "f-muted", 12.5)
    f.text(600, 168, "fastest without crossing zero;", "f-muted", 12.5)
    f.text(600, 186, "more damping is slower.", "f-muted", 12.5)
    return f
