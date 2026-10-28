"""Pressure of a fixed volume of gas against temperature, for three amounts, all extrapolating to one zero."""
from kit import Fig

K = 1.380649e-23
V = 1.0e-3  # m^3


def build():
    f = Fig(760, 300)
    ax = f.axes(70, 20, 470, 220, (-300, 100), (0, 160))
    ax.frame(xticks=(-273.15, -200, -100, 0, 100), yticks=(0, 40, 80, 120, 160), xlabel="temperature *t* (°C)", ylabel="*p* (kPa)", xfmt=lambda v: f"{v:.2f}".rstrip("0").rstrip(".").replace("-", "−"))
    for n, cls in ((1.0, "f-a-line"), (0.6, "f-b-line"), (0.3, "f-c-line")):
        # N = n * 2.4e22 molecules in 1 litre: p in kPa
        N = n * 2.4e22
        fn = lambda t, N=N: N * K * (t + 273.15) / V / 1000.0
        ax.curve(fn, -273.15, 100, cls, 2)
        ax.curve(fn, -300 if False else -273.15, -150, cls + " f-dash", 2) if False else None
    ax.vline(-273.15, 0, 160)
    ax.point(-273.15, 0, 4)
    f.legend(570, 50, [("*N* = 2.4×10^{22}", "f-a-line"), ("*N* = 1.4×10^{22}", "f-b-line"), ("*N* = 0.7×10^{22}", "f-c-line")])
    f.text(570, 130, "*V* = 1 L. Different amounts,", "f-muted", 12.5)
    f.text(570, 148, "one intercept: −273.15 °C.", "f-muted", 12.5)
    f.text(570, 166, "same *T* = 0 at *p* = 0.", "f-muted", 12.5)
    return f
