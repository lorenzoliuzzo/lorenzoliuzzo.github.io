"""Maxwell-Boltzmann speed distributions of nitrogen at three temperatures."""
import math
from kit import Fig

K = 1.380649e-23
M = 28.0134 * 1.66053907e-27


def f_(v, T):
    a = M / (2 * math.pi * K * T)
    return 4 * math.pi * a ** 1.5 * v * v * math.exp(-M * v * v / (2 * K * T))


def build():
    f = Fig(760, 300)
    ax = f.axes(70, 20, 470, 230, (0, 2000), (0, 0.0030))
    ax.frame(xticks=(0, 500, 1000, 1500, 2000), yticks=(0, 0.001, 0.002, 0.003), xlabel="speed *v* (m/s)", ylabel="density (10^{−3} s/m)", yfmt=lambda v: f"{v*1000:.0f}")
    for T, cls in ((300, "f-a-line"), (600, "f-b-line"), (1200, "f-c-line")):
        ax.curve(lambda v, T=T: f_(v, T), 0, 2000, cls)
    T = 300
    vmp = math.sqrt(2 * K * T / M)
    vmean = math.sqrt(8 * K * T / (math.pi * M))
    vrms = math.sqrt(3 * K * T / M)
    ax.vline(vmp, 0, f_(vmp, 300))
    f.legend(570, 50, [("N_{2} at 300 K", "f-a-line"), ("600 K", "f-b-line"), ("1200 K", "f-c-line")])
    f.text(570, 130, "At 300 K (dashed line = peak):", "f-muted", 12.5)
    f.text(570, 148, f"*v*_{{mp}} = {vmp:.0f} m/s", "f-muted", 12.5)
    f.text(570, 166, f"⟨*v*⟩ = {vmean:.0f} m/s", "f-muted", 12.5)
    f.text(570, 184, f"*v*_{{rms}} = {vrms:.0f} m/s", "f-muted", 12.5)
    return f
