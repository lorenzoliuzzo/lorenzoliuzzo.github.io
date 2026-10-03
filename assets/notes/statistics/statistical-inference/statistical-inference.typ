// Technical reference for the note `_notes/statistics/statistical-inference.md`.
// The site page explains; this document states the results precisely and proves
// the ones an exam is likely to ask for.

#set document(title: "Statistical Inference: technical reference", author: "Lorenzo Liuzzo")
#set page(paper: "a4", margin: (x: 2.2cm, y: 2.4cm), numbering: "1")
#set text(size: 10.5pt, lang: "en")
#set par(justify: true, leading: 0.62em)
#set heading(numbering: "1.1")
#show heading.where(level: 1): set block(above: 1.6em, below: 0.9em)
#show heading.where(level: 2): set block(above: 1.2em, below: 0.7em)
#set math.equation(numbering: "(1)")
#show link: set text(fill: rgb("#1f4e8c"))

#let EE = math.op("E")
#let PP = math.op("P")
#let Var = math.op("Var")
#let Cov = math.op("Cov")
#let MSE = math.op("MSE")
#let bias = math.op("bias")
#let se = math.op("se")
#let argmax = math.op("arg max", limits: true)
#let iid = $"i.i.d."$
#let cd = $->^d$
#let cp = $->^P$

#let box-env(kind, title, body, fill, stroke) = block(
  width: 100%, inset: (x: 10pt, y: 8pt), radius: 3pt, breakable: true,
  fill: fill, stroke: (left: 2pt + stroke),
)[
  #text(weight: "bold", fill: stroke)[#kind]#if title != none [ #text(weight: "bold")[(#title)]]. #body
]
#let definition(title: none, body) = box-env("Definition", title, body, rgb("#f3f6fb"), rgb("#1f4e8c"))
#let theorem(title: none, body) = box-env("Theorem", title, body, rgb("#f6f1fa"), rgb("#6a3d9a"))
#let lemma(title: none, body) = box-env("Lemma", title, body, rgb("#f6f1fa"), rgb("#6a3d9a"))
#let example(title: none, body) = box-env("Example", title, body, rgb("#f4f8f2"), rgb("#2e7d32"))
#let proof(body) = block(inset: (left: 10pt), breakable: true)[
  #emph[Proof.] #body #h(1fr) $square$
]
#let remark(body) = block(inset: (left: 10pt), breakable: true)[#emph[Remark.] #body]

#align(center)[
  #text(size: 19pt, weight: "bold")[Statistical Inference] \
  #v(2pt)
  #text(size: 12pt)[Technical reference] \
  #v(2pt)
  #text(size: 9.5pt, fill: gray)[Companion to the note on lorenzoliuzzo.github.io. Statements, conditions and proofs. Probability background is in the Probability Foundations reference.]
]
#v(6pt)

#outline(indent: 1.2em, depth: 2)

This chapter uses the probability background (axioms, expectation and variance rules, limit theorems, Slutsky) from the Probability Foundations reference and the sampling distributions of the mean and variance, the $chi^2$, $t$ and $F$ laws, from the Sampling Distributions reference. Both are quoted without proof.

= Point estimation

Let $X_1, dots, X_n tilde.op f(dot; theta)$, $theta in Theta subset RR$, and $hat(theta) = T(X_1, dots, X_n)$.

#definition[
  $bias(hat(theta)) = EE_theta [hat(theta)] - theta$. The estimator is unbiased if this vanishes for all $theta$. It is consistent if $hat(theta)_n cp theta$. Its mean squared error is $MSE(hat(theta)) = EE_theta[(hat(theta) - theta)^2]$.
]

#theorem(title: "Bias–variance decomposition")[
  $ MSE(hat(theta)) = Var_theta (hat(theta)) + bias(hat(theta))^2. $
]
#proof[
  Add and subtract $EE hat(theta)$: $(hat(theta) - theta)^2 = (hat(theta) - EE hat(theta))^2 + 2 (hat(theta) - EE hat(theta))(EE hat(theta) - theta) + (EE hat(theta) - theta)^2$. The cross term has zero expectation because $EE hat(theta) - theta$ is a constant and $EE[hat(theta) - EE hat(theta)] = 0$.
]

