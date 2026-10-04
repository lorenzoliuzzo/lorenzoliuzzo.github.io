"""Least squares as a projection: the fitted values are the foot of the perpendicular from y to the span of the columns of X."""
import math
from kit import Fig


def build():
    f = Fig(760, 300)
    P = [(70, 262), (400, 262), (520, 168), (190, 168)]
    f.poly(P, "f-a-fill", close=True)
    f.poly(P, "f-axis", close=True)
    O, yh, y = (150, 236), (340, 214), (340, 82)
    f.arrow(*O, *yh, "f-a-line")
    f.arrow(*O, *y, "f-line")
    f.arrow(yh[0], yh[1] - 2, y[0], y[1] + 3, "f-b-line f-dash")
    # right-angle mark at the foot
    ux, uy = O[0] - yh[0], O[1] - yh[1]
    n = math.hypot(ux, uy)
    ux, uy = 13 * ux / n, 13 * uy / n
    vx, vy = 0, -13
    f.poly([(yh[0] + ux, yh[1] + uy), (yh[0] + ux + vx, yh[1] + uy + vy), (yh[0] + vx, yh[1] + vy)], "f-axis")
    f.circle(*O, 3.2, "f-ink")
    f.circle(*yh, 4, "f-a-solid")
    f.circle(*y, 4, "f-ink")
    f.text(y[0] + 10, y[1] + 4, "y", "f-ink", 15, weight=600)
    f.text(yh[0] + 10, yh[1] + 20, "ŷ = Hy", "f-a", 14, weight=600)
    f.text(yh[0] + 12, 150, "e = y − ŷ", "f-b", 14, weight=600)
    f.text(O[0] - 12, O[1] + 16, "0", "f-muted", 13)
    f.text(404, 252, "span of the columns of X", "f-muted", 12.5, "end")
    for i, line in enumerate(("The fit is the point of the plane", "closest to y, so the residual is", "perpendicular to every column of X:", "Xᵀe = 0. These are the normal", "equations, and the coordinates of ŷ", "in the columns are the coefficients.")):
        f.text(556, 92 + 19 * i, line, "f-muted", 12.5)
    return f
