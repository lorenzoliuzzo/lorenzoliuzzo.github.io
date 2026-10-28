"""Isotherms of an ideal gas in the p-V plane, with an isothermal and an isochoric step."""
from kit import Fig

K = 1.380649e-23
N = 2.4e22


def p(V, T):
    return N * K * T / V / 1000.0  # kPa, V in m^3


def build():
    f = Fig(760, 300)
    ax = f.axes(70, 20, 470, 220, (0.5, 4.0), (0, 320))
    ax.frame(xticks=(1, 2, 3, 4), yticks=(0, 100, 200, 300), xlabel="volume *V* (L)", ylabel="*p* (kPa)")
    for T, cls in ((300, "f-a-line"), (450, "f-b-line"), (600, "f-c-line")):
        ax.curve(lambda v, T=T: p(v * 1e-3, T), 0.5, 4.0, cls)
    for T, cls, y in ((300, "f-a-line", 3.6), (450, "f-b-line", 3.6), (600, "f-c-line", 3.6)):
        pass
    ax.point(1.0, p(1e-3, 300), 4)
    ax.point(2.0, p(2e-3, 300), 4)
    ax.point(2.0, p(2e-3, 600), 4, "f-b-solid")
    ax.vline(2.0, p(2e-3, 300), p(2e-3, 600))
    f.legend(570, 50, [("*T* = 300 K", "f-a-line"), ("*T* = 450 K", "f-b-line"), ("*T* = 600 K", "f-c-line")])
    f.text(570, 130, "*N* = 2.4×10^{22} molecules.", "f-muted", 12.5)
    f.text(570, 148, f"*p*(1 L, 300 K) = {p(1e-3, 300):.0f} kPa", "f-muted", 12.5)
    f.text(570, 166, f"*p*(2 L, 300 K) = {p(2e-3, 300):.0f} kPa", "f-muted", 12.5)
    f.text(570, 184, f"*p*(2 L, 600 K) = {p(2e-3, 600):.0f} kPa", "f-muted", 12.5)
    return f