#example(title: "A biased estimator with smaller MSE")[
  For $X_i tilde.op cal(N)(mu, sigma^2)$, the estimator $hat(sigma)^2_c = c sum_i (X_i - overline(X))^2$ has, using $sum_i (X_i - overline(X))^2 tilde.op sigma^2 chi^2_(n-1)$ (mean $(n-1) sigma^2$, variance $2(n-1) sigma^4$),
  $ MSE = sigma^4 [ 2 c^2 (n-1) + ((n-1) c - 1)^2 ]. $
  This is minimized at $c = 1 slash (n+1)$, not at the unbiased choice $c = 1 slash (n-1)$. The unbiased estimator is therefore not MSE-optimal, a first instance of the shrinkage idea behind Ridge and Lasso.
]

== Fisher information and the Cramér–Rao bound

Assume the regularity conditions: the support of $f(dot; theta)$ does not depend on $theta$, $log f$ is twice differentiable in $theta$, and differentiation under the integral sign is allowed.

#definition(title: "Score and Fisher information")[
  The score of one observation is $s(x; theta) = partial_theta log f(x; theta)$, and
  $ I(theta) = EE_theta [ s(X; theta)^2 ] = Var_theta (s(X; theta)). $
]

#lemma[
  Under the regularity conditions, $EE_theta [s(X; theta)] = 0$ and $I(theta) = -EE_theta [partial_theta^2 log f(X; theta)]$. For $n$ independent observations the information is $n I(theta)$.
]
#proof[
  $EE[s] = integral (partial_theta f slash f) f dif x = partial_theta integral f dif x = partial_theta 1 = 0$. Differentiating $integral s thin f dif x = 0$ once more gives $integral (partial_theta s) f dif x + integral s^2 f dif x = 0$, and $partial_theta s = partial_theta^2 log f$. Additivity follows because the log-likelihood of independent data is the sum of the individual ones, so the scores add and, being independent with mean zero, their variances add.
]

#theorem(title: "Cramér–Rao lower bound")[
  If $hat(theta)$ is unbiased with finite variance, then $Var_theta (hat(theta)) >= 1 slash (n I(theta))$.
]
#proof[
  Let $U = sum_i s(X_i; theta)$ be the total score, so $EE U = 0$ and $Var(U) = n I(theta)$. Unbiasedness reads $integral hat(theta)(x) f_n(x; theta) dif x = theta$ ($f_n$ the joint density). Differentiating in $theta$ gives $integral hat(theta)(x) U(x) f_n dif x = 1$, i.e. $Cov(hat(theta), U) = EE[hat(theta) U] = 1$ since $EE U = 0$. Cauchy–Schwarz: $1 = Cov(hat(theta), U)^2 <= Var(hat(theta)) Var(U) = Var(hat(theta)) n I(theta)$.
]

#remark[
  For a biased estimator with $b(theta) = bias(hat(theta))$ the same argument gives $Var(hat(theta)) >= (1 + b'(theta))^2 slash (n I(theta))$. Equality in Cauchy–Schwarz holds iff $hat(theta) - theta$ is proportional to the score, which happens exactly in exponential families for the mean-value parameter.
]

== Sufficiency (brief)

A statistic $T(X)$ is sufficient for $theta$ if the conditional law of the sample given $T$ does not depend on $theta$. By the Fisher–Neyman factorization theorem, $T$ is sufficient iff $f_n(x; theta) = g(T(x); theta) h(x)$. For normal data with known $sigma$, $sum_i X_i$ is sufficient for $mu$; for the Bernoulli model, $sum_i X_i$ is sufficient for $p$. The Rao–Blackwell theorem states that conditioning an estimator on a sufficient statistic never increases its MSE.

= Maximum likelihood

#definition[
  The likelihood is $L(theta) = product_(i=1)^n f(x_i; theta)$, the log-likelihood $ell(theta) = log L(theta)$ and the maximum likelihood estimator $hat(theta)_"MLE" = argmax_theta ell(theta)$.
]

