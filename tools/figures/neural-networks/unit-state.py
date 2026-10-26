"""A unit computes three numbers in sequence: net input, activation, output. Each architecture in the course changes one of the three functions."""
from kit import Fig


def build():
    f = Fig(760, 250)
    y0, h = 70, 64
    ym = y0 + h / 2
    f.text(36, 26, "what one unit u does with the outputs of its predecessors", "f-ink", 13, weight=600)

    for i, (y, name) in enumerate([(62, "out_{v1}"), (102, "out_{v2}"), (142, "out_{v3}")]):
        f.circle(84, y + 10, 9, "f-c-fill")
        f.circle(84, y + 10, 9, "f-c-line")
        f.text(68, y + 15, name, "f-ink", 12, "end")
        f.arrow(95, y + 10, 128, ym + (i - 1) * 12, "f-line")
    f.text(112, 192, "weights w_{uv}", "f-muted", 12, "middle")

    boxes = [(130, "f_{net}", "weighted sum", "net_{u}"),
             (310, "f_{act}", "step or sigmoid", "act_{u}"),
             (490, "f_{out}", "identity", "out_{u}")]
    for x, fn, example, state in boxes:
        f.rect(x, y0, 110, h, "f-a-fill")
        f.rect(x, y0, 110, h, "f-a-line")
        f.text(x + 55, y0 + 30, fn, "f-ink", 15, "middle", 600)
        f.text(x + 55, y0 + 50, example, "f-muted", 12, "middle")
        f.arrow(x + 112, ym, x + 176, ym, "f-line")
        f.text(x + 144, ym - 10, state, "f-ink", 13, "middle")
    f.arrow(662, ym, 716, ym, "f-line")
    f.circle(728, ym, 11, "f-c-fill")
    f.circle(728, ym, 11, "f-c-line")
    f.text(728, ym + 30, "successors", "f-muted", 12, "middle")

    f.text(36, 232, "The threshold unit of the next note is the case in the boxes: weighted sum, then a step at the threshold θ_{u}, then the identity.", "f-muted", 12.5)
    return f
