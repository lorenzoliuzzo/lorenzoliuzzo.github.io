"""One-sided z-test: significance level, type II error and power."""
from kit import Fig
from dist import norm_pdf, norm_cdf


def build():
    delta, crit = 2.2, 1.645
    f = Fig(760, 300)
    ax = f.axes(52, 26, 520, 224, (-3, 6), (0, 0.46))
    ax.frame(xticks=range(-3, 7), yticks=(), xlabel="test statistic", grid=False, yaxis=False)
    alt = lambda x: norm_pdf(x, delta)
    ax.area(alt, crit, 6, "f-b-fill")
    ax.area(alt, -3, crit, "f-a-fill")
    ax.area(norm_pdf, crit, 3.2, "f-a-fill")
    ax.curve(norm_pdf, cls="f-a-line")
    ax.curve(alt, cls="f-b-line")
    ax.vline(crit, 0, 0.44, "f-line f-dash")
    f.text(ax.X(crit), ax.Y(0.44) - 6, "critical value 1.645", "f-muted", 12.5, "middle")
    f.text(ax.X(0), ax.Y(0.40) - 6, "H₀ true", "f-a", 13, "middle", 600)
    f.text(ax.X(delta), ax.Y(0.40) - 6, "H₁ true", "f-b", 13, "middle", 600)
    f.line(ax.X(3.35), ax.Y(0.075), ax.X(2.25), ax.Y(0.013), "f-a-line")
    f.text(ax.X(3.4), ax.Y(0.075), "α", "f-a", 15, "start", 600)
    f.text(ax.X(0.95), ax.Y(0.075), "β", "f-b", 15, "middle", 600)
    f.text(ax.X(2.75), ax.Y(0.14), "power", "f-b", 13, "middle", 600)
    power = 1 - norm_cdf(crit - delta)
    f.text(600, 70, f"α = {1 - norm_cdf(crit):.2f}", "f-a", 13.5, weight=600)
    f.text(600, 92, f"power = {power:.2f}", "f-b", 13.5, weight=600)
    f.text(600, 114, f"β = {1 - power:.2f}", "f-b", 13.5, weight=600)
    f.text(600, 160, "Move the shifted curve right", "f-muted", 12.5)
    f.text(600, 177, "or make it narrower (more", "f-muted", 12.5)
    f.text(600, 194, "data) and power rises with", "f-muted", 12.5)
    f.text(600, 211, "α unchanged.", "f-muted", 12.5)
    return f
