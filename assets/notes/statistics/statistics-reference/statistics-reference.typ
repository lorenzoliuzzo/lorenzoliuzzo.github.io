// Technical reference for the statistics notes in `_notes/statistics/`.
// One document covers all of them: the site pages explain and are kept short,
// this reference states the results precisely and proves the ones an exam is
// likely to ask for.

#set document(title: "Statistics: technical reference", author: "Lorenzo Liuzzo")
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
  #text(size: 19pt, weight: "bold")[Statistics] \
  #v(2pt)
  #text(size: 12pt)[Technical reference] \
  #v(2pt)
  #text(size: 9.5pt, fill: gray)[Companion to the statistics notes on lorenzoliuzzo.github.io. Probability, standard random variables, sampling distributions, estimation, intervals and tests, with proofs.]
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

The standard discrete and continuous distributions, with their means, variances and uses, are in the chapters on discrete and continuous random variables below.

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

= Discrete random variables

A discrete random variable has mass function $p(x) = PP(X = x)$ on a countable support, with $sum_x p(x) = 1$, $EE[X] = sum_x x p(x)$ and $Var(X) = EE[X^2] - (EE X)^2$. Probability background is in the Probability toolkit chapter.

== Bernoulli and binomial

#definition[
  $X tilde.op "Bernoulli"(p)$ if $PP(X = 1) = p$ and $PP(X = 0) = 1 - p$. $Y tilde.op "Binomial"(n, p)$ is the sum of $n$ independent Bernoulli($p$) variables, with mass function $PP(Y = k) = binom(n, k) p^k (1-p)^(n-k)$, $k = 0, dots, n$.
]

#theorem(title: "Mean and variance")[
  If $X tilde.op "Bernoulli"(p)$ then $EE[X] = p$ and $Var(X) = p(1-p)$. If $Y tilde.op "Binomial"(n,p)$ then $EE[Y] = n p$ and $Var(Y) = n p (1-p)$.
]
#proof[
  $EE[X] = 1 dot p + 0 dot (1-p) = p$, and since $X^2 = X$, $EE[X^2] = p$ and $Var(X) = p - p^2$. For $Y = sum_(i=1)^n X_i$ with independent $X_i$, linearity gives $EE[Y] = n p$ and independence gives $Var(Y) = sum_i Var(X_i) = n p (1-p)$.
]

The binomial mass function counts the $binom(n, k)$ arrangements of $k$ successes among $n$ trials, each with probability $p^k (1-p)^(n-k)$. For large $n$ it is approximately $cal(N)(n p, n p (1-p))$ by the central limit theorem; a common rule is $n p (1-p) >= 10$.

== Geometric

#definition[
  $X tilde.op "Geometric"(p)$ counts the trials up to and including the first success: $PP(X = k) = (1-p)^(k-1) p$, $k = 1, 2, dots$.
]

#theorem(title: "Mean and memorylessness")[
  $EE[X] = 1 slash p$ and $Var(X) = (1-p) slash p^2$. Moreover $PP(X > m + k | X > m) = PP(X > k)$ for all integers $m, k >= 0$.
]
#proof[
  With $q = 1 - p$, $EE[X] = p sum_(k>=1) k q^(k-1) = p slash (1-q)^2 = 1 slash p$, using $sum_(k >= 1) k q^(k-1) = d/(d q) sum_(k>=0) q^k = (1-q)^(-2)$. A second differentiation gives $EE[X(X-1)]$ and hence the variance. For the tail, $PP(X > k) = q^k$, so $PP(X > m + k | X > m) = q^(m+k) slash q^m = q^k$.
]

== Poisson

#definition[
  $X tilde.op "Poisson"(lambda)$ has $PP(X = k) = e^(-lambda) lambda^k slash k!$, $k = 0, 1, 2, dots$.
]

