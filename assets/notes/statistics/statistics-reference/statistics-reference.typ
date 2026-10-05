// Technical reference for the Statistics and Statistical Learning course (`_notes/statistics/`).
// One document covers all of its notes: the site pages explain and stay short, this
// reference states the results precisely and proves the ones an exam is likely to ask for.
// Style, environments and figures come from assets/notes/_typst/note-style.typ; the rules
// for adding to it are in .claude/skills/write-typst-reference/.
#import "../../_typst/note-style.typ": *

#show: reference.with(
  title: "Statistics and Statistical Learning",
  subtitle: "Technical reference",
  abstract: [Probability, standard random variables, sampling distributions, estimation, intervals and tests, with proofs. Each chapter says which site note explains it; the last chapter collects the formulas.],
  site: "https://lorenzoliuzzo.github.io/notes/",
)

#let notes = "https://lorenzoliuzzo.github.io/notes/statistics/"
#let argmin = math.op("arg min", limits: true)
#let col = math.op("col")
#let corr = math.op("corr")

= Probability toolkit

#notes-line(notes, ("Probability Foundations", "probability-foundations"), ("Random Variables, Expectation and Variance", "random-variables"))

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

#theorem(title: "Inclusion–exclusion for three events")[
  $PP(A union B union C) = PP(A) + PP(B) + PP(C) - PP(A inter B) - PP(A inter C) - PP(B inter C) + PP(A inter B inter C)$.
]
#proof[
  Apply (v) to $A union B$ and $C$: $PP(A union B union C) = PP(A union B) + PP(C) - PP((A union B) inter C)$. Expand $PP(A union B)$ by (v) and use the distributive law $(A union B) inter C = (A inter C) union (B inter C)$, whose intersection is $A inter B inter C$, so by (v) again $PP((A union B) inter C) = PP(A inter C) + PP(B inter C) - PP(A inter B inter C)$. Substituting gives the formula.
]

#remark[
  The axioms do not fix the probabilities: for one coin toss, $PP("H") = p$, $PP("T") = 1-p$ satisfies (A1)–(A3) for every $p in [0,1]$. Values come from symmetry (equally likely outcomes, $PP(A) = N(A) slash N$, hence counting with the product rule, permutations $n! slash (n-k)!$ and combinations $binom(n,k)$), from long-run relative frequency, or from belief. Under the frequentist reading $PP(A)$ is the limit of $n(A) slash n$, which the law of large numbers makes precise; under the subjective reading it is a degree of belief given available information.
]

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


#fig("/statistics/figures/bayes-frequencies.svg", caption: [The same test counted in people. The sick are a thin sliver of the population, so the 10% of healthy people who test positive outnumber the true cases about ten to one.])

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


#fig("/statistics/figures/clt.svg", caption: [Standardized mean of $n$ exponential variables against the standard normal density. At $n = 2$ the skew is obvious, by $n = 30$ the two curves are hard to tell apart.])

#rule[$n >= 30$ is a guide, not a theorem: the Berry–Esseen bound grows with skewness, and for heavy-tailed data it takes far more.]

#theorem(title: "Slutsky and delta method")[
  If $A_n cd A$ and $B_n cp b$ (constant), then $A_n + B_n cd A + b$ and $A_n B_n cd b A$. If moreover $sqrt(n)(T_n - theta) cd cal(N)(0, tau^2)$ and $g$ is differentiable at $theta$ with $g'(theta) != 0$, then
  $ sqrt(n) (g(T_n) - g(theta)) cd cal(N)(0, g'(theta)^2 tau^2). $
]
Slutsky is what licenses replacing an unknown $sigma$ by a consistent estimate in a pivot, which is how the Wald and large-sample $t$ intervals are justified.

= Discrete random variables

#notes-line(notes, ("Common Random Variables", "common-random-variables"))

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

== Hypergeometric and negative binomial

#definition[
  Sampling $n$ items without replacement from $N$ items of which $M$ are successes, the number of successes has $PP(X = x) = binom(M,x) binom(N-M,n-x) slash binom(N,n)$ (the hypergeometric law). The number $X$ of failures before the $r$-th success in independent $"Bernoulli"(p)$ trials has $PP(X = x) = binom(x+r-1, r-1) p^r (1-p)^x$ (negative binomial).
]

#theorem(title: "Moments")[
  Hypergeometric: $EE[X] = n M slash N$ and $Var(X) = (N-n) slash (N-1) dot n (M slash N)(1 - M slash N)$. Negative binomial: $EE[X] = r(1-p) slash p$ and $Var(X) = r(1-p) slash p^2$.
]
#proof[
  Hypergeometric: write $X = sum_(i=1)^n I_i$ with $I_i$ the indicator that draw $i$ is a success. By symmetry each $PP(I_i = 1) = M slash N$, so $EE[X] = n M slash N$ by linearity. For $i != j$, $PP(I_i = I_j = 1) = M(M-1) slash (N(N-1))$, so $Cov(I_i, I_j) = M(M-1) slash (N(N-1)) - (M slash N)^2 = - (M slash N)(1 - M slash N) slash (N-1)$. Then $Var(X) = n p(1-p) + n(n-1) Cov = n p(1-p)[1 - (n-1) slash (N-1)]$ with $p = M slash N$, which equals the stated formula. Negative binomial: the pmf counts arrangements of the first $r-1$ successes among the first $x + r - 1$ trials, the last trial being the $r$-th success. $X$ is a sum of $r$ independent copies of "failures before a success", each with mean $(1-p) slash p$ and variance $(1-p) slash p^2$ (the geometric shifted by one), giving the moments by linearity and independence.
]

#remark[
  When $n slash N -> 0$ the finite-population correction $(N-n) slash (N-1) -> 1$ and the hypergeometric approaches $"Binomial"(n, M slash N)$; the negative binomial has variance larger than its mean, which is why it models overdispersed counts.
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


#fig("/statistics/figures/poisson-limit.svg", caption: [Binomial bars with the Poisson of the same mean $lambda = 2$ on top. With $n = 10$ they differ visibly, with $n = 100$ they nearly coincide.])

