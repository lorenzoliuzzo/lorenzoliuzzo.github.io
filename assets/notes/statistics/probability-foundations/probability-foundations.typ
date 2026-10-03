// Technical reference for the note `_notes/statistics/probability-foundations.md`.
// The site page explains; this document states the results precisely and proves
// the ones an exam is likely to ask for.

#set document(title: "Probability Foundations: technical reference", author: "Lorenzo Liuzzo")
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
  #text(size: 19pt, weight: "bold")[Probability Foundations] \
  #v(2pt)
  #text(size: 12pt)[Technical reference] \
  #v(2pt)
  #text(size: 9.5pt, fill: gray)[Companion to the note on lorenzoliuzzo.github.io. Axioms, expectation, variance and limit theorems, with proofs.]
]
#v(6pt)

#outline(indent: 1.2em, depth: 2)

= Probability toolkit

== Probability spaces and the axioms

A probability space is a triple $(Omega, cal(F), PP)$: a sample space $Omega$, a $sigma$-algebra $cal(F)$ of events (a family of subsets of $Omega$ containing $Omega$ and closed under complements and countable unions), and a function $PP: cal(F) -> [0,1]$ satisfying the axioms below. Events $A, B$ are _disjoint_ if $A inter B = emptyset$; events $B_1, B_2, dots$ form a _partition_ if they are pairwise disjoint and $union.big_i B_i = Omega$.

#definition(title: "Kolmogorov axioms")[
  (A1) $PP(A) >= 0$ for every event $A$. (A2) $PP(Omega) = 1$. (A3) For pairwise disjoint events $A_1, A_2, dots$, $PP(union.big_i A_i) = sum_i PP(A_i)$.
]

#theorem(title: "Consequences of the axioms")[
  For events $A, B, A_1, A_2, dots$:
  (i) $PP(emptyset) = 0$;
  (ii) finite additivity: $PP(union.big_(i=1)^n A_i) = sum_(i=1)^n PP(A_i)$ for disjoint $A_i$;
  (iii) $PP(A^c) = 1 - PP(A)$;
  (iv) if $A subset.eq B$ then $PP(A) <= PP(B)$; in particular $PP(A) <= 1$;
  (v) $PP(A union B) = PP(A) + PP(B) - PP(A inter B)$;
  (vi) union bound: $PP(union.big_i A_i) <= sum_i PP(A_i)$.
]
#proof[
  (i) Take $A_i = emptyset$ for all $i$ in (A3): $PP(emptyset) = sum_i PP(emptyset)$, which forces $PP(emptyset) = 0$. (ii) Apply (A3) with $A_i = emptyset$ for $i > n$ and use (i). (iii) $Omega = A union A^c$ is a disjoint union, so $1 = PP(A) + PP(A^c)$. (iv) $B = A union (B without A)$ is disjoint, so $PP(B) = PP(A) + PP(B without A) >= PP(A)$; with $B = Omega$ this gives $PP(A) <= 1$. (v) Write $A union B = A union (B without A)$ and $B = (A inter B) union (B without A)$, both disjoint; then $PP(B without A) = PP(B) - PP(A inter B)$, and substituting gives (v). (vi) Set $B_1 = A_1$ and $B_i = A_i without union.big_(j<i) A_j$. The $B_i$ are disjoint, $union.big_i B_i = union.big_i A_i$ and $B_i subset.eq A_i$, so by (A3) and (iv) $PP(union.big_i A_i) = sum_i PP(B_i) <= sum_i PP(A_i)$.
]

The general inclusion–exclusion formula is $PP(union.big_(i=1)^n A_i) = sum_i PP(A_i) - sum_(i<j) PP(A_i inter A_j) + sum_(i<j<k) PP(A_i inter A_j inter A_k) - dots.c$. Two further facts follow from (A3) by taking limits: if $A_n$ increases to $A$ then $PP(A_n) -> PP(A)$, and likewise for decreasing sequences (continuity of $PP$). When $Omega$ is finite and outcomes are equally likely, $PP(A) = |A| slash |Omega|$.

== Conditional probability, independence, Bayes

