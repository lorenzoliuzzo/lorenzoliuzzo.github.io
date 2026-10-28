"""Three paths between the same two states of an ideal gas do different work but share the same energy change."""
import math
from kit import Fig

K = 1.380649e-23
N = 2.4e22
T = 300.0


def p(V):
    return N * K * T / V / 1000.0


def build():
    f = Fig(760, 300)
    ax = f.axes(70, 20, 470, 230, (0.5, 2.5), (0, 140))
    ax.frame(xticks=(1, 1.5, 2), yticks=(0, 50, 100), xlabel="volume *V* (L)", ylabel="*p* (kPa)")
    pa, pb = p(1e-3), p(2e-3)
    ax.area(lambda v: p(v * 1e-3), 1.0, 2.0, "f-a-fill")
    ax.curve(lambda v: p(v * 1e-3), 0.6, 2.4, "f-a-line")
    ax.curve(lambda v: pa, 1.0, 2.0, "f-b-line", 2)
    ax.vline(2.0, pa, pb, "f-b-line")
    ax.vline(1.0, pb, pa, "f-c-line")
    ax.curve(lambda v: pb, 1.0, 2.0, "f-c-line", 2)
    ax.point(1.0, pa, 4)
    ax.point(2.0, pb, 4)
    W1 = N * K * T * math.log(2)
    W2 = pb * 1.0
    W3 = pa * 1.0
    f.legend(570, 50, [(f"isothermal: *W* = {W1:.1f} J", "f-a-line"), (f"isobaric first: *W* = {W3:.1f} J", "f-b-line"), (f"isochoric first: *W* = {W2:.1f} J", "f-c-line")])
    f.text(570, 130, "Same end states, same *T*,", "f-muted", 12.5)
    f.text(570, 148, "so the same *U*; *Q* = *W*", "f-muted", 12.5)
    f.text(570, 166, "differs with the path.", "f-muted", 12.5)
    return f