#theorem(title: "Moments, sums and the binomial limit")[
  (i) $EE[X] = Var(X) = lambda$. (ii) If $X tilde.op "Poisson"(lambda)$ and $Y tilde.op "Poisson"(mu)$ are independent then $X + Y tilde.op "Poisson"(lambda + mu)$. (iii) If $X_n tilde.op "Binomial"(n, lambda slash n)$ then $PP(X_n = k) -> e^(-lambda) lambda^k slash k!$ for every fixed $k$.
]
#proof[
  (i) $EE[X] = sum_(k>=1) k e^(-lambda) lambda^k slash k! = lambda e^(-lambda) sum_(k>=1) lambda^(k-1) slash (k-1)! = lambda$, and similarly $EE[X(X-1)] = lambda^2$, so $Var(X) = lambda^2 + lambda - lambda^2 = lambda$. (ii) $PP(X + Y = m) = sum_(j=0)^m e^(-lambda) lambda^j slash j! dot e^(-mu) mu^(m-j) slash (m-j)! = e^(-(lambda+mu)) (lambda + mu)^m slash m!$ by the binomial theorem. (iii) $PP(X_n = k) = [n! slash ((n-k)! n^k)] dot (lambda^k slash k!) (1 - lambda slash n)^(n-k)$. As $n -> infinity$ the first factor tends to 1, $(1 - lambda slash n)^n -> e^(-lambda)$ and $(1 - lambda slash n)^(-k) -> 1$.
]

= Continuous random variables

A continuous random variable has a density $f$ with $PP(a <= X <= b) = integral_a^b f$, mean $EE[X] = integral x f(x) dif x$ and distribution function $F(x) = integral_(-infinity)^x f$.

== Uniform and inverse transform sampling

$X tilde.op "Uniform"(a, b)$ has $f(x) = 1 slash (b-a)$ on $[a,b]$, $EE[X] = (a+b) slash 2$ and $Var(X) = (b-a)^2 slash 12$ (compute $EE[X^2] = (a^2 + a b + b^2) slash 3$).

#theorem(title: "Inverse transform")[
  Let $F$ be a distribution function, $F^(-1)(u) = inf {x : F(x) >= u}$, and $U tilde.op "Uniform"(0,1)$. Then $F^(-1)(U)$ has distribution function $F$. Conversely, if $X$ has a continuous distribution function $F$, then $F(X) tilde.op "Uniform"(0,1)$.
]
#proof[
  The generalized inverse satisfies $F^(-1)(u) <= x$ iff $u <= F(x)$, so $PP(F^(-1)(U) <= x) = PP(U <= F(x)) = F(x)$. For the converse, with $F$ continuous and strictly increasing on the support, $PP(F(X) <= u) = PP(X <= F^(-1)(u)) = F(F^(-1)(u)) = u$.
]

The converse is the probability integral transform used for the uniformity of $p$-values; the direct statement is how simulation software turns uniform random numbers into draws from any distribution with a computable $F^(-1)$.

== Exponential

#definition[
  $X tilde.op "Exponential"(lambda)$ has $f(x) = lambda e^(-lambda x)$, $x >= 0$, so that $PP(X > x) = e^(-lambda x)$.
]

#theorem(title: "Moments and memorylessness")[
  $EE[X] = 1 slash lambda$, $Var(X) = 1 slash lambda^2$, and $PP(X > s + t | X > s) = PP(X > t)$.
]
#proof[
  Integrating by parts, $EE[X] = integral_0^infinity x lambda e^(-lambda x) dif x = 1 slash lambda$ and $EE[X^2] = 2 slash lambda^2$, so $Var(X) = 1 slash lambda^2$. For the tail, $PP(X > s + t | X > s) = e^(-lambda (s+t)) slash e^(-lambda s) = e^(-lambda t)$.
]

The exponential is the only continuous distribution on $[0, infinity)$ with this property. If events arrive as a Poisson process of rate $lambda$ (the count in an interval of length $t$ is Poisson($lambda t$)), the waiting time to the first event, and between successive events, is Exponential($lambda$): $PP(T > t) = PP("no event in " [0, t]) = e^(-lambda t)$.

== Normal

#definition[
  $X tilde.op cal(N)(mu, sigma^2)$ has density $(2 pi sigma^2)^(-1 slash 2) exp(-(x-mu)^2 slash (2 sigma^2))$. The standard normal $cal(N)(0,1)$ has distribution function $Phi$ and quantiles $z_p = Phi^(-1)(p)$.
]