#definition[
  For $PP(B) > 0$, the conditional probability of $A$ given $B$ is $PP(A | B) = PP(A inter B) slash PP(B)$. Then $PP(dot | B)$ is itself a probability: it satisfies (A1)–(A3) on $cal(F)$, so all the consequences above hold conditionally.
]

Rearranging gives the multiplication rule $PP(A inter B) = PP(A | B) PP(B)$ and, by induction, the chain rule
$ PP(A_1 inter dots.c inter A_n) = PP(A_1) PP(A_2 | A_1) dots.c PP(A_n | A_1 inter dots.c inter A_(n-1)). $

#definition(title: "Independence")[
  $A$ and $B$ are independent if $PP(A inter B) = PP(A) PP(B)$ (equivalently $PP(A | B) = PP(A)$ when $PP(B) > 0$). Events $A_1, dots, A_n$ are _mutually_ independent if $PP(inter.big_(i in S) A_i) = product_(i in S) PP(A_i)$ for every subset $S$ of indices; pairwise independence alone does not imply this. $A$ and $B$ are conditionally independent given $C$ if $PP(A inter B | C) = PP(A | C) PP(B | C)$.
]

#remark[
  Disjoint events with positive probability are never independent: $PP(A inter B) = 0 != PP(A) PP(B)$.
]

#theorem(title: "Law of total probability and Bayes' theorem")[
  Let $B_1, B_2, dots$ be a partition of $Omega$ with $PP(B_i) > 0$. For any event $A$,
  $ PP(A) = sum_i PP(A | B_i) PP(B_i), $ <totalprob>
  and, if $PP(A) > 0$,
  $ PP(B_j | A) = (PP(A | B_j) PP(B_j)) / (sum_i PP(A | B_i) PP(B_i)). $ <bayes>
]
#proof[
  The sets $A inter B_i$ are disjoint with union $A$, so by (A3) and the multiplication rule $PP(A) = sum_i PP(A inter B_i) = sum_i PP(A | B_i) PP(B_i)$. For Bayes, $PP(B_j | A) = PP(A inter B_j) slash PP(A) = PP(A | B_j) PP(B_j) slash PP(A)$, and the denominator is @totalprob.
]

In Bayesian language $PP(B_j)$ is the prior, $PP(A | B_j)$ the likelihood, $PP(A)$ the evidence (marginal likelihood) and $PP(B_j | A)$ the posterior. The odds form is $PP(B | A) slash PP(B^c | A) = [PP(A | B) slash PP(A | B^c)] dot [PP(B) slash PP(B^c)]$: posterior odds equal likelihood ratio times prior odds.

#example(title: "Diagnostic test")[
  Prevalence $PP(D) = 0.01$, sensitivity $PP(+ | D) = 0.95$, false-positive rate $PP(+ | D^c) = 0.10$. Then
  $ PP(D | +) = (0.95 dot 0.01) / (0.95 dot 0.01 + 0.10 dot 0.99) = 0.0095 / 0.1085 approx 0.088. $
  The posterior is below 9% because the healthy majority produces more false positives than the sick minority produces true ones: the base rate matters.
]

== Random variables and distributions

A random variable is a measurable function $X: Omega -> RR$. Its distribution function is $F(x) = PP(X <= x)$.

#lemma(title: "Properties of the distribution function")[
  $F$ is non-decreasing and right-continuous, with $lim_(x -> -infinity) F(x) = 0$ and $lim_(x -> infinity) F(x) = 1$. For $a < b$, $PP(a < X <= b) = F(b) - F(a)$.
]
#proof[
  Monotonicity is (iv) applied to $\{X <= x\} subset.eq \{X <= y\}$. Right-continuity and the limits follow from continuity of $PP$ along monotone sequences of events. Finally $\{X <= b\} = \{X <= a\} union \{a < X <= b\}$ is disjoint.
]

$X$ is discrete with mass function $p(x) = PP(X = x)$, $sum_x p(x) = 1$, or continuous with density $f = F'$, $integral f = 1$ and $PP(a <= X <= b) = integral_a^b f$; in the continuous case $PP(X = x) = 0$ for every $x$. The quantile function is $F^(-1)(p) = inf {x : F(x) >= p}$ and the median is $F^(-1)(1 slash 2)$. For a pair $(X, Y)$ with joint density $f_(X,Y)$, the marginal is $f_X(x) = integral f_(X,Y)(x, y) dif y$, the conditional density is $f_(X|Y)(x | y) = f_(X,Y)(x, y) slash f_Y(y)$, and $X, Y$ are independent iff $f_(X,Y) = f_X f_Y$.

