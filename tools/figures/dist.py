"""Densities and mass functions for the figure scripts. Standard library only."""
import math


def norm_pdf(x, mu=0.0, s=1.0):
    return math.exp(-0.5 * ((x - mu) / s) ** 2) / (s * math.sqrt(2 * math.pi))


def norm_cdf(x):
    return 0.5 * (1 + math.erf(x / math.sqrt(2)))


def t_pdf(x, v):
    c = math.gamma((v + 1) / 2) / (math.sqrt(v * math.pi) * math.gamma(v / 2))
    return c * (1 + x * x / v) ** (-(v + 1) / 2)


def gamma_pdf(x, k, rate):
    if x <= 0:
        return 0.0
    return rate ** k * x ** (k - 1) * math.exp(-rate * x) / math.gamma(k)


def binom_pmf(k, n, p):
    return math.comb(n, k) * p ** k * (1 - p) ** (n - k)


def pois_pmf(k, lam):
    return math.exp(-lam) * lam ** k / math.factorial(k)