#example(title: "Bernoulli")[
  $ell(p) = (sum x_i) log p + (n - sum x_i) log(1-p)$, $ell'(p) = (sum x_i) slash p - (n - sum x_i) slash (1-p)$. Setting it to zero gives $hat(p) = overline(x)$; $ell''<0$ so it is a maximum. The information is $I(p) = 1 slash (p(1-p))$ and $Var(hat(p)) = p(1-p) slash n = 1 slash (n I(p))$: the MLE attains the Cramér–Rao bound exactly.
]

#example(title: "Normal")[
  $ell(mu, sigma^2) = -(n slash 2) log(2 pi sigma^2) - (2 sigma^2)^(-1) sum_i (x_i - mu)^2$. The first-order conditions give $hat(mu) = overline(x)$ and $hat(sigma)^2 = n^(-1) sum_i (x_i - overline(x))^2$. By the theorem on $S^2$, $EE hat(sigma)^2 = ((n-1) slash n) sigma^2$: the MLE of the variance is biased, but consistent, and $hat(sigma)^2 = c S^2$ with $c = (n-1) slash n -> 1$.
]

== Asymptotic properties

#theorem(title: "Asymptotics of the MLE")[
  Under the regularity conditions above, with $theta_0$ the true parameter and $I(theta_0) > 0$:
  (i) $hat(theta)_"MLE" cp theta_0$;
  (ii) $sqrt(n) (hat(theta)_"MLE" - theta_0) cd cal(N)(0, I(theta_0)^(-1))$;
  (iii) invariance: the MLE of $g(theta)$ is $g(hat(theta)_"MLE")$, and by the delta method it is asymptotically $cal(N)(g(theta_0), g'(theta_0)^2 slash (n I(theta_0)))$.
]
#proof[
  _Sketch of (ii)._ Expand the score at the MLE around $theta_0$: $0 = ell'(hat(theta)) = ell'(theta_0) + (hat(theta) - theta_0) ell''(tilde(theta))$ for some $tilde(theta)$ between them. Hence
  $ sqrt(n)(hat(theta) - theta_0) = ( n^(-1 slash 2) ell'(theta_0) ) / ( - n^(-1) ell''(tilde(theta)) ). $
  The numerator is $n^(-1 slash 2) sum_i s(X_i; theta_0)$, a normalized sum of #iid mean-zero variables with variance $I(theta_0)$, so by the CLT it tends to $cal(N)(0, I(theta_0))$. By the law of large numbers and consistency, the denominator tends to $-EE[partial_theta^2 log f] = I(theta_0)$. Slutsky gives the limit $cal(N)(0, I(theta_0)^(-1))$.
]

The practical consequence is the standard error $hat(se) = 1 slash sqrt(n I(hat(theta)))$ (or its observed-information version, $1 slash sqrt(-ell''(hat(theta)))$), valid for large $n$.

== Method of moments

Equate the first $d$ population moments $m_j(theta) = EE_theta X^j$ to the sample moments $n^(-1) sum_i X_i^j$ and solve for $theta in RR^d$. The estimator is consistent when $m = (m_1, dots, m_d)$ is invertible with continuous inverse, but generally has larger asymptotic variance than the MLE.

= Interval estimation

#definition[
  A $(1-alpha)$ confidence interval is a random interval $[L(X), U(X)]$ with $PP_theta (L(X) <= theta <= U(X)) >= 1 - alpha$ for all $theta in Theta$. The left side is the coverage; the inequality is replaced by an equality for exact intervals.
]

The probability refers to the random endpoints under repeated sampling. For the realized interval, $theta$ is fixed and the event either holds or not.

#definition(title: "Pivot")[
  $Q(X; theta)$ is a pivot if its distribution does not depend on $theta$.
]

If $PP(a <= Q(X; theta) <= b) = 1-alpha$ and $Q$ is monotone in $theta$, solving $a <= Q <= b$ for $theta$ gives an exact interval.

