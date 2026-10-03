// Technical reference for the note `_notes/statistics/sampling-distributions.md`.
// The site page explains; this document states the results precisely and proves
// the ones an exam is likely to ask for.

#set document(title: "Sampling Distributions and Common Random Variables: technical reference", author: "Lorenzo Liuzzo")
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
  #text(size: 19pt, weight: "bold")[Sampling Distributions and Common Random Variables] \
  #v(2pt)
  #text(size: 12pt)[Technical reference] \
  #v(2pt)
  #text(size: 9.5pt, fill: gray)[Companion to the note on lorenzoliuzzo.github.io. Standard random variables and the distributions of sample statistics, with derivations.]
]
#v(6pt)

#outline(indent: 1.2em, depth: 2)


= Discrete random variables

A discrete random variable has mass function $p(x) = PP(X = x)$ on a countable support, with $sum_x p(x) = 1$, $EE[X] = sum_x x p(x)$ and $Var(X) = EE[X^2] - (EE X)^2$. Probability background is in the Probability Foundations reference.

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

= References

- G. Casella and R. L. Berger, _Statistical Inference_, 2nd ed., Duxbury, 2002, chapters 3 to 5 (families of distributions, sampling distributions).
- J. L. Devore, _Probability and Statistics for Engineering and the Sciences_, Cengage, 2011, chapters 3 to 6.
- L. Wasserman, _All of Statistics_, Springer, 2004, chapters 2 to 5 and 8 (bootstrap).
- B. Efron and R. J. Tibshirani, _An Introduction to the Bootstrap_, Chapman and Hall, 1993.