#theorem(title: "The Poisson process")[
  Suppose counts in disjoint intervals are independent and, in an interval of length $Delta t$, one event occurs with probability $alpha Delta t + o(Delta t)$ and two or more with probability $o(Delta t)$. Then the number of events in $[0, t]$ is $"Poisson"(alpha t)$, and the waiting time to the first event is $"Exponential"(alpha)$.
]
#proof[
  Let $P_k(t)$ be the probability of $k$ events in $[0,t]$. Conditioning on what happens in $(t, t + Delta t]$ gives $P_0(t + Delta t) = P_0(t)(1 - alpha Delta t) + o(Delta t)$ and $P_k(t + Delta t) = P_k(t)(1 - alpha Delta t) + P_(k-1)(t) alpha Delta t + o(Delta t)$. Letting $Delta t -> 0$: $P_0' = -alpha P_0$ and $P_k' = -alpha P_k + alpha P_(k-1)$, with $P_0(0) = 1$ and $P_k(0) = 0$. The first equation gives $P_0(t) = e^(-alpha t)$; if $P_(k-1)(t) = e^(-alpha t) (alpha t)^(k-1) slash (k-1)!$, then $(e^(alpha t) P_k)' = alpha e^(alpha t) P_(k-1) = alpha^k t^(k-1) slash (k-1)!$, so $P_k(t) = e^(-alpha t) (alpha t)^k slash k!$ by induction. The first event time $T$ satisfies $PP(T > t) = P_0(t) = e^(-alpha t)$.
]

= Continuous random variables

#notes-line(notes, ("Common Random Variables", "common-random-variables"))

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


#fig("/statistics/figures/normal-rule.svg", caption: [The 68, 95 and 99.7 percent rule.], width: 52%)

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

#notes-line(notes, ("Sampling Distributions", "sampling-distributions"))

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


#fig("/statistics/figures/t-vs-normal.svg", caption: [Left, the whole density: the normal and two $t$ curves look alike. Right, the right tail magnified: the $t$ puts more mass out there, so its critical value is larger and its intervals are wider.])

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

#notes-line(notes, ("Point Estimation and Maximum Likelihood", "point-estimation"))

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

#notes-line(notes, ("Point Estimation and Maximum Likelihood", "point-estimation"))

#definition[
  The likelihood is $L(theta) = product_(i=1)^n f(x_i; theta)$, the log-likelihood $ell(theta) = log L(theta)$ and the maximum likelihood estimator $hat(theta)_"MLE" = argmax_theta ell(theta)$.
]


#fig("/statistics/figures/likelihood.svg", caption: [Likelihood of a success probability for the same observed proportion at two sample sizes, each scaled to peak at 1. The maximizer is the same; the curvature at the peak, which is the Fisher information, grows with $n$.])

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

#notes-line(notes, ("Confidence Intervals", "confidence-intervals"))

#definition[
  A $(1-alpha)$ confidence interval is a random interval $[L(X), U(X)]$ with $PP_theta (L(X) <= theta <= U(X)) >= 1 - alpha$ for all $theta in Theta$. The left side is the coverage; the inequality is replaced by an equality for exact intervals.
]

The probability refers to the random endpoints under repeated sampling. For the realized interval, $theta$ is fixed and the event either holds or not.


#fig("/statistics/figures/coverage.svg", caption: [Twenty independent samples, each with its own 95% interval for the same true mean. The intervals vary, the truth does not; about one in twenty misses, here the orange one.])

#trap[The 95% describes the procedure, not the one interval you computed: it is not the probability that $theta$ lies inside it.]

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

#notes-line(notes, ("Hypothesis Tests", "hypothesis-tests"))

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


#fig("/statistics/figures/power.svg", caption: [One-sided $z$-test at $alpha = 0.05$ when the true mean is $2.2$ standard errors above the null. The blue sliver beyond the line is the Type I error rate, the orange area to its right is the power, and the orange area to its left is the Type II error rate.])

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

= Linear regression

#notes-line(notes, ("Linear Regression", "linear-regression"), ("Regression Diagnostics and Leverage", "regression-diagnostics"))

This chapter uses expectation, variance and covariance of random vectors, the multivariate linear map rule $Var(A Y) = A thin Var(Y) thin A^top$, and the $chi^2$, $t$ and $F$ laws, all from the chapters above.

== The model and least squares

Observe $bold(y) in RR^n$ and a fixed design matrix $X in RR^(n times p)$ of full column rank, usually with a column of ones. The linear model is
$ bold(y) = X beta + bold(epsilon.alt), quad EE bold(epsilon.alt) = 0, quad Var(bold(epsilon.alt)) = sigma^2 I_n. $

#definition(title: "Least squares", id: "least-squares")[
  $hat(beta) = argmin_beta norm(bold(y) - X beta)^2$, and the residual sum of squares is $"RSS" = norm(bold(y) - X hat(beta))^2$.
]

#theorem(title: "Normal equations")[
  $hat(beta)$ is the unique solution of $X^top X hat(beta) = X^top bold(y)$, that is $hat(beta) = (X^top X)^(-1) X^top bold(y)$.
]
#proof[
  $X^top X$ is invertible because $X$ has full column rank. Put $bold(e) = bold(y) - X hat(beta)$ with $hat(beta)$ the stated solution, so $X^top bold(e) = 0$. For any $beta$, $bold(y) - X beta = bold(e) + X(hat(beta) - beta)$ and the two parts are orthogonal, hence $norm(bold(y) - X beta)^2 = norm(bold(e))^2 + norm(X(hat(beta) - beta))^2$, which is smallest, and only, at $beta = hat(beta)$.
]

#definition(title: "Hat matrix", id: "hat-matrix")[
  $H = X (X^top X)^(-1) X^top$, so that $hat(bold(y)) = H bold(y)$ and $bold(e) = (I - H) bold(y)$.
]

#lemma(title: "Projection")[
  $H$ is symmetric and idempotent, $H X = X$, and $"tr" H = p$. Hence $H$ is the orthogonal projection onto $col(X)$ and $I - H$ the projection onto its complement, of rank $n - p$. In particular $X^top bold(e) = 0$, and if $X$ has an intercept column, $sum_i e_i = 0$.
]
#proof[
  Symmetry and $H^2 = X (X^top X)^(-1) X^top X (X^top X)^(-1) X^top = H$ are direct, and $H X = X$ follows by cancelling. The trace of an idempotent matrix is its rank, and $"tr" H = "tr"((X^top X)^(-1) X^top X) = "tr" I_p = p$. Then $X^top (I - H) = 0$; the intercept column gives $bold(1)^top bold(e) = 0$.
]