#theorem(title: "Standardization and closure")[
  (i) $EE[X] = mu$ and $Var(X) = sigma^2$. (ii) $Z = (X - mu) slash sigma tilde.op cal(N)(0,1)$, so $PP(X <= x) = Phi((x - mu) slash sigma)$. (iii) If $X_1, dots, X_n$ are independent, $X_i tilde.op cal(N)(mu_i, sigma_i^2)$, then $sum_i a_i X_i + b tilde.op cal(N)(sum_i a_i mu_i + b, sum_i a_i^2 sigma_i^2)$.
]
#proof[
  (ii) The substitution $y = (u - mu) slash sigma$ in $integral_(-infinity)^x f(u) dif u$ gives $integral_(-infinity)^((x - mu) slash sigma) phi(y) dif y$. (i) follows from (ii) since $EE[Z] = 0$ (odd integrand) and $EE[Z^2] = 1$ (integration by parts). (iii) The mean and variance follow from linearity and independence; that the sum is again normal follows from the moment generating function $EE[e^(t X)] = e^(mu t + sigma^2 t^2 slash 2)$, which multiplies for independent summands.
]

Quantiles that recur: $z_(0.90) approx 1.282$, $z_(0.95) approx 1.645$, $z_(0.975) approx 1.960$, $z_(0.995) approx 2.576$, and $PP(|Z| <= 1, 2, 3) approx 0.683, 0.954, 0.997$.

== Gamma and chi-square

#definition[
  $X tilde.op "Gamma"(alpha, beta)$ (shape $alpha > 0$, rate $beta > 0$) has density $beta^alpha x^(alpha - 1) e^(-beta x) slash Gamma(alpha)$ on $x > 0$, with $EE[X] = alpha slash beta$ and $Var(X) = alpha slash beta^2$. The sum of $k$ independent Exponential($lambda$) variables is Gamma($k, lambda$). The chi-square distribution is $chi^2_k = "Gamma"(k slash 2, 1 slash 2)$, with density $x^(k slash 2 - 1) e^(-x slash 2) slash (2^(k slash 2) Gamma(k slash 2))$.
]

#theorem(title: [Chi-square as a sum of squares])[
  If $Z_1, dots, Z_k$ are independent $cal(N)(0,1)$ then $sum_i Z_i^2 tilde.op chi^2_k$, with mean $k$ and variance $2k$.
]
#proof[
  The density of $Z_1^2$ follows by the change of variable $y = z^2$ and equals the $chi^2_1$ density; independent Gamma variables with a common rate add their shapes, giving $chi^2_k$. For the moments, $EE[Z^2] = 1$ and $Var(Z^2) = EE[Z^4] - 1 = 3 - 1 = 2$, and the $Z_i^2$ are independent, so the mean is $k$ and the variance $2k$.
]

= Sampling distributions of statistics

A statistic $T = T(X_1, dots, X_n)$ is a random variable. Its sampling distribution is the law of $T$ when the sample is drawn from the assumed model, and its standard error is $se(T) = sqrt(Var(T))$.

== Mean, variance and proportion

#theorem(title: [Mean and variance of $overline(X)$])[
  For #iid $X_i$ with mean $mu$ and variance $sigma^2$, $EE[overline(X)] = mu$ and $Var(overline(X)) = sigma^2 slash n$. For two independent samples, $overline(X)_1 - overline(X)_2$ has mean $mu_1 - mu_2$ and variance $sigma_1^2 slash n_1 + sigma_2^2 slash n_2$.
]
#proof[
  Linearity gives $EE[overline(X)] = n^(-1) sum_i EE[X_i] = mu$; independence gives $Var(overline(X)) = n^(-2) sum_i Var(X_i) = sigma^2 slash n$. For the difference, $Var(overline(X)_1 - overline(X)_2) = Var(overline(X)_1) + Var(overline(X)_2)$ by independence.
]

If the data are normal, $overline(X) tilde.op cal(N)(mu, sigma^2 slash n)$ exactly; in general the central limit theorem gives $sqrt(n)(overline(X) - mu) slash sigma cd cal(N)(0,1)$.

#theorem(title: "Sample proportion")[
  If $Y tilde.op "Binomial"(n,p)$ and $hat(p) = Y slash n$, then $EE[hat(p)] = p$, $Var(hat(p)) = p(1-p) slash n$, and $sqrt(n)(hat(p) - p) slash sqrt(p(1-p)) cd cal(N)(0,1)$.
]
#proof[
  The moments follow from those of the binomial and the scaling rule $Var(Y slash n) = Var(Y) slash n^2$. The limit is the central limit theorem applied to $Y = sum_i X_i$ with Bernoulli summands (the de Moivre–Laplace theorem).
]

