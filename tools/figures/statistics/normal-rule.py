"""68-95-99.7 rule on the standard normal."""
from kit import Fig
from dist import norm_pdf


def build():
    f = Fig(380, 250)
    ax = f.axes(14, 12, 352, 140, (-3.6, 3.6), (0, 0.42))
    ax.frame(xticks=range(-3, 4), yticks=(), grid=False, yaxis=False)
    for k in (3, 2, 1):
        ax.area(norm_pdf, -k, k, "f-a-fill")
    ax.curve(norm_pdf, cls="f-a-line")
    # Brackets under the axis: how much of the mass lies within k standard deviations.
    for i, (k, label) in enumerate(((1, "68%"), (2, "95%"), (3, "99.7%"))):
        y = 192 + i * 16
        f.line(ax.X(-k), y, ax.X(k), y, "f-a-line")
        f.line(ax.X(-k), y - 4, ax.X(-k), y + 4, "f-a-line")
        f.line(ax.X(k), y - 4, ax.X(k), y + 4, "f-a-line")
        f.text(ax.X(k) + 8, y + 4, label, "f-ink", 12.5, weight=600)
    f.text(14, 242, "within k standard deviations of the mean", "f-muted", 11.5)
    return f