#lemma(title: "Moments of the estimates")[
  $EE hat(beta) = beta$, $Var(hat(beta)) = sigma^2 (X^top X)^(-1)$, $EE bold(e) = 0$, $Var(bold(e)) = sigma^2 (I - H)$, and $s^2 = "RSS" slash (n - p)$ is unbiased for $sigma^2$.
]
#proof[
  $hat(beta) = A bold(y)$ with $A = (X^top X)^(-1) X^top$ and $A X = I$, so $EE hat(beta) = beta$, and $A A^top = (X^top X)^(-1)$ gives the variance. Also $bold(e) = (I - H) bold(epsilon.alt)$, so $Var(bold(e)) = sigma^2 (I - H)^2 = sigma^2 (I - H)$. Then $EE norm(bold(e))^2 = "tr" Var(bold(e)) = sigma^2 (n - p)$.
]

#theorem(title: "Gauss–Markov", id: "gauss-markov")[
  Among all linear unbiased estimators $bold(a)^top bold(y)$ of $bold(c)^top beta$, the least squares estimator $bold(c)^top hat(beta)$ has the smallest variance.
]
#proof[
  Unbiasedness for every $beta$ means $bold(a)^top X = bold(c)^top$. Write $bold(a) = X (X^top X)^(-1) bold(c) + bold(d)$; then $bold(d)^top X = 0$. The two parts of $bold(a)$ are orthogonal, so $Var(bold(a)^top bold(y)) = sigma^2 (norm(X (X^top X)^(-1) bold(c))^2 + norm(bold(d))^2) >= sigma^2 bold(c)^top (X^top X)^(-1) bold(c) = Var(bold(c)^top hat(beta))$.
]

#fig("/statistics/figures/ols-geometry.svg", caption: [Least squares as a projection. The fitted vector $hat(bold(y))$ is the point of $col(X)$ nearest to $bold(y)$, the residual is orthogonal to every column, and the coefficients are the coordinates of $hat(bold(y))$ in the columns.], width: 86%)

== Normal errors and inference

#theorem(title: "Sampling distributions", id: "coefficient-inference")[
  If in addition $bold(epsilon.alt) tilde.op cal(N)(0, sigma^2 I)$, then $hat(beta) tilde.op cal(N)(beta, sigma^2 (X^top X)^(-1))$, $(n - p) s^2 slash sigma^2 tilde.op chi^2_(n-p)$, and $hat(beta)$ is independent of $s^2$. Under these assumptions $hat(beta)$ is also the maximum likelihood estimator, and the MLE of $sigma^2$ is $"RSS" slash n$.
]
#proof[
  $hat(beta)$ and $bold(e)$ are linear in $bold(y)$, hence jointly normal, with $Cov(hat(beta), bold(e)) = sigma^2 A (I - H) = 0$ since $A H = A$; uncorrelated jointly normal vectors are independent. In an orthonormal basis whose last $n - p$ vectors span $col(X)^perp$, $norm(bold(e))^2 slash sigma^2$ is the sum of the squares of the last $n - p$ coordinates of $bold(epsilon.alt) slash sigma$, which are i.i.d. $cal(N)(0,1)$. The likelihood is maximized in $beta$ by minimizing $norm(bold(y) - X beta)^2$.
]

#theorem(title: [$t$ statistics and intervals])[
  Under normal errors, with $hat("se")(hat(beta)_j) = s sqrt([(X^top X)^(-1)]_(j j))$,
  $ (hat(beta)_j - beta_j) slash hat("se")(hat(beta)_j) tilde.op t_(n-p). $
  The interval $hat(beta)_j plus.minus t_(n-p, 1-alpha slash 2) hat("se")(hat(beta)_j)$ has coverage $1 - alpha$, and the $t$-test of $beta_j = 0$ rejects when $|hat(beta)_j| slash hat("se")$ exceeds the same quantile. At a new point $bold(x)_0$ the mean response $bold(x)_0^top beta$ has variance $sigma^2 bold(x)_0^top (X^top X)^(-1) bold(x)_0$ for its estimate, while a new observation is predicted with error variance $sigma^2 (1 + bold(x)_0^top (X^top X)^(-1) bold(x)_0)$.
]
#proof[
  Standardize the normal $hat(beta)_j$ and divide by the independent $sqrt(chi^2_(n-p) slash (n-p))$: this is the definition of $t_(n-p)$. The prediction variance adds the variance $sigma^2$ of the new error to that of $bold(x)_0^top hat(beta)$.
]

== Sums of squares and the $F$-test

#definition(title: [Sums of squares and $R^2$], id: "r-squared")[
  $"SST" = sum_i (y_i - overline(y))^2$, $"SSR" = sum_i (hat(y)_i - overline(y))^2$, $"SSE" = "RSS"$, and $R^2 = "SSR" slash "SST"$. The adjusted version is $1 - ("SSE" slash (n-p)) slash ("SST" slash (n-1))$.
]

#theorem(title: "Decomposition")[
  With an intercept, $"SST" = "SSR" + "SSE"$, and $R^2 = op("corr")(bold(y), hat(bold(y)))^2 = 1 - "SSE" slash "SST"$.
]
#proof[
  $bold(y) - overline(y) bold(1) = (hat(bold(y)) - overline(y) bold(1)) + bold(e)$, the first part lies in $col(X)$ (it contains $bold(1)$) and $bold(e)$ is orthogonal to it, so Pythagoras applies. Moreover $sum_i (y_i - overline(y))(hat(y)_i - overline(y)) = "SSR" + sum_i e_i (hat(y)_i - overline(y)) = "SSR"$, so the squared correlation is $"SSR"^2 slash ("SST" dot "SSR")$, the same ratio.
]

#theorem(title: [$F$-test of nested models], id: "anova-f-test")[
  Let the reduced model with $p - q$ parameters have column space inside $col(X)$ and residual sum of squares $"SSE"_0 >= "SSE"$. Under normal errors and the reduced model,
  $ F = (("SSE"_0 - "SSE") slash q) / ("SSE" slash (n - p)) tilde.op F_(q, n-p). $
  The overall test of "no predictor matters" has $q = p - 1$ and $F = ("SSR" slash (p-1)) slash ("SSE" slash (n-p))$. For $q = 1$, $F = t^2$ for the corresponding coefficient.
]
#proof[
  $"SSE"_0 - "SSE" = norm((H - H_0) bold(y))^2$ where $H_0$ projects onto the smaller space, and $H - H_0$ is a projection of rank $q$ orthogonal to $I - H$. Under the reduced model $(H - H_0) bold(y) = (H - H_0) bold(epsilon.alt)$, so the two sums of squares divided by $sigma^2$ are independent $chi^2_q$ and $chi^2_(n-p)$.
]