#example(title: "Classifier accuracy")[
  A classifier with true accuracy $p = 0.8$ evaluated on $n = 100$ independent test examples has $se(hat(p)) = sqrt(0.8 dot 0.2 slash 100) = 0.04$, so the observed accuracy lies in $0.8 plus.minus 0.08$ with probability about 95%.
]

== Normal-theory distributions

#definition(title: "Gaussian family")[
  $X tilde.op cal(N)(mu, sigma^2)$ has density $(2 pi sigma^2)^(-1 slash 2) exp(-(x-mu)^2 slash (2 sigma^2))$. Let $Z_1, dots, Z_k tilde.op cal(N)(0,1)$ be independent. Then
  - $sum_i Z_i^2 tilde.op chi^2_k$ (chi-square, $k$ degrees of freedom), with mean $k$ and variance $2k$;
  - if $Z tilde.op cal(N)(0,1)$ and $V tilde.op chi^2_k$ are independent, $Z slash sqrt(V slash k) tilde.op t_k$ (Student);
  - if $V_1 tilde.op chi^2_a$ and $V_2 tilde.op chi^2_b$ are independent, $(V_1 slash a) slash (V_2 slash b) tilde.op F_(a,b)$.
]

Facts used below: a linear combination of jointly Gaussian variables is Gaussian; for jointly Gaussian variables, uncorrelated implies independent; $t_k -> cal(N)(0,1)$ as $k -> infinity$; $t_k^2 tilde.op F_(1,k)$.


Let $X_1, dots, X_n tilde.op cal(N)(mu, sigma^2)$ be #iid, with $overline(X) = overline(X)_n$ and $S^2 = (n-1)^(-1) sum_i (X_i - overline(X))^2$.

#theorem(title: [Distribution of $overline(X)$ and $S^2$])[
  (i) $overline(X) tilde.op cal(N)(mu, sigma^2 slash n)$. (ii) $overline(X)$ and $S^2$ are independent. (iii) $(n-1) S^2 slash sigma^2 tilde.op chi^2_(n-1)$. (iv) Consequently
  $ T = (overline(X) - mu) / (S slash sqrt(n)) tilde.op t_(n-1). $
]
#proof[
  (i) is closure of the Gaussian family under linear maps. For (ii)–(iii), let $Z_i = (X_i - mu) slash sigma$ and $Q$ an orthogonal $n times n$ matrix whose first row is $(1 slash sqrt(n), dots, 1 slash sqrt(n))$. Then $Y = Q Z$ has $Y_1 = sqrt(n) overline(Z)$ and, since $Q$ is orthogonal, $Y tilde.op cal(N)(0, I_n)$: the $Y_i$ are independent standard normals. Orthogonality preserves the norm: $sum_i Z_i^2 = sum_i Y_i^2$, and $sum_i Z_i^2 = sum_i (Z_i - overline(Z))^2 + n overline(Z)^2$, hence
  $ sum_i (Z_i - overline(Z))^2 = sum_(i=2)^n Y_i^2 tilde.op chi^2_(n-1), $
  a function of $(Y_2, dots, Y_n)$ only, and so independent of $Y_1$ and thus of $overline(Z)$. Since $sum_i (Z_i - overline(Z))^2 = (n-1) S^2 slash sigma^2$ and $overline(X) = mu + sigma overline(Z)$, (ii) and (iii) follow. For (iv), write $T = [ (overline(X) - mu) slash (sigma slash sqrt(n)) ] slash sqrt( ((n-1) S^2 slash sigma^2) slash (n-1) )$, a standard normal over the root of an independent $chi^2_(n-1) slash (n-1)$.
]

#theorem(title: [Unbiasedness of $S^2$])[
  For any #iid sample with finite variance $sigma^2$, $EE[S^2] = sigma^2$.
]
#proof[
  $sum_i (X_i - overline(X))^2 = sum_i (X_i - mu)^2 - n (overline(X) - mu)^2$. Taking expectations, $EE[sum_i (X_i - overline(X))^2] = n sigma^2 - n (sigma^2 slash n) = (n-1) sigma^2$.
]

== The $t$ and $F$ distributions in more detail

