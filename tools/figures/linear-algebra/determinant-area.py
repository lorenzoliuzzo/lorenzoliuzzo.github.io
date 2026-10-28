"""The determinant as the factor by which a map scales area; a singular matrix flattens the square."""
from kit import Fig


def panel(f, ox, oy, s, A, title, note):
    f.text(ox - 10, oy - 140, title, "f-muted", 13)
    f.line(ox - 20, oy, ox + 3.6 * s, oy, "f-grid")
    f.line(ox, oy + 20, ox, oy - 2.6 * s, "f-grid")
    sq = [(0, 0), (1, 0), (1, 1), (0, 1)]
    P = lambda x, y: (ox + x * s, oy - y * s)
    f.poly([P(*p) for p in sq], "f-b-line f-dash", close=True)
    im = [(A[0][0] * x + A[0][1] * y, A[1][0] * x + A[1][1] * y) for x, y in sq]
    f.poly([P(*p) for p in im], "f-a-fill", close=True)
    f.poly([P(*p) for p in im], "f-a-line", close=True)
    f.text(ox - 10, oy + 40, note, "f-muted", 12.5)


def build():
    f = Fig(760, 280)
    A = ((2.0, 1.0), (0.0, 1.5))
    B = ((1.0, 2.0), (0.5, 1.0))
    da = A[0][0] * A[1][1] - A[0][1] * A[1][0]
    db = B[0][0] * B[1][1] - B[0][1] * B[1][0]
    panel(f, 50, 210, 56, A, "*A* = [[2, 1], [0, 1.5]]", f"det *A* = {da:g}: area times {da:g}, orientation kept")
    panel(f, 410, 210, 56, B, "*B* = [[1, 2], [0.5, 1]]", f"det *B* = {db:g}: the square collapses to a segment")
    return f