#formulas(("Source", "Sum of squares", "df and mean square"),
  [Regression], [$"SSR"$], [$p - 1$, $"SSR" slash (p - 1)$],
  [Residual], [$"SSE"$], [$n - p$, $s^2 = "SSE" slash (n - p)$],
  [Total], [$"SST"$], [$n - 1$],
)

== Leverage, influence and collinearity

#lemma(title: "Leverage", id: "leverage")[
  Let $h_(i i) = bold(x)_i^top (X^top X)^(-1) bold(x)_i$ be the diagonal of $H$. Then $Var(e_i) = sigma^2 (1 - h_(i i))$, $sum_i h_(i i) = p$, $0 <= h_(i i) <= 1$, and $h_(i i) >= 1 slash n$ with an intercept. In simple regression $h_(i i) = 1 slash n + (x_i - overline(x))^2 slash S_(x x)$. The fitted value is $hat(y)_i = h_(i i) y_i + sum_(j != i) h_(i j) y_j$.
]
#proof[
  The variance is the diagonal of $sigma^2 (I - H)$ and the trace is $"tr" H = p$. From $H^2 = H$, $h_(i i) = sum_j h_(i j)^2 >= h_(i i)^2$, so $h_(i i) in [0, 1]$. If $bold(1) in col(X)$ then $H - bold(1) bold(1)^top slash n$ is again a projection, so its diagonal is nonnegative.
]

#definition(title: "Studentized residuals", id: "studentized-residual")[
  The internally studentized residual is $r_i = e_i slash (s sqrt(1 - h_(i i)))$. The externally studentized residual replaces $s$ by $s_((i))$, computed without observation $i$; under normal errors it has a $t_(n-p-1)$ distribution.
]

#lemma(title: "Deleting one observation")[
  With $M = X^top X$ and $hat(beta)_((i))$ the estimate without observation $i$,
  $ hat(beta) - hat(beta)_((i)) = (M^(-1) bold(x)_i e_i) / (1 - h_(i i)), quad y_i - bold(x)_i^top hat(beta)_((i)) = e_i / (1 - h_(i i)). $
]
#proof[
  By Sherman–Morrison, $(M - bold(x)_i bold(x)_i^top)^(-1) = M^(-1) + M^(-1) bold(x)_i bold(x)_i^top M^(-1) slash (1 - h_(i i))$, and the deleted cross-product is $X^top bold(y) - bold(x)_i y_i$. Multiplying out, $hat(beta)_((i)) = hat(beta) - M^(-1) bold(x)_i y_i + M^(-1) bold(x)_i (hat(y)_i - h_(i i) y_i) slash (1 - h_(i i)) = hat(beta) - M^(-1) bold(x)_i e_i slash (1 - h_(i i))$. For the second identity, $y_i - bold(x)_i^top hat(beta)_((i)) = e_i + h_(i i) e_i slash (1 - h_(i i))$.
]

#definition(title: "Cook's distance", id: "cooks-distance")[
  $D_i = (hat(beta) - hat(beta)_((i)))^top X^top X (hat(beta) - hat(beta)_((i))) slash (p s^2) = norm(hat(bold(y)) - hat(bold(y))_((i)))^2 slash (p s^2)$.
]

#theorem(title: "Cook's distance, closed form")[
  $D_i = r_i^2 / p dot h_(i i) / (1 - h_(i i))$.
]
#proof[
  Substitute the deletion formula: $D_i = e_i^2 bold(x)_i^top M^(-1) M M^(-1) bold(x)_i slash ((1 - h_(i i))^2 p s^2) = e_i^2 h_(i i) slash (p s^2 (1 - h_(i i))^2)$, which is the stated product.
]

#remark[
  The second identity of the deletion lemma gives the leave-one-out residuals without refitting, $"PRESS" = sum_i (e_i slash (1 - h_(i i)))^2$. Common flags are $h_(i i) > 2 p slash n$ and $D_i > 4 slash n$ (or $> 1$); they are screening devices, not tests.
]

#theorem(title: "Variance inflation", id: "multicollinearity")[
  Let $R_j^2$ be the $R^2$ of the regression of column $j$ on the other columns, and $S_(j j) = sum_i (x_(i j) - overline(x)_j)^2$. Then
  $ Var(hat(beta)_j) = sigma^2 / ((1 - R_j^2) S_(j j)) = "VIF"_j dot sigma^2 / S_(j j), quad "VIF"_j = 1 / (1 - R_j^2). $
]
#proof[
  Let $M_(-j)$ be the projection onto $col(X_(-j))^perp$ and $tilde(bold(x))_j = M_(-j) bold(x)_j$. Applying $M_(-j)$ to $bold(y) = hat(bold(y)) + bold(e)$ kills the other columns and fixes $bold(e)$, so $M_(-j) bold(y) = tilde(bold(x))_j hat(beta)_j + bold(e)$ and, since $bold(e) perp tilde(bold(x))_j$, $hat(beta)_j = tilde(bold(x))_j^top bold(y) slash norm(tilde(bold(x))_j)^2$ (Frisch–Waugh–Lovell). Then $Var(hat(beta)_j) = sigma^2 slash norm(tilde(bold(x))_j)^2$, and $norm(tilde(bold(x))_j)^2 = (1 - R_j^2) S_(j j)$ is the residual sum of squares of that auxiliary regression.
]

#fig("/statistics/figures/leverage-influence.svg", caption: [The same vertical outlier in the middle and at the edge of the $x$ range. Dashed: fit without it; solid: fit with it. Leverage, not the size of the residual alone, decides how far the line moves.])

= Regularization

#notes-line(notes, ("Regularization: Ridge and Lasso", "regularization"))

Notation as in the previous chapter; the columns of $X$ are centred and scaled, the intercept is not penalized, and $lambda >= 0$ is the penalty weight.

== Prediction error and the trade-off

