"""With orthonormal predictors, ridge, lasso and best subset are three different functions of the least squares coefficient."""
from kit import Fig

LAM = 1.0


def build():
    f = Fig(760, 300)
    ax = f.axes(60, 20, 330, 232, (-4, 4), (-4, 4))
    ax.frame(xticks=(-4, -2, 0, 2, 4), yticks=(-4, -2, 0, 2, 4), xlabel="least squares coefficient", ylabel="penalised estimate")
    ax.curve(lambda x: x, -4, 4, "f-line f-dash", n=2)
    ax.curve(lambda x: x / (1 + LAM), -4, 4, "f-a-line", n=2)
    soft = lambda x: max(abs(x) - LAM, 0) * (1 if x > 0 else -1)
    ax.curve(soft, -4, 4, "f-b-line", n=400)
    t = (2 * LAM) ** 0.5
    for sgn in (-1, 1):
        ax.curve(lambda x, s=sgn: x, sgn * t, sgn * 4, "f-d-line", n=2)
    ax.curve(lambda x: 0, -t, t, "f-d-line", n=2)
    f.legend(430, 60, [("least squares", "f-line f-dash"), ("ridge", "f-a-line"), ("lasso", "f-b-line"), ("best subset", "f-d-line")])
    for i, line in enumerate(("Ridge shrinks every coefficient by", "the same factor and never reaches", "zero. Lasso subtracts a constant and", "sets small ones to zero. Best subset", "keeps or drops, with no shrinkage.")):
        f.text(430, 170 + 19 * i, line, "f-muted", 12.5)
    return f