== Expectation

#definition[
  $EE[X] = sum_x x p(x)$ (discrete) or $integral x f(x) dif x$ (continuous), when the sum or integral converges absolutely. For a function $g$ (law of the unconscious statistician), $EE[g(X)] = sum_x g(x) p(x)$ or $integral g(x) f(x) dif x$.
]

#theorem(title: "Properties of expectation")[
  (i) Linearity: $EE[a X + b Y + c] = a EE[X] + b EE[Y] + c$ for any $X, Y$, dependent or not. (ii) Monotonicity: $X <= Y$ implies $EE[X] <= EE[Y]$. (iii) If $X, Y$ are independent, $EE[X Y] = EE[X] EE[Y]$. (iv) $EE[bb(1)_A] = PP(A)$. (v) Jensen: for convex $g$, $g(EE[X]) <= EE[g(X)]$.
]
#proof[
  (i) and (ii) follow from linearity and monotonicity of sums and integrals, using the joint density for $X$ and $Y$ together. (iii) By independence $f_(X,Y) = f_X f_Y$, so $EE[X Y] = integral integral x y f_X(x) f_Y(y) dif x dif y = EE[X] EE[Y]$. (iv) $bb(1)_A$ takes the value 1 with probability $PP(A)$ and 0 otherwise. (v) A convex $g$ lies above its tangent line at $m = EE[X]$: $g(x) >= g(m) + c(x - m)$ for some slope $c$; take expectations.
]

== Variance, covariance, correlation

#definition[
  $Var(X) = EE[(X - mu)^2]$ with $mu = EE[X]$; the standard deviation is $sigma = sqrt(Var(X))$. $Cov(X, Y) = EE[(X - EE X)(Y - EE Y)]$ and, when $sigma_X, sigma_Y > 0$, the correlation is $rho_(X Y) = Cov(X, Y) slash (sigma_X sigma_Y)$. Moments: $EE[X^k]$; central moments $EE[(X - mu)^k]$; skewness $EE[(X - mu)^3] slash sigma^3$ and kurtosis $EE[(X - mu)^4] slash sigma^4$ (equal to 3 for the normal).
]

#theorem(title: "Properties of variance and covariance")[
  (i) $Var(X) = EE[X^2] - (EE X)^2 >= 0$, with equality iff $X$ is almost surely constant.
  (ii) $Var(a X + b) = a^2 Var(X)$.
  (iii) $Cov(X, Y) = EE[X Y] - EE[X] EE[Y]$, $Cov(X, X) = Var(X)$, and $Cov$ is bilinear.
  (iv) $Var(a X + b Y) = a^2 Var(X) + b^2 Var(Y) + 2 a b Cov(X, Y)$.
  (v) Independent $X, Y$ have $Cov(X, Y) = 0$; the converse is false.
  (vi) $|rho_(X Y)| <= 1$, with equality iff $Y = a X + b$ almost surely.
]
#proof[
  (i) Expand $(X - mu)^2 = X^2 - 2 mu X + mu^2$ and take expectations; nonnegativity holds because the integrand is $>= 0$, and $EE[(X - mu)^2] = 0$ forces $X = mu$ almost surely. (ii) $a X + b - EE[a X + b] = a (X - mu)$. (iii) Expand the product and use linearity; bilinearity is linearity in each argument. (iv) is (ii) and (iii) combined. (v) follows from (iii) and property (iii) of expectation. For the failure of the converse, let $X tilde.op cal(N)(0,1)$ and $Y = X^2$: $Cov(X, Y) = EE[X^3] - EE[X] EE[X^2] = 0$ since odd moments of a symmetric law vanish, yet $Y$ is a function of $X$. (vi) For every real $t$, $0 <= Var(Y - t X) = Var(Y) - 2 t Cov(X, Y) + t^2 Var(X)$. A quadratic in $t$ that never goes negative has non-positive discriminant, $4 Cov(X, Y)^2 - 4 Var(X) Var(Y) <= 0$, which is $|rho| <= 1$. Equality means the discriminant vanishes, so $Var(Y - t X) = 0$ for some $t$ and $Y - t X$ is constant.
]