#theorem(title: "Bias–variance decomposition of prediction error", id: "bias-variance-tradeoff")[
  Let $y_0 = f(bold(x)_0) + epsilon.alt_0$ be a new observation, independent of the training data, with $EE epsilon.alt_0 = 0$ and $Var(epsilon.alt_0) = sigma^2$, and let $hat(f)$ be fitted on the training data. Then
  $ EE[(y_0 - hat(f)(bold(x)_0))^2] = sigma^2 + (EE hat(f)(bold(x)_0) - f(bold(x)_0))^2 + Var(hat(f)(bold(x)_0)). $
]
#proof[
  Write $y_0 - hat(f) = epsilon.alt_0 + (f - EE hat(f)) + (EE hat(f) - hat(f))$. The three terms are independent of each other or have zero mean, so the cross terms vanish, and squaring gives irreducible noise, squared bias and variance.
]

== Ridge regression

#definition(title: "Ridge regression", id: "ridge-regression")[
  $hat(beta)_lambda = argmin_beta norm(bold(y) - X beta)^2 + lambda norm(beta)^2 = (X^top X + lambda I)^(-1) X^top bold(y)$.
]

With the singular value decomposition $X = U D V^top$ and singular values $d_1 >= dots >= d_p > 0$, in the coordinates $gamma = V^top beta$ the estimate shrinks each least squares coordinate by a factor,
$ hat(gamma)_(lambda, j) = d_j^2 / (d_j^2 + lambda) hat(gamma)_j. $
The fitted values are $hat(bold(y))_lambda = H_lambda bold(y)$ with $H_lambda = X (X^top X + lambda I)^(-1) X^top$.

#definition(title: "Effective degrees of freedom", id: "effective-degrees-of-freedom")[
  For a linear fit $hat(bold(y)) = S bold(y)$ the effective degrees of freedom are $"df" = "tr" S$. For ridge, $"df"(lambda) = sum_j d_j^2 slash (d_j^2 + lambda)$, decreasing from $p$ at $lambda = 0$ to $0$.
]

#theorem(title: "Ridge can beat least squares")[
  The coordinate $j$ of the ridge estimate has mean squared error
  $ "MSE"_j (lambda) = (sigma^2 d_j^2 + lambda^2 gamma_j^2) / (d_j^2 + lambda)^2, $
  and $"MSE"_j'(0) = -2 sigma^2 slash d_j^4 < 0$. Hence for every true $beta$ there is $lambda > 0$ at which the total $EE norm(hat(beta)_lambda - beta)^2$ is smaller than that of least squares.
]
#proof[
  By the moment lemma, $hat(gamma)_j$ has mean $gamma_j$ and variance $sigma^2 slash d_j^2$. Scaling by $d_j^2 slash (d_j^2 + lambda)$ gives variance $sigma^2 d_j^2 slash (d_j^2 + lambda)^2$ and bias $-lambda gamma_j slash (d_j^2 + lambda)$. Differentiate the sum at $lambda = 0$, where the numerator's derivative vanishes.
]

#remark[
  Ridge is the posterior mean, and mode, under $y mid(|) beta tilde.op cal(N)(X beta, sigma^2 I)$ and prior $beta tilde.op cal(N)(0, tau^2 I)$ with $lambda = sigma^2 slash tau^2$, because $-2 sigma^2 log "posterior" = norm(bold(y) - X beta)^2 + (sigma^2 slash tau^2) norm(beta)^2 + "const"$.
]

== Lasso

#definition(title: "Lasso", id: "lasso")[
  $hat(beta)_lambda = argmin_beta 1/2 norm(bold(y) - X beta)^2 + lambda norm(beta)_1$.
]

The problem is convex, so a minimizer exists, but it need not be unique unless the columns are in general position. Subgradient optimality gives the conditions below.

#theorem(title: "Optimality conditions and soft-thresholding", id: "soft-thresholding")[
  $hat(beta)$ is a minimizer iff, for every $j$, $X_j^top (bold(y) - X hat(beta)) = lambda "sign"(hat(beta)_j)$ if $hat(beta)_j != 0$, and $|X_j^top (bold(y) - X hat(beta))| <= lambda$ if $hat(beta)_j = 0$. In particular $hat(beta) = 0$ iff $lambda >= norm(X^top bold(y))_infinity$. If $X^top X = I$, with $b_j$ the least squares coefficients,
  $ hat(beta)_(lambda, j) = "sign"(b_j) (|b_j| - lambda)_+. $
]
#proof[
  The objective is convex, so $0$ must lie in the subdifferential $-X^top (bold(y) - X beta) + lambda partial norm(beta)_1$, which is the stated pair of conditions. For $X^top X = I$ the objective separates into $1/2 (b_j - beta_j)^2 + lambda |beta_j|$ plus a constant; setting the subgradient to zero gives $beta_j = b_j - lambda "sign"(beta_j)$ when this has the sign of $b_j$, and $beta_j = 0$ when $|b_j| <= lambda$.
]

#formulas(("Rule", "Penalty", "Estimate for orthonormal columns"),
  [Least squares], [none], [$b_j$],
  [Ridge], [$lambda norm(beta)^2$], [$b_j slash (1 + lambda)$],
  [Lasso], [$lambda norm(beta)_1$], [$"sign"(b_j) (|b_j| - lambda)_+$],
  [Best subset], [$lambda norm(beta)_0$ (with $1/2 norm(bold(y) - X beta)^2$)], [$b_j bb(1){|b_j| > sqrt(2 lambda)}$],
)

#remark[
  The lasso solution has at most $min(n, p)$ nonzero coefficients. It is the MAP estimate under independent Laplace priors. The elastic net adds the ridge term, $1/2 norm(bold(y) - X beta)^2 + lambda (alpha norm(beta)_1 + (1 - alpha) / 2 norm(beta)^2)$, which keeps the sparsity and spreads weight over correlated predictors. $lambda$ is chosen by cross-validation, over a grid starting from $norm(X^top bold(y))_infinity$.
]

#fig("/statistics/figures/shrinkage-functions.svg", caption: [With orthonormal predictors the three penalties are three functions of the least squares coefficient: proportional shrinkage (ridge), soft thresholding (lasso) and hard thresholding (best subset).])

#fig("/statistics/figures/penalty-geometry.svg", caption: [Elliptical contours of the residual sum of squares around the least squares estimate meet the constraint region. The disc has no corners, so ridge lands in the open; the diamond has corners on the axes, where a coefficient is exactly zero.])