#theorem(title: "Intervals for the normal model")[
  Let $X_i tilde.op cal(N)(mu, sigma^2)$ #iid. Exact $(1-alpha)$ intervals:
  - mean, $sigma$ unknown: $overline(X) plus.minus t_(n-1, 1-alpha slash 2) S slash sqrt(n)$;
  - mean, $sigma$ known: $overline(X) plus.minus z_(1-alpha slash 2) sigma slash sqrt(n)$;
  - variance: $[ (n-1) S^2 slash chi^2_(n-1, 1-alpha slash 2),\ (n-1) S^2 slash chi^2_(n-1, alpha slash 2) ]$.
]
#proof[
  $PP(-t <= T <= t) = 1-alpha$ with $t = t_(n-1, 1-alpha slash 2)$ and $T$ the pivot of the sampling-distribution theorem; rearranging $-t <= (overline(X) - mu) slash (S slash sqrt(n)) <= t$ gives the first interval. The second is identical with $T$ replaced by $sqrt(n)(overline(X) - mu) slash sigma tilde.op cal(N)(0,1)$. For the third, $PP(chi^2_(n-1, alpha slash 2) <= (n-1) S^2 slash sigma^2 <= chi^2_(n-1, 1-alpha slash 2)) = 1-alpha$ and inverting in $sigma^2$ reverses the inequalities.
]

#theorem(title: "Wald interval")[
  If $sqrt(n)(hat(theta) - theta) cd cal(N)(0, v(theta))$ with $v$ continuous, then $hat(theta) plus.minus z_(1-alpha slash 2) sqrt(v(hat(theta)) slash n)$ has asymptotic coverage $1 - alpha$. For the MLE, $v = I^(-1)$. For a proportion, $hat(p) plus.minus z_(1-alpha slash 2) sqrt(hat(p)(1 - hat(p)) slash n)$.
]
#proof[
  $sqrt(n)(hat(theta) - theta) slash sqrt(v(hat(theta))) = [sqrt(n)(hat(theta) - theta) slash sqrt(v(theta))] dot [sqrt(v(theta) slash v(hat(theta)))]$; the first factor tends in distribution to $cal(N)(0,1)$ and the second in probability to 1 by consistency and continuity. Apply Slutsky.
]

#remark[
  The Wald interval for a proportion has coverage that oscillates and can be far below $1-alpha$ when $n$ is small or $p$ is near 0 or 1. The Wilson interval, obtained by inverting the score test instead of replacing $p$ by $hat(p)$ in the variance, is the standard fix.
]

= Hypothesis testing

== Framework

A test of $H_0: theta in Theta_0$ against $H_1: theta in Theta_1$ is a rule $phi(X) in {0, 1}$ (1 means reject), typically $phi = bb(1){T(X) in R}$ for a statistic $T$ and rejection region $R$.

#definition[
  The size of the test is $sup_(theta in Theta_0) PP_theta (phi = 1)$; it has level $alpha$ if the size is at most $alpha$. The power function is $beta(theta) = PP_theta (phi = 1)$, so the Type II error at $theta in Theta_1$ is $1 - beta(theta)$.
]

#definition[
  The $p$-value of observed $t_"obs"$ for a statistic $T$ that rejects for large values is $p = sup_(theta in Theta_0) PP_theta (T >= t_"obs")$.
]

#lemma(title: [Uniformity of the $p$-value])[
  If $H_0$ is simple, $T$ has a continuous distribution function $G$ under $H_0$, and rejection is for large $T$, then $p(T) = 1 - G(T) tilde.op "Uniform"(0,1)$ under $H_0$. Hence rejecting when $p <= alpha$ has size exactly $alpha$.
]
#proof[
  $G(T) tilde.op "Uniform"(0,1)$ by the probability integral transform: $PP(G(T) <= u) = PP(T <= G^(-1)(u)) = u$. Then $1 - G(T)$ is also uniform.
]

== The $t$-tests

