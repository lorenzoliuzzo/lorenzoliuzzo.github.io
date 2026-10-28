"""A recurrent network unrolled over five steps: the same weights at every step, and a gradient that returns through a product of Jacobians."""
from kit import Fig

N = 5
X0, DXs = 90, 132
BOX_W, BOX_H = 74, 44
Y = 128


def build():
    f = Fig(760, 300)
    for t in range(N):
        x = X0 + t * DXs
        f.rect(x - BOX_W / 2, Y - BOX_H / 2, BOX_W, BOX_H, "f-box", rx=6)
        f.text(x, Y + 5, f"h_{{{t + 1}}}", "f-ink", 15, "middle")
        f.arrow(x, Y + 74, x, Y + BOX_H / 2 + 2, "f-line")
        f.text(x, Y + 94, f"x_{{{t + 1}}}", "f-muted", 14, "middle")
        f.arrow(x, Y - BOX_H / 2 - 2, x, Y - 70, "f-line")
        f.text(x, Y - 76, f"ŷ_{{{t + 1}}}", "f-muted", 14, "middle")
        if t < N - 1:
            f.arrow(x + BOX_W / 2 + 2, Y - 8, x + DXs - BOX_W / 2 - 2, Y - 8, "f-a-line")
            f.text(x + DXs / 2, Y - 14, "W_h", "f-a", 12.5, "middle")
            f.arrow(x + DXs - BOX_W / 2 - 2, Y + 12, x + BOX_W / 2 + 2, Y + 12, "f-b-line f-dash")
    f.text(X0 - 40, 22, "forward: the same W_h, W_x, W_y at every step", "f-a", 13)
    f.text(X0 - 40, 262, "backward: the gradient from step T to step k is a product of T - k Jacobians,", "f-b", 13)
    f.text(X0 - 40, 282, "so it shrinks or grows like a power. Gated units keep a path with factor near 1.", "f-b", 13)
    return f