= Splines and additive models

#notes-line(notes, ("Regression and Smoothing Splines", "splines"), ("GAMs and MARS", "gam-mars"))

== Basis expansions and regression splines

#definition(title: "Basis expansion", id: "basis-expansion")[
  $f(x) = sum_(m=1)^M beta_m h_m(x)$ for fixed functions $h_m$. The model is linear in $beta$, so everything in the linear regression chapter applies with $X_(i m) = h_m(x_i)$.
]

#definition(title: "Cubic spline", id: "regression-spline")[
  With knots $xi_1 < dots < xi_K$, a cubic spline is a piecewise cubic polynomial that is twice continuously differentiable at every knot. A natural cubic spline is in addition linear on $(-infinity, xi_1]$ and $[xi_K, infinity)$.
]

#theorem(title: "Dimension and bases")[
  The cubic splines with knots $xi_1, dots, xi_K$ form a vector space of dimension $K + 4$ with the truncated power basis $1, x, x^2, x^3, (x - xi_k)_+^3$ for $k = 1, dots, K$. The natural cubic splines form a subspace of dimension $K$ (for $K >= 2$).
]
#proof[
  A twice differentiable gluing at $xi_k$ allows a jump only in the third derivative, which is exactly what adding $c_k (x - xi_k)_+^3$ to a cubic does, and every spline has this form. Requiring zero second and third derivative on each of the two outer intervals gives four independent linear conditions on the $K + 4$ coefficients, leaving $K$.
]

#fig("/statistics/figures/regression-spline.svg", caption: [A cubic polynomial and a cubic spline with three knots fitted to the same noisy data. The spline has seven parameters and follows the curve; the global polynomial cannot.])

== Smoothing splines

#definition(title: "Smoothing spline", id: "smoothing-spline")[
  For $lambda > 0$, $hat(f) = argmin_f sum_i (y_i - f(x_i))^2 + lambda integral f''(t)^2 dif t$ over twice differentiable $f$ with $f''$ square integrable.
]

