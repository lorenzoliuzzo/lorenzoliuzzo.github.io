"""A droplet of flipped spins in an ordered 2D Ising lattice: the energy cost is proportional to the length of its boundary."""
from kit import Fig

W, H = 14, 9
DROP = {(r, c) for r in range(2, 7) for c in range(4, 10)} - {(2, 4), (6, 9), (2, 9)} | {(7, 6), (7, 7)}


def build():
    f = Fig(760, 300)
    x0, y0, s = 40, 20, 30
    for r in range(H):
        for c in range(W):
            x, y = x0 + c * s, y0 + r * s
            inside = (r, c) in DROP
            f.rect(x, y, s, s, "f-a-fill f-grid" if inside else "f-grid")
            f.text(x + s / 2, y + s / 2 + 5, "−" if inside else "+", "f-ink" if inside else "f-faint", 13, "middle")
    n = 0
    for r in range(H):
        for c in range(W):
            a = (r, c) in DROP
            if c + 1 < W and a != ((r, c + 1) in DROP):
                f.line(x0 + (c + 1) * s, y0 + r * s, x0 + (c + 1) * s, y0 + (r + 1) * s, "f-b-line")
                n += 1
            if r + 1 < H and a != ((r + 1, c) in DROP):
                f.line(x0 + c * s, y0 + (r + 1) * s, x0 + (c + 1) * s, y0 + (r + 1) * s, "f-b-line")
                n += 1
    f.text(500, 60, "Orange: the domain wall.", "f-ink", 13)
    f.text(500, 90, f"Length ℓ = {n} bonds,", "f-muted", 13)
    f.text(500, 110, f"energy cost ΔE = 2Jℓ = {2 * n} J.", "f-muted", 13)
    f.text(500, 150, "A boundary of length ℓ can", "f-muted", 13)
    f.text(500, 170, "be drawn in at most 3^ℓ ways,", "f-muted", 13)
    f.text(500, 190, "which bounds the entropy.", "f-muted", 13)
    return f