#theorem(title: [One-sample and Welch $t$-tests])[
  (i) For $X_i tilde.op cal(N)(mu, sigma^2)$ #iid, under $H_0: mu = mu_0$ the statistic $T = (overline(X) - mu_0) slash (S slash sqrt(n))$ has the $t_(n-1)$ distribution, so rejecting for $|T| > t_(n-1, 1-alpha slash 2)$ has size $alpha$.
  (ii) For two independent normal samples with means $mu_1, mu_2$, and $H_0: mu_1 = mu_2$,
  $ T = (overline(X)_1 - overline(X)_2) / sqrt(S_1^2 slash n_1 + S_2^2 slash n_2) $
  is approximately $t_nu$ with
  $ nu = (S_1^2 slash n_1 + S_2^2 slash n_2)^2 / ( (S_1^2 slash n_1)^2 slash (n_1 - 1) + (S_2^2 slash n_2)^2 slash (n_2 - 1) ). $
]
Part (i) is the pivot theorem with $mu = mu_0$. In (ii) the denominator is a weighted sum of independent scaled $chi^2$ variables, which is not exactly a scaled $chi^2$; the Welch–Satterthwaite $nu$ matches the first two moments of a scaled $chi^2_nu$ to it. With equal variances the pooled test is exactly $t_(n_1+n_2-2)$, but Welch is robust to unequal variances at little cost.

#theorem(title: "Duality of tests and intervals")[
  If, for each $theta_0$, $A(theta_0)$ is the acceptance region of a level-$alpha$ test of $theta = theta_0$, then $C(x) = {theta_0 : x in A(theta_0)}$ is a $(1-alpha)$ confidence set. Conversely, from a confidence set one obtains a test by rejecting $theta = theta_0$ iff $theta_0 in.not C(x)$.
]
#proof[
  $PP_(theta_0) (theta_0 in C(X)) = PP_(theta_0) (X in A(theta_0)) >= 1 - alpha$, for every $theta_0$. The converse is the same identity read backwards.
]

== Power and sample size

#theorem(title: [Power of the one-sided $z$-test])[
  Let $X_i tilde.op cal(N)(mu, sigma^2)$ with $sigma$ known, and reject $H_0: mu = mu_0$ in favour of $H_1: mu > mu_0$ when $Z = sqrt(n)(overline(X) - mu_0) slash sigma > z_(1-alpha)$. Then
  $ beta(mu_1) = 1 - Phi( z_(1-alpha) - sqrt(n)(mu_1 - mu_0) slash sigma ), $
  and $beta(mu_1) >= 1 - beta_0$ holds iff $n >= ( (z_(1-alpha) + z_(1 - beta_0)) sigma slash (mu_1 - mu_0) )^2$.
]
#proof[
  Under $mu = mu_1$, $sqrt(n)(overline(X) - mu_1) slash sigma tilde.op cal(N)(0,1)$, so $Z = Z_0 + sqrt(n)(mu_1 - mu_0) slash sigma$ with $Z_0 tilde.op cal(N)(0,1)$. Hence $PP(Z > z_(1-alpha)) = 1 - Phi(z_(1-alpha) - sqrt(n)(mu_1 - mu_0) slash sigma)$. Requiring this to be at least $1 - beta_0$ means $z_(1-alpha) - sqrt(n) delta slash sigma <= -z_(1-beta_0)$ (with $delta = mu_1 - mu_0$), and solving for $n$ gives the bound.
]

The required $n$ scales like $sigma^2 slash delta^2$: halving the detectable effect quadruples the sample.

== Likelihood ratio tests

#theorem(title: "Neyman–Pearson lemma")[
  For simple $H_0: theta = theta_0$ against simple $H_1: theta = theta_1$, let $phi^*$ reject when $L(theta_1) slash L(theta_0) > k$, with $k$ chosen so that $phi^*$ has size $alpha$. Then for any other test $phi$ of size at most $alpha$, $beta_phi (theta_1) <= beta_(phi^*)(theta_1)$.
]
#proof[
  For every $x$, $(phi^*(x) - phi(x))(f(x; theta_1) - k f(x; theta_0)) >= 0$: where $phi^* = 1$ the second factor is positive, where $phi^* = 0$ it is non-positive and the first factor is $-phi(x) <= 0$ or zero. Integrating over $x$ gives $beta_(phi^*)(theta_1) - beta_phi (theta_1) >= k (alpha_(phi^*) - alpha_phi) >= 0$, since both sizes are at most $alpha$ and $phi^*$ has size exactly $alpha$.
]

