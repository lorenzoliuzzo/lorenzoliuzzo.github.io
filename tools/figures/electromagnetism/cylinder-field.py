"""Magnetic field of a long straight wire of radius a carrying a uniform current: it grows linearly inside the wire and falls as 1/s outside, with its maximum at the surface s = a."""
from kit import Fig


def B(s):
    return s if s <= 1 else 1 / s


def build():
    f = Fig(760, 290)
    ax = f.axes(52, 20, 520, 220, (0, 4), (0, 1.25))
    ax.frame(xticks=(0, 1, 2, 3, 4), yticks=(0, 0.5, 1), xlabel="distance from the axis *s* / *a*", ylabel="*B* / *B*_{max}")
    ax.curve(B, 0, 1, "f-b-line", 40)
    ax.curve(B, 1, 4, "f-a-line", 200)
    ax.vline(1, 0, 1, "f-line f-dash")
    ax.point(1, 1, 4, "f-a-solid")
    ax.text(0.45, 0.2, "inside: ∝ *s*", "f-b", 12.5)
    ax.text(1.6, 0.8, "outside: ∝ 1/*s*", "f-a", 12.5)
    f.text(600, 70, "Uniform current *I* in a wire of", "f-muted", 12.5)
    f.text(600, 88, "radius *a*:", "f-muted", 12.5)
    f.text(600, 120, "*B* = μ_{0}*I**s* / 2π*a*^{2}  (*s* < *a*)", "f-ink", 12.5)
    f.text(600, 142, "*B* = μ_{0}*I* / 2π*s*  (*s* > *a*)", "f-ink", 12.5)
    f.text(600, 176, "The two pieces agree at *s* = *a*,", "f-muted", 12.5)
    f.text(600, 194, "since only the enclosed current", "f-muted", 12.5)
    f.text(600, 212, "matters.", "f-muted", 12.5)
    return f