The $t_k$ distribution has density $Gamma((k+1) slash 2) slash (sqrt(k pi) Gamma(k slash 2)) dot (1 + t^2 slash k)^(-(k+1) slash 2)$. It is symmetric about 0, has mean 0 for $k > 1$ and variance $k slash (k-2)$ for $k > 2$, and has heavier tails than $cal(N)(0,1)$, to which it converges as $k -> infinity$. Selected 97.5% quantiles are $t_(5, 0.975) = 2.571$, $t_(9, 0.975) = 2.262$, $t_(29, 0.975) = 2.045$, against $z_(0.975) = 1.960$.

#lemma(title: [Relation between $t$ and $F$])[
  If $T tilde.op t_k$ then $T^2 tilde.op F_(1,k)$.
]
#proof[
  Write $T = Z slash sqrt(V slash k)$ with $Z tilde.op cal(N)(0,1)$ independent of $V tilde.op chi^2_k$. Then $T^2 = Z^2 slash (V slash k) = (Z^2 slash 1) slash (V slash k)$ with $Z^2 tilde.op chi^2_1$, the ratio defining $F_(1,k)$.
]

The $F_(a,b)$ distribution has mean $b slash (b-2)$ for $b > 2$ and is the null distribution of the ratio of two independent normal-sample variance estimates, $S_1^2 slash S_2^2$ scaled by $sigma_2^2 slash sigma_1^2$, with $a = n_1 - 1$ and $b = n_2 - 1$; it is also the null distribution of the overall test in analysis of variance and linear regression.

== A non-normal example: the sample maximum

#theorem(title: "Maximum of uniform samples")[
  Let $X_1, dots, X_n$ be #iid Uniform($0, theta$) and $M = max_i X_i$. Then $PP(M <= m) = (m slash theta)^n$ for $0 <= m <= theta$, with density $n m^(n-1) slash theta^n$, $EE[M] = n theta slash (n+1)$, and $(n+1) M slash n$ is unbiased for $theta$.
]
#proof[
  $M <= m$ iff every $X_i <= m$, so by independence $PP(M <= m) = (m slash theta)^n$. Differentiating gives the density, and $EE[M] = integral_0^theta m dot n m^(n-1) slash theta^n dif m = n theta slash (n+1)$.
]

The sampling distribution of $M$ is concentrated against the boundary $theta$ and is far from normal, so normal-theory intervals do not apply: sampling distributions must be derived for the statistic actually used.

== Simulation and the bootstrap

Any sampling distribution can be approximated by simulation: draw $B$ samples from the assumed model, compute $T$ on each, and use the empirical distribution of $T_1, dots, T_B$; by the law of large numbers its mean and standard deviation converge to $EE[T]$ and $se(T)$ as $B -> infinity$.

When the model is unknown, the bootstrap replaces the unknown distribution $F$ by the empirical distribution $hat(F)_n$, which puts mass $1 slash n$ on each observation. Resample $n$ observations with replacement, compute $T^*_b$, repeat for $b = 1, dots, B$, and estimate $se(T)$ by the standard deviation of the $T^*_b$. It is consistent for smooth statistics such as the mean; it fails for extreme statistics such as the maximum in the previous example.

= Point estimation

This part uses the probability toolkit (axioms, expectation and variance rules, limit theorems, Slutsky) and the sampling distributions of the mean and variance, the $chi^2$, $t$ and $F$ laws, from the chapters above. They are quoted without proof.

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

- G. Casella and R. L. Berger, _Statistical Inference_, 2nd ed., Duxbury, 2002: the standard source for the probability and distribution theory (chapters 1 to 5) and for the proofs of the Cramér–Rao bound, the MLE asymptotics and the Neyman–Pearson lemma.
- J. L. Devore, _Probability and Statistics for Engineering and the Sciences_, Cengage, 2011: the course text for the first part of the syllabus (chapters 1 to 6).
- L. Wasserman, _All of Statistics_, Springer, 2004: concise statements of the limit theorems, the bootstrap, MLE and multiple testing.
- B. Efron and R. J. Tibshirani, _An Introduction to the Bootstrap_, Chapman and Hall, 1993.
- Y. Benjamini and Y. Hochberg, "Controlling the false discovery rate", _J. R. Statist. Soc. B_ 57 (1995).