#theorem(title: "Wilks' theorem")[
  Let $Lambda = sup_(Theta_0) L slash sup_Theta L$, where $Theta$ has $d$ free parameters and $Theta_0$ has $d - r$. Under the regularity conditions and $H_0$,
  $ -2 log Lambda cd chi^2_r. $
]
The proof expands $ell$ quadratically around the MLE and uses asymptotic normality of the MLE, so that $-2 log Lambda$ becomes a quadratic form in $r$ asymptotically independent standard normals. The Wald and score tests are asymptotically equivalent to it. In the linear model with Gaussian errors, the likelihood ratio is a monotone function of an $F$ statistic, which is why the $F$-test of regression has an exact distribution.

== Multiple testing

With $m$ tests and all nulls true, each at level $alpha$, the expected number of false rejections is $m alpha$.

#theorem(title: "Bonferroni and Benjamini–Hochberg")[
  (i) Rejecting each hypothesis with $p_i <= alpha slash m$ controls the family-wise error rate, $PP("at least one false rejection") <= alpha$, with no assumption on the dependence of the $p$-values.
  (ii) Order the $p$-values $p_((1)) <= dots <= p_((m))$ and reject the $k$ smallest, where $k = max {i : p_((i)) <= i alpha slash m}$. If the $p$-values are independent, the false discovery rate $EE[V slash max(R, 1)]$ (with $V$ false rejections out of $R$) is at most $alpha m_0 slash m <= alpha$, where $m_0$ is the number of true nulls.
]
#proof[
  (i) By the union bound, $PP(union.big_(i in H_0) {p_i <= alpha slash m}) <= m_0 alpha slash m <= alpha$. (ii) is the Benjamini–Hochberg (1995) theorem; the proof conditions on the other $p$-values and is omitted.
]

= Summary of the main formulas

#table(
  columns: (1fr, 2fr),
  align: (left, left),
  stroke: 0.5pt + gray,
  inset: 6pt,
  [*Quantity*], [*Result*],
  [Standard error of the mean], [$sigma slash sqrt(n)$],
  [$S^2$ unbiased], [$EE S^2 = sigma^2$, divisor $n - 1$],
  [Normal sampling laws], [$(n-1) S^2 slash sigma^2 tilde.op chi^2_(n-1)$, $T tilde.op t_(n-1)$, $overline(X) perp S^2$],
  [MSE], [$Var + bias^2$],
  [Cramér–Rao], [$Var(hat(theta)) >= 1 slash (n I(theta))$],
  [MLE], [$sqrt(n)(hat(theta) - theta_0) cd cal(N)(0, I(theta_0)^(-1))$],
  [CI for the mean], [$overline(X) plus.minus t_(n-1, 1-alpha slash 2) S slash sqrt(n)$],
  [CI for the variance], [$[(n-1) S^2 slash chi^2_(n-1, 1-alpha slash 2), (n-1) S^2 slash chi^2_(n-1, alpha slash 2)]$],
  [Wald interval], [$hat(theta) plus.minus z_(1-alpha slash 2) hat(se)$],
  [Sample size, one-sided $z$-test], [$n = ((z_(1-alpha) + z_(1-beta)) sigma slash delta)^2$],
  [Likelihood ratio], [$-2 log Lambda cd chi^2_r$],
  [Bonferroni / BH], [$p_i <= alpha slash m$ / largest $k$ with $p_((k)) <= k alpha slash m$],
)

= References

- G. Casella and R. L. Berger, _Statistical Inference_, 2nd ed., Duxbury, 2002: the standard source for the proofs of the Cramér–Rao bound, the MLE asymptotics and the Neyman–Pearson lemma.
- J. L. Devore, _Probability and Statistics for Engineering and the Sciences_, Cengage, 2011: the course text for the first part of the syllabus.
- L. Wasserman, _All of Statistics_, Springer, 2004: concise statements of the limit theorems, MLE and multiple testing.
- Y. Benjamini and Y. Hochberg, "Controlling the false discovery rate", _J. R. Statist. Soc. B_ 57 (1995).
