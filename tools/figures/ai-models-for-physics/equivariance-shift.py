"""A convolution commutes with a shift of its input; a global sum after it does not see the shift."""
from kit import Fig

K = (1.0, 2.0, 1.0)
N = 12


def conv(x):
    return [sum(K[j] * x[(i + j - 1) % N] for j in range(3)) for i in range(N)]


def row(f, x0, y0, vals, cls, label, cell=34):
    f.text(x0 - 12, y0 + 22, label, "f-muted", 12.5, "end")
    for i, v in enumerate(vals):
        f.rect(x0 + i * cell, y0, cell, 30, "f-a-fill f-line" if v > 0 else "f-line")
        if v > 0:
            f.text(x0 + i * cell + cell / 2, y0 + 20, f"{v:g}", "f-ink", 12, "middle")


def build():
    f = Fig(760, 290)
    x = [0.0] * N
    x[2] = 1.0
    x[3] = 1.0
    xs = x[4:] + x[:4]
    yo, ys = conv(x), conv(xs)
    row(f, 120, 24, x, "", "input x")
    row(f, 120, 64, yo, "", "conv(x)")
    row(f, 120, 124, xs, "", "shifted x")
    row(f, 120, 164, ys, "", "conv(shifted)")
    f.text(120 + N * 34 + 20, 84, "same pattern,", "f-muted", 12.5)
    f.text(120 + N * 34 + 20, 102, "moved with the input", "f-muted", 12.5)
    f.text(120 + N * 34 + 20, 184, f"sum: {sum(yo):g} and {sum(ys):g}", "f-ink", 12.5)
    f.text(120 + N * 34 + 20, 202, "(invariant)", "f-muted", 12.5)
    f.text(120, 240, "Kernel (1, 2, 1), periodic boundary, shift by 4 sites.", "f-muted", 12.5)
    return f