Property (iv) generalizes to $Var(sum_i X_i) = sum_i Var(X_i) + 2 sum_(i<j) Cov(X_i, X_j)$, and so, for uncorrelated (hence independent) $X_i$ with common variance $sigma^2$,
$ Var(sum_i X_i) = n sigma^2, quad Var(overline(X)_n) = sigma^2 slash n. $ <varsum>

#theorem(title: "Law of total expectation and total variance")[
  If $EE[X^2] < infinity$, then $EE[X] = EE[ EE[X | Y] ]$ and
  $ Var(X) = EE[ Var(X | Y) ] + Var( EE[X | Y] ). $
]
#proof[
  The first identity is the law of total probability for expectations: $EE[X] = integral EE[X | Y = y] f_Y(y) dif y$. For the second, write $X - EE X = (X - EE[X | Y]) + (EE[X | Y] - EE X)$ and square. The cross term has expectation zero: conditionally on $Y$ the second factor is fixed and $EE[X - EE[X | Y] | Y] = 0$. The first square has expectation $EE[Var(X | Y)]$ and the second $Var(EE[X | Y])$.
]

== Markov and Chebyshev

#lemma(title: "Markov and Chebyshev")[
  If $X >= 0$ and $a > 0$ then $PP(X >= a) <= EE[X] slash a$. For any $X$ with mean $mu$ and variance $sigma^2$ and any $k>0$, $PP(|X - mu| >= k) <= sigma^2 slash k^2$.
]
#proof[
  $a thin bb(1){X >= a} <= X$ pointwise, take expectations. Chebyshev is Markov applied to $(X-mu)^2$ and $a = k^2$.
]

The standard discrete and continuous distributions, with their means, variances and uses, are in the Sampling Distributions reference.

== Limit theorems

Write $overline(X)_n = n^(-1) sum_(i=1)^n X_i$.

#theorem(title: "Weak law of large numbers")[
  If $X_i$ are #iid with $EE X_1 = mu$ and $Var(X_1) = sigma^2 < infinity$, then $overline(X)_n cp mu$, i.e. $PP(|overline(X)_n - mu| > epsilon) -> 0$ for every $epsilon > 0$.
]
#proof[
  By @varsum, $Var(overline(X)_n) = sigma^2 slash n$. Chebyshev gives $PP(|overline(X)_n - mu| >= epsilon) <= sigma^2 slash (n epsilon^2) -> 0$.
]

#theorem(title: "Central limit theorem")[
  If $X_i$ are #iid with mean $mu$ and variance $0 < sigma^2 < infinity$, then
  $ sqrt(n) (overline(X)_n - mu) slash sigma cd cal(N)(0,1). $
]
The proof goes through characteristic functions and is not reproduced here. The Berry–Esseen theorem quantifies the rate: the Kolmogorov distance to $Phi$ is at most $C EE|X_1 - mu|^3 slash (sigma^3 sqrt(n))$. This is why the sample size needed depends on skewness.

#theorem(title: "Slutsky and delta method")[
  If $A_n cd A$ and $B_n cp b$ (constant), then $A_n + B_n cd A + b$ and $A_n B_n cd b A$. If moreover $sqrt(n)(T_n - theta) cd cal(N)(0, tau^2)$ and $g$ is differentiable at $theta$ with $g'(theta) != 0$, then
  $ sqrt(n) (g(T_n) - g(theta)) cd cal(N)(0, g'(theta)^2 tau^2). $
]
Slutsky is what licenses replacing an unknown $sigma$ by a consistent estimate in a pivot, which is how the Wald and large-sample $t$ intervals are justified.

= References

- G. Casella and R. L. Berger, _Statistical Inference_, 2nd ed., Duxbury, 2002, chapters 1 to 5.
- J. L. Devore, _Probability and Statistics for Engineering and the Sciences_, Cengage, 2011, chapters 1 to 5.
- L. Wasserman, _All of Statistics_, Springer, 2004, chapters 1 to 5.