#theorem(title: "Reinsch")[
  For distinct $x_1 < dots < x_n$ the minimizer is the natural cubic spline with knots at the $x_i$, and its values at the knots are $hat(bold(f)) = (I + lambda K)^(-1) bold(y)$, where $K$ is the positive semidefinite matrix with $integral f''^2 = bold(f)^top K bold(f)$ for the natural spline through $bold(f)$.
]
#proof[
  Let $g$ be any admissible function and $f$ the natural cubic spline with $f(x_i) = g(x_i)$. Put $h = g - f$, so $h(x_i) = 0$. Integrating by parts twice, $integral f'' h'' = [f'' h']_(x_1)^(x_n) - integral f''' h' = - sum_i f'''(x_i^+) (h(x_(i+1)) - h(x_i)) = 0$, using $f'' = 0$ outside $[x_1, x_n]$, $f'''$ piecewise constant and $h$ vanishing at the knots. Hence $integral g''^2 = integral f''^2 + integral h''^2 >= integral f''^2$, with equality only for $h'' = 0$, i.e. $g = f$. The fit terms agree, so the minimum is over natural splines, where the criterion is $norm(bold(y) - bold(f))^2 + lambda bold(f)^top K bold(f)$, minimized at the stated $hat(bold(f))$.
]

#definition(title: "Linear smoother", id: "linear-smoother")[
  A fit of the form $hat(bold(y)) = S bold(y)$. For the smoothing spline $S_lambda = (I + lambda K)^(-1)$ is symmetric with eigenvalues $1 slash (1 + lambda d_k) in (0, 1]$, $d_k$ the eigenvalues of $K$; the constants and the linear functions span its null space, so two eigenvalues equal 1 for every $lambda$. Thus $"df"(lambda) = "tr" S_lambda = sum_k 1 slash (1 + lambda d_k)$ decreases from $n$ to $2$. Leave-one-out residuals obey $y_i - hat(f)_((i))(x_i) = (y_i - hat(f)(x_i)) slash (1 - S_(i i))$, and generalized cross-validation is $"GCV"(lambda) = n^(-1) sum_i (y_i - hat(f)(x_i))^2 slash (1 - "df" slash n)^2$.
]

#fig("/statistics/figures/smoothing-spline.svg", caption: [Smoothing splines fitted to the data of the previous figure at three effective degrees of freedom: nearly a straight line, close to the truth, and following the noise. The penalty $lambda$ moves the fit along this range.])

== Additive models and backfitting

#definition(title: "Additive model", id: "additive-model")[
  $EE[Y mid(|) bold(x)] = alpha + sum_(j=1)^p f_j (x_j)$ with $EE f_j (X_j) = 0$ for identifiability. The generalized additive model applies a link: $g(mu) = alpha + sum_j f_j (x_j)$.
]

The backfitting algorithm sets $hat(alpha) = overline(y)$, $f_j equiv 0$, and cycles over $j$: $f_j <- S_j (bold(y) - hat(alpha) - sum_(k != j) f_k)$, then centres $f_j$, until the functions stop changing. For symmetric smoothers with eigenvalues in $[0, 1]$, such as smoothing splines, it converges, and for smoothing splines the limit minimizes $sum_i (y_i - alpha - sum_j f_j (x_(i j)))^2 + sum_j lambda_j integral f_j''^2$ (Buja, Hastie and Tibshirani, 1989); the solution is unique unless a function of some predictors is exactly an additive function of the others (concurvity). Proof omitted.

== MARS

#definition(title: "Hinge functions and MARS", id: "mars")[
  A hinge pair at knot $t$ is $(x - t)_+$ and $(t - x)_+$, the positive parts. MARS fits $f(bold(x)) = beta_0 + sum_m beta_m B_m (bold(x))$ where each $B_m$ is a product of hinge functions of distinct variables; the degree is the number of factors allowed.
]

The forward pass starts from $B_0 = 1$ and, at each step, adds the pair $B_l (x_v - t)_+$, $B_l (t - x_v)_+$ over all existing terms $B_l$, variables $v$ and observed values $t$, choosing the one that lowers RSS most, until a maximum number of terms is reached. The backward pass removes one term at a time, each time the one whose removal raises RSS least, and the model size is chosen to minimize $"GCV" = ("RSS" slash N) slash (1 - C(M) slash N)^2$ with $C(M) = M + d K$, $K$ the number of knots retained and $d$ a fixed cost per knot, typically between 2 and 4. With degree 1 the model is additive with piecewise linear components.

#fig("/statistics/figures/hinge-basis.svg", caption: [MARS in one dimension. Right: the hinge pair at knot $t = 4$. Left: the forward pass overgrows a sum of hinges (dashed, nine terms) and the backward pass prunes it to three, with knots near the two bends of the data.])

= Robust statistics

#notes-line(notes, ("Robust Statistics", "robust-statistics"))

== Breakdown and the influence function

#definition(title: "Breakdown point", id: "breakdown-point")[
  The finite-sample breakdown point of an estimator $T$ at a sample is the smallest fraction $m slash n$ of observations that can be replaced by arbitrary values so that $T$ becomes unbounded.
]

The mean has breakdown $1 slash n$: moving one point to infinity moves the mean. The median has breakdown $ceil(n slash 2) slash n -> 1 slash 2$: fewer than half of the points cannot push both order statistics around the middle beyond the remaining ones.

#definition(title: "Influence function", id: "influence-function")[
  For a functional $T$ and distribution $F$, $"IF"(x; T, F) = lim_(epsilon -> 0) [T((1 - epsilon) F + epsilon delta_x) - T(F)] slash epsilon$, the effect on $T$ of a small contamination at $x$. For regular $T$, $sqrt(n)(T(F_n) - T(F)) cd cal(N)(0, EE["IF"^2])$ (Hampel et al., 1986), and $sup_x |"IF"|$ is the gross-error sensitivity.
]

#example(title: "Mean and median")[
  Mean: $T(F_epsilon) = (1 - epsilon) mu + epsilon x$, so $"IF" = x - mu$, unbounded. Median $m$: $F_epsilon (m_epsilon) = 1 slash 2$ means $(1 - epsilon) F(m_epsilon) + epsilon bb(1){x <= m_epsilon} = 1 slash 2$. Differentiating at $epsilon = 0$, with $F(m) = 1 slash 2$, gives $-1 slash 2 + f(m) m' + bb(1){x <= m} = 0$, so $"IF" = "sign"(x - m) slash (2 f(m))$, bounded.
]

== M-estimators

#definition(title: "M-estimator of location", id: "m-estimator")[
  $hat(theta) = argmin_theta sum_i rho(x_i - theta)$, equivalently the root of $sum_i psi(x_i - theta) = 0$ with $psi = rho'$. Scale is estimated separately, for example by $"MAD" slash 0.6745$.
]

#theorem(title: "Influence of an M-estimator")[
  At $F$ with $EE_F psi(X - theta_0) = 0$, $"IF"(x) = psi(x - theta_0) slash EE_F psi'(X - theta_0)$, and the asymptotic variance is $EE psi^2 slash (EE psi')^2$.
]
#proof[
  $theta_epsilon$ solves $g(epsilon, theta) = (1 - epsilon) EE_F psi(X - theta) + epsilon psi(x - theta) = 0$. At $(0, theta_0)$, $partial_epsilon g = psi(x - theta_0)$ and $partial_theta g = -EE_F psi'(X - theta_0)$; implicit differentiation gives $theta' = -partial_epsilon g slash partial_theta g$. The variance is $EE["IF"^2]$.
]

#formulas(("Estimator", "ψ(u)", "Influence"),
  [Mean], [$u$], [unbounded],
  [Median], [$"sign"(u)$], [bounded, jumps],
  [Huber, $k$], [$max(-k, min(k, u))$], [bounded; $k = 1.345$ gives 95% efficiency at the normal],
  [Tukey biweight, $c$], [$u (1 - (u slash c)^2)^2$ for $|u| <= c$, else $0$], [redescends to 0; $c = 4.685$ for 95% efficiency],
)

Huber's $psi$ is monotone, so $rho$ is convex and the solution is unique. The biweight is redescending: $rho$ is not convex, there can be several roots, and a robust starting value is required. Iteratively reweighted least squares solves $sum_i w_i (x_i - theta) = 0$ with weights $w_i = psi(r_i slash s) slash (r_i slash s)$, refitted until convergence; for Huber's $rho$ every step decreases the objective.

#fig("/statistics/figures/psi-functions.svg", caption: [Loss $rho$ (left) and its derivative $psi$ (right), the pull of a residual on the fit. Squared error pulls proportionally to the residual; Huber caps the pull; the biweight lets it fall back to zero for gross outliers.])

== Robust regression

An M-estimator of regression minimizes $sum_i rho(r_i (beta) slash s)$. Its influence function is proportional to $psi(r slash sigma) bold(x)$: bounded in the residual but not in $bold(x)$. A single point with extreme leverage can therefore still break it down, with breakdown point $1 slash n$. Bounded-influence (Mallows and Schweppe) estimators downweight by leverage as well. High-breakdown estimators are the least trimmed squares (LTS), which minimizes the sum of the $h$ smallest squared residuals (breakdown near $1 slash 2$ for $h approx (n + p + 1) slash 2$), and MM-estimators, which start from a high-breakdown scale and fit and then take an efficient M-step (breakdown 1/2, 95% efficiency at the normal); see Rousseeuw and Leroy (1987) and Maronna, Martin and Yohai (2019).

#fig("/statistics/figures/robust-fit.svg", caption: [Four outliers in $y$. The least squares line is drawn towards them; the Huber M-estimate stays with the bulk of the data and recovers the true slope almost exactly.])

= Summary of the main formulas

#formulas(("Quantity", "Result", "Where explained"),
  [Standard error of the mean], [$sigma slash sqrt(n)$], [#link(notes + "sampling-distributions/#the-sample-mean")[Sampling distributions]],
  [$S^2$ unbiased], [$EE S^2 = sigma^2$, divisor $n - 1$], [#link(notes + "point-estimation/#judging-an-estimator")[Point estimation]],
  [Normal sampling laws], [$(n-1) S^2 slash sigma^2 tilde.op chi^2_(n-1)$, $T tilde.op t_(n-1)$, $overline(X) perp S^2$], [#link(notes + "sampling-distributions/#sample-variance-and-the-chi-square")[Sampling distributions]],
  [MSE], [$Var + bias^2$], [#link(notes + "point-estimation/#judging-an-estimator")[Point estimation]],
  [Cramér–Rao], [$Var(hat(theta)) >= 1 slash (n I(theta))$], [#link(notes + "point-estimation/#judging-an-estimator")[Point estimation]],
  [MLE], [$sqrt(n)(hat(theta) - theta_0) cd cal(N)(0, I(theta_0)^(-1))$], [#link(notes + "point-estimation/#maximum-likelihood")[Point estimation]],
  [CI for the mean], [$overline(X) plus.minus t_(n-1, 1-alpha slash 2) S slash sqrt(n)$], [#link(notes + "confidence-intervals/")[Confidence intervals]],
  [CI for the variance], [$[(n-1) S^2 slash chi^2_(n-1, 1-alpha slash 2), (n-1) S^2 slash chi^2_(n-1, alpha slash 2)]$], [#link(notes + "confidence-intervals/")[Confidence intervals]],
  [Wald interval], [$hat(theta) plus.minus z_(1-alpha slash 2) hat(se)$], [#link(notes + "confidence-intervals/")[Confidence intervals]],
  [Sample size, one-sided $z$-test], [$n = ((z_(1-alpha) + z_(1-beta)) sigma slash delta)^2$], [#link(notes + "hypothesis-tests/#power-and-sample-size")[Hypothesis tests]],
  [Likelihood ratio], [$-2 log Lambda cd chi^2_r$], [#link(notes + "hypothesis-tests/#likelihood-ratio-tests")[Hypothesis tests]],
  [Bonferroni / BH], [$p_i <= alpha slash m$ / largest $k$ with $p_((k)) <= k alpha slash m$], [#link(notes + "hypothesis-tests/#many-tests-at-once")[Hypothesis tests]],
  [Least squares], [$hat(beta) = (X^top X)^(-1) X^top bold(y)$, $Var(hat(beta)) = sigma^2 (X^top X)^(-1)$, $s^2 = "RSS" slash (n-p)$], [#link(notes + "linear-regression/#least-squares")[Linear regression]],
  [Coefficient $t$ and interval], [$(hat(beta)_j - beta_j) slash hat("se")(hat(beta)_j) tilde.op t_(n-p)$], [#link(notes + "linear-regression/#what-the-estimates-are")[Linear regression]],
  [$R^2$ and overall $F$], [$"SSR" slash "SST"$; $F = ("SSR" slash (p-1)) slash ("SSE" slash (n-p))$], [#link(notes + "linear-regression/#is-the-model-worth-anything")[Linear regression]],
  [Leverage], [$h_(i i) = bold(x)_i^top (X^top X)^(-1) bold(x)_i$, $sum_i h_(i i) = p$], [#link(notes + "regression-diagnostics/#leverage-and-influence")[Diagnostics]],
  [Cook's distance], [$D_i = r_i^2 h_(i i) slash (p (1 - h_(i i)))$], [#link(notes + "regression-diagnostics/#leverage-and-influence")[Diagnostics]],
  [Variance inflation], [$"VIF"_j = 1 slash (1 - R_j^2)$], [#link(notes + "regression-diagnostics/#collinearity")[Diagnostics]],
  [Ridge], [$hat(beta)_lambda = (X^top X + lambda I)^(-1) X^top bold(y)$, $"df" = sum_j d_j^2 slash (d_j^2 + lambda)$], [#link(notes + "regularization/#ridge-shrinks-everything")[Regularization]],
  [Lasso, orthonormal], [$"sign"(b_j)(|b_j| - lambda)_+$], [#link(notes + "regularization/#lasso-shrinks-and-selects")[Regularization]],
  [Smoothing spline], [$hat(bold(f)) = (I + lambda K)^(-1) bold(y)$, $"df" = "tr" S_lambda$], [#link(notes + "splines/#smoothing-splines")[Splines]],
  [Cubic spline dimension], [$K + 4$ (natural: $K$)], [#link(notes + "splines/#regression-splines")[Splines]],
  [Influence of an M-estimator], [$psi(x - theta) slash EE psi'$], [#link(notes + "robust-statistics/#m-estimators")[Robust statistics]],
)

= References

- G. Casella and R. L. Berger, _Statistical Inference_, 2nd ed., Duxbury, 2002: the standard source for the probability and distribution theory (chapters 1 to 5) and for the proofs of the Cramér–Rao bound, the MLE asymptotics and the Neyman–Pearson lemma.
- J. L. Devore, _Probability and Statistics for Engineering and the Sciences_, Cengage, 2011: the course text for the first part of the syllabus (chapters 1 to 6).
- L. Wasserman, _All of Statistics_, Springer, 2004: concise statements of the limit theorems, the bootstrap, MLE and multiple testing.
- B. Efron and R. J. Tibshirani, _An Introduction to the Bootstrap_, Chapman and Hall, 1993.
- Y. Benjamini and Y. Hochberg, "Controlling the false discovery rate", _J. R. Statist. Soc. B_ 57 (1995).
- G. A. F. Seber and A. J. Lee, _Linear Regression Analysis_, 2nd ed., Wiley, 2003: the projection treatment of least squares, the $F$-test and the diagnostics.
- T. Hastie, R. Tibshirani and J. Friedman, _The Elements of Statistical Learning_, 2nd ed., Springer, 2009: ridge, lasso, splines, additive models and MARS (chapters 3, 5, 9).
- A. E. Hoerl and R. W. Kennard, "Ridge regression: biased estimation for nonorthogonal problems", _Technometrics_ 12 (1970); R. Tibshirani, "Regression shrinkage and selection via the lasso", _J. R. Statist. Soc. B_ 58 (1996).
- P. J. Green and B. W. Silverman, _Nonparametric Regression and Generalized Linear Models_, Chapman and Hall, 1994: smoothing splines and the Reinsch algorithm.
- J. H. Friedman, "Multivariate adaptive regression splines", _Annals of Statistics_ 19 (1991); A. Buja, T. Hastie and R. Tibshirani, "Linear smoothers and additive models", _Annals of Statistics_ 17 (1989).
- F. R. Hampel et al., _Robust Statistics: The Approach Based on Influence Functions_, Wiley, 1986; R. A. Maronna, R. D. Martin and V. J. Yohai, _Robust Statistics: Theory and Methods_, 2nd ed., Wiley, 2019; P. J. Rousseeuw and A. M. Leroy, _Robust Regression and Outlier Detection_, Wiley, 1987.
