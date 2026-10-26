// Technical reference for the Neural Networks course (`_notes/ai/neural-networks/`), after Piuri's lectures.
// One document covers all of its notes: the site pages explain and stay short, this
// reference states the results precisely and proves the ones an exam is likely to ask for.
// Style, environments and figures come from assets/notes/_typst/note-style.typ; the rules
// for adding to it are in .claude/skills/write-typst-reference/.
#import "../../_typst/note-style.typ": *

#show: reference.with(
  title: "Neural Networks",
  subtitle: "Technical reference",
  abstract: [The general model of a neural network, learning tasks and their error, data representation, and threshold logic units with the delta rule, multi-layer perceptrons with universal approximation, activation functions, training and depth, with proofs. Each chapter says which site note explains it; the last chapter collects the formulas.],
  site: "https://lorenzoliuzzo.github.io/notes/",
)

#let notes = "https://lorenzoliuzzo.github.io/notes/ai/neural-networks/"
#let net = math.op("net")
#let act = math.op("act")
#let out = math.op("out")
#let ext = math.op("ext")
#let pred = math.op("pred")
#let conv = math.op("conv")

= The general model

#notes-line(notes, ("Introduction to Neural Networks", "introduction"))

== Networks, units and connections

#definition(title: "Neural network", id: "neural-network")[
  A neural network is a directed graph $G = (U, C)$ with a finite set $U$ of _units_ and a set $C subset.eq U times U$ of _connections_, together with a weight $w_(u v) in RR$ for every connection $(v, u) in C$. The set of predecessors of a unit $u$ is $pred(u) = {v : (v, u) in C}$. The units are partitioned into the input units $U_"in"$ and output units $U_"out"$, both non-empty and not necessarily disjoint, and the hidden units $U_"hid" = U without (U_"in" union U_"out")$.

  Every unit $u$ has three real state variables, the _network input_ $net_u$, the _activation_ $act_u$ and the _output_ $out_u$, and every input unit has a fourth, the _external input_ $ext_u$. Every unit has three functions, with $theta_u$ the vector of its own parameters (for example a threshold):
  $ net_u = f_"net"^((u))(w_u, "in"_u), quad act_u = f_"act"^((u))(net_u, theta_u), quad out_u = f_"out"^((u))(act_u), $
  where $w_u = (w_(u v))_(v in pred(u))$ and $"in"_u = (out_v)_(v in pred(u))$. For an input unit, $net_u = ext_u$.
]

#definition(title: "Network input function", id: "network-input-function")[
  The function $f_"net"^((u))$ of a unit. The standard choice is the weighted sum $net_u = sum_(v in pred(u)) w_(u v) out_v$; radial basis function units use a distance $d(w_u, "in"_u)$ instead. The activation and output functions are, for the standard threshold unit, a step at $theta_u$ and the identity.
]

Architectures differ by the graph and by which of the three functions they change: a distance replaces the sum in radial basis function networks, a winner-takes-all rule replaces the identity output in learning vector quantization, and in a Hopfield network $U_"in" = U_"out" = U$ and $U_"hid" = emptyset$.

== Acyclic networks

#definition(title: "Feed-forward network", id: "feed-forward-network")[
  A neural network whose graph has no directed cycle. A network with a cycle is called recurrent.
]

#lemma[
  A finite directed graph is acyclic if and only if its vertices can be numbered $u_1, dots, u_n$ so that $(u_j, u_i) in C$ implies $j < i$ (a _topological order_).
]
#proof[
  If such a numbering exists, a cycle $v_1 -> v_2 -> dots -> v_1$ would give an increasing sequence of numbers returning to its start, which is impossible. Conversely, let $G$ be acyclic. Some vertex has no predecessor: otherwise, starting anywhere and repeatedly moving to a predecessor produces, after $n + 1$ steps, a repeated vertex and therefore a cycle. Give that vertex the number 1, remove it (the rest is still acyclic) and number the remaining vertices by induction.
]

#theorem(title: "Evaluation of a feed-forward network")[
  Let the external inputs be fixed and the units be taken in a topological order. Computing for each unit in turn $net_u$, $act_u$ and $out_u$ determines every output after $|U|$ unit evaluations, and the result does not depend on which topological order is used.
]
#proof[
  By induction on the position $i$ in the order: unit $u_i$ depends only on the weights, on $theta_(u_i)$ and on the outputs of its predecessors, all of which have position below $i$ and are already determined (an input unit depends only on its external input). So the value of $out_(u_i)$ is a function of the data alone, defined by the same recursion for every topological order.
]

#remark[
  A recurrent network has no such order. After the input phase, with the external input switched off, units are recomputed whenever one of their inputs has changed, until the outputs are stable or a bound on the number of recomputations is reached. Both the outcome and whether a stable state exists can depend on the update order. For example, two units $u, v$ with $out_u := out_v$ and $out_v := 1 - out_u$ and outputs in ${0, 1}$ pass through $(0,0) -> (0,1) -> (1,1) -> (1,0) -> (0,0)$ and never stabilize.
]

#fig("/neural-networks/figures/network-graphs.svg", caption: [An acyclic graph (left) and a graph with a cycle (right). Only the first can be evaluated by a single pass in topological order.])

= Learning tasks

#notes-line(notes, ("Introduction to Neural Networks", "introduction"))

== Fixed and free tasks

#definition(title: "Fixed learning task", id: "fixed-learning-task")[
  For a network with input units $u_1, dots, u_n$ and output units $v_1, dots, v_m$, a fixed learning task is a finite set $L = {(iota^((l)), o^((l)))}_(l = 1)^N$ of training patterns, each an input vector $iota^((l)) in RR^n$ (the external inputs) and a desired output vector $o^((l)) in RR^m$. The task is solved if for every $l$ the network, given $iota^((l))$, computes $out_(v_k) = o_k^((l))$ for all $k$. It is the supervised learning task.
]

#definition(title: "Free learning task", id: "free-learning-task")[
  A free learning task is a finite set $L = {iota^((l))}$ of input vectors with no desired outputs. The outputs are chosen by the learning method, under the principle that similar inputs should produce similar outputs.
]

#definition(title: "Sum of squared errors", id: "sum-of-squared-errors")[
  The error of a network on a fixed learning task is
  $ e = sum_(l = 1)^N sum_(k = 1)^m (o_k^((l)) - out_(v_k)^((l)))^2, $
  where $out_(v_k)^((l))$ is the output of $v_k$ for input $iota^((l))$. It is non-negative, and it is zero exactly when the task is solved.
]

== The error as maximum likelihood

#theorem(title: "Squared error and Gaussian noise")[
  Suppose the desired outputs satisfy $o^((l)) = y(iota^((l)); w) + epsilon^((l))$, where $y(dot; w)$ is the function computed by the network with parameters $w$ and the $epsilon^((l))$ are independent with distribution $cal(N)(0, sigma^2 I_m)$. Then the log-likelihood of the data is
  $ ell(w, sigma^2) = -e(w) / (2 sigma^2) - (N m) / 2 log(2 pi sigma^2). $
  For every fixed $sigma^2$ it is maximized by the $w$ that minimizes $e$, and the maximum likelihood estimate of the variance is $hat(sigma)^2 = e(hat(w)) slash (N m)$.
]
#proof[
  By independence the density of the data is $product_(l, k) (2 pi sigma^2)^(-1 slash 2) exp(-(o_k^((l)) - y_k(iota^((l)); w))^2 slash (2 sigma^2))$; taking logarithms gives the stated $ell$. The first term is a decreasing function of $e(w)$ for fixed $sigma^2$, which gives the claim about $w$. Setting $partial ell slash partial sigma^2 = e slash (2 sigma^4) - N m slash (2 sigma^2) = 0$ gives $hat(sigma)^2 = e slash (N m)$.
]

#remark[
  For class labels the Gaussian model is replaced by a Bernoulli or categorical one, whose negative log-likelihood is the cross-entropy; see Bishop (2006), section 5.2.
]

= Data representation

#notes-line(notes, ("Introduction to Neural Networks", "introduction"))

#definition(title: "Standardization", id: "standardization")[
  For an input with values $x_1, dots, x_n$, mean $macron(x) = 1 slash n sum_i x_i$ and corrected standard deviation $s = sqrt(1 slash (n - 1) sum_i (x_i - macron(x))^2) > 0$, the standardized values are $x'_i = (x_i - macron(x)) slash s$.
]

#theorem[
  The standardized values have mean $0$ and corrected standard deviation $1$.
]
#proof[
  $1 slash n sum_i x'_i = (macron(x) - macron(x)) slash s = 0$ and $1 slash (n - 1) sum_i x'^2_i = 1 slash s^2 dot 1 slash (n - 1) sum_i (x_i - macron(x))^2 = 1$.
]

The mean and $s$ are computed on the training data and the same numbers are applied to validation and test data.

#definition(title: "One-hot encoding", id: "one-hot-encoding")[
  A variable with symbols $a_1, dots, a_N$ is coded by $N$ input units; symbol $a_i$ becomes the vector $e_i in {0, 1}^N$ with a $1$ in position $i$ and $0$ elsewhere (called 1-in-$N$ encoding in the lectures).
]

#theorem[
  For $i != j$, $norm(e_i - e_j)_2 = sqrt(2)$. In contrast, coding the symbols by integers $z_i$ gives distances $|z_i - z_j|$ that differ between pairs, and $|z_1 - z_3| = |z_1 - z_2| + |z_2 - z_3|$ whenever $z_2$ lies between $z_1$ and $z_3$.
]
#proof[
  $e_i - e_j$ has a $1$ in position $i$, a $-1$ in position $j$ and zeros elsewhere, so its squared norm is $2$. The statement on integer codes is the additivity of distance on a line.
]

#remark[
  Standardization and decorrelation of the inputs are recommended for gradient-based training by LeCun et al. (1998); the argument is about the conditioning of the error surface and is not proved here.
]

= Threshold logic units

#notes-line(notes, ("Threshold Logic Units", "threshold-logic-units"))

== The unit and its hyperplane

#definition(title: "Threshold logic unit", id: "threshold-logic-unit")[
  A threshold logic unit (TLU, McCulloch-Pitts neuron) with $n$ inputs has weights $w in RR^n$ and a threshold $theta in RR$. It is the unit with $net = w dot x$, step activation at $theta$ and identity output:
  $ y(x) = cases(1 quad & "if" w dot x >= theta, 0 & "otherwise".) $
  Its boundary is the hyperplane $H = {x : w dot x = theta}$ with normal $w$, at distance $theta slash norm(w)$ from the origin when $w != 0$. The unit outputs $1$ on $H$ and on the open half-space where $w dot x - theta > 0$.
]

#example(title: [Conjunction and implication])[
  $w = (1, 1), theta = 3 slash 2$ gives $y = 1$ exactly at $(1, 1)$, since $w dot x in {0, 1, 1, 2}$ for the four Boolean inputs. $w = (-2, 2), theta = -1$ gives $w dot x in {0, 2, -2, 0}$ at $(0,0), (0,1), (1,0), (1,1)$ and so $y = 0$ only at $(1, 0)$: this is $x_1 -> x_2$.
]

== Linear separability

#definition(title: "Linear separability", id: "linear-separability")[
  Two finite sets $A_0, A_1 subset RR^n$ are linearly separable if there are $w in RR^n$ and $theta in RR$ with $w dot x < theta$ for all $x in A_0$ and $w dot x >= theta$ for all $x in A_1$. A Boolean function is computed by a single TLU if and only if the inputs with value $0$ and those with value $1$ are linearly separable.
]

#theorem(title: "Convex hull criterion")[
  Two finite sets $A_0, A_1 subset RR^n$ are linearly separable if and only if their convex hulls are disjoint, $conv(A_0) inter conv(A_1) = emptyset$.
]
#proof[
  ($arrow.r.double$) If $w dot x >= theta$ on $A_1$, then it holds on $conv(A_1)$, because $w dot (sum_i lambda_i x_i) = sum_i lambda_i w dot x_i$ for $lambda_i >= 0$, $sum_i lambda_i = 1$. Likewise $w dot x < theta$ on $conv(A_0)$. A common point would satisfy both.

  ($arrow.l.double$) The hulls $K_1, K_0$ are compact and convex, so $norm(p - q)$ attains its minimum $d$ on $K_1 times K_0$ at some $(p, q)$, and $d > 0$ because the hulls are disjoint. Put $w = p - q$. For $p' in K_1$ the point $p + t(p' - p)$ lies in $K_1$ for $t in [0, 1]$, and $norm(p + t(p' - p) - q)^2 = d^2 + 2 t w dot (p' - p) + t^2 norm(p' - p)^2$ cannot fall below $d^2$ for small $t > 0$; hence $w dot (p' - p) >= 0$, that is $w dot p' >= w dot p$. In the same way $w dot q' <= w dot q$ for $q' in K_0$. Since $w dot p - w dot q = d^2 > 0$, the threshold $theta = (w dot p + w dot q) slash 2$ gives $w dot p' > theta$ on $K_1$ and $w dot q' < theta$ on $K_0$.
]

#remark[
  For the biimplication $x_1 <-> x_2$ the hulls of $A_1 = {(0,0), (1,1)}$ and $A_0 = {(0,1), (1,0)}$ are the two diagonals of the unit square, which meet at $(1 slash 2, 1 slash 2)$. So no TLU computes it, and the same argument excludes the exclusive or. Of the $16$ Boolean functions of two inputs, the other $14$ are separable: the constants, the $8$ functions that are true at exactly one or exactly three corners (a corner of the square is an extreme point), and the $4$ that are true on one edge. In general the number of separable functions of $n$ inputs is $2, 4, 14, 104, 1882, 94572$ for $n = 0, dots, 5$ (OEIS A000609), a vanishing fraction of $2^(2^n)$.
]

== Two layers of threshold units

#theorem(title: "Boolean functions by two layers")[
  Every Boolean function $f: {0,1}^n -> {0,1}$ is computed by a network of TLUs with one hidden layer of at most $2^n$ units.
]
#proof[
  For $a in {0,1}^n$ let the unit $h_a$ have $w_i = 2 a_i - 1$ and $theta = sum_i a_i$. Then
  $ w dot x = sum_(i: a_i = 1) x_i - sum_(i: a_i = 0) x_i <= sum_i a_i, $
  with equality if and only if $x_i = 1$ wherever $a_i = 1$ and $x_i = 0$ wherever $a_i = 0$, that is if and only if $x = a$. So $h_a (x) = 1$ exactly at $x = a$. The output unit has weight $1$ from each $h_a$ with $f(a) = 1$ and threshold $1$: it is the disjunction of those $h_a$, and equals $f$.
]

#example(title: "Biimplication")[
  $h_1 = x_1 and x_2$ ($w = (1, 1)$, $theta = 3 slash 2$), $h_2 = not x_1 and not x_2$ ($w = (-1, -1)$, $theta = -1 slash 2$) and $y = h_1 or h_2$ ($w = (1, 1)$, $theta = 1 slash 2$). The inputs $(0,0), (0,1), (1,0), (1,1)$ map to $(h_1, h_2) = (0,1), (0,0), (0,0), (1,0)$; the points with $y = 1$ and $y = 0$ are separated by $h_1 + h_2 = 1 slash 2$.
]

#fig("/neural-networks/figures/tlu-network.svg", caption: [Biimplication by a hidden layer. Left: the two hidden units cut off the corners $(1,1)$ and $(0,0)$ of the input square. Right: in the hidden coordinates the inputs $(0,1)$ and $(1,0)$ coincide at the open point, and the output unit separates it from the two filled points.])

== The delta rule

#definition(title: "Delta rule", id: "delta-rule")[
  Let $(x, o)$ be a training pattern with $o in {0, 1}$ and $y$ the output of a TLU. If $y != o$, the weights and threshold are changed to
  $ theta arrow.l theta - eta (o - y), quad w_i arrow.l w_i + eta (o - y) x_i, $
  with learning rate $eta > 0$. If $y = o$ nothing changes. _Online_ training applies the change after each pattern; _batch_ training sums the changes over one pass through all patterns (an epoch) and applies the sum once. Training stops after an epoch without a change.
]

#remark[
  The rule is gradient descent on the modified error $e = sum_("wrong patterns") |w dot x - theta|$: for $o = 1$, $y = 0$ the term is $theta - w dot x$ with gradient $(-x, +1)$ in $(w, theta)$, for $o = 0$, $y = 1$ it is $w dot x - theta$ with gradient $(x, -1)$. The count of wrong outputs itself is constant on plateaus, with zero gradient almost everywhere. After one correction $w dot x - theta$ changes by $eta (o - y)(norm(x)^2 + 1)$, in the direction of $o - y$.
]

#theorem(title: "Convergence of the delta rule")[
  Let $L = {(x^((l)), o^((l)))}_(l=1)^m$ be training patterns with $o^((l)) in {0, 1}$. If the inputs with $o = 0$ and those with $o = 1$ are linearly separable, then online training, in any order of presentation, and batch training both stop after finitely many corrections, and the final $(w, theta)$ classifies every pattern correctly. If they are not separable, training does not stop.
]
#proof[
  Put $z^((l)) = (x^((l)), -1)$, $v = (w, theta)$ and $s_l = 2 o^((l)) - 1 in {-1, +1}$. Then $y = 1$ iff $v dot z >= 0$; a pattern is misclassified exactly when $s_l (v dot z^((l))) <= 0$ (for $o = 0$ the case $v dot z = 0$ is an error because the unit outputs $1$); and a correction is $v arrow.l v + eta s_l z^((l))$, because $o - y = s_l$ on an error. Let $R = max_l norm(z^((l)))$.

  Take a separating $(w^*, theta^*)$. Lowering $theta^*$ by half the smallest value of $theta^* - w^* dot x$ over the patterns with $o = 0$ gives $v^*$ and $gamma > 0$ with $s_l (v^* dot z^((l))) >= gamma$ for all $l$.

  _Online._ After $k$ corrections, starting from $v_0$: each adds at least $eta gamma$ to $v dot v^*$, so $v_k dot v^* >= v_0 dot v^* + k eta gamma$. Each satisfies $norm(v + eta s z)^2 = norm(v)^2 + 2 eta s (v dot z) + eta^2 norm(z)^2 <= norm(v)^2 + eta^2 R^2$, so $norm(v_k)^2 <= norm(v_0)^2 + k eta^2 R^2$. By Cauchy-Schwarz $v_0 dot v^* + k eta gamma <= norm(v^*) sqrt(norm(v_0)^2 + k eta^2 R^2)$. The left side grows linearly in $k$ and the right like $sqrt(k)$, so $k$ is bounded (for $v_0 = 0$, $k <= (R norm(v^*) slash gamma)^2$). After the last correction an epoch with no correction follows and training stops.

  _Batch._ At $v$ let $E$ be the nonempty set of misclassified patterns and $Delta v = eta sum_(l in E) s_l z^((l))$. Then $Delta v dot v^* >= eta gamma |E| >= eta gamma$, and $norm(v + Delta v)^2 <= norm(v)^2 + eta^2 m^2 R^2$ because each $s_l (v dot z^((l))) <= 0$ and $norm(Delta v) <= eta m R$. The same inequality as above bounds the number of epochs.

  _Not separable._ If training stopped, the final $(w, theta)$ would classify all patterns correctly, so the sets would be separable.
]

#remark[
  Training with the encoding false $= 0$, true $= 1$ cannot change $w_i$ on an error where $x_i = 0$. ADALINE codes false as $-1$, so every weight moves on every error. The hidden units of a multi-layer network have no desired outputs, so the delta rule cannot train them; the solution of a task by hidden units is also not unique.
]

= Multi-layer perceptrons

#notes-line(notes, ("Multi-Layer Perceptron", "multi-layer-perceptron"))

== Layered networks

#definition(title: [$r$-layer perceptron])[
  A feed-forward network whose units are partitioned into layers $U_1, dots, U_r$ with $U_1 = U_"in"$, $U_r = U_"out"$ and connections only from $U_l$ to $U_(l+1)$. Hidden and output units have the weighted sum as network input function. For layers of $m$ and $n$ units the weights form a matrix $W in RR^(n times m)$. With activation functions $phi_l$ applied elementwise and thresholds $theta_l$, the layer outputs are
  $ a_1 = x, quad a_l = phi_l (W_l a_(l-1) - theta_l), quad l = 2, dots, r, $
  and the network computes $y = a_r$. It has $sum_(l=2)^r n_l (n_(l-1) + 1)$ parameters.
]

#lemma(title: "Linear hidden units collapse")[
  If $phi_l$ is the identity for $l = 2, dots, r - 1$, the network computes $y = phi_r (M x - c)$ with $M = W_r W_(r-1) dots.c W_2$ and a fixed vector $c$, the same function as a network without hidden layers.
]
#proof[
  By induction, $a_l = W_l dots.c W_2 x - c_l$ for $l <= r - 1$: the case $l = 2$ is the definition, and $a_(l+1) = W_(l+1) a_l - theta_(l+1)$ is again affine in $x$.
]

== Universal approximation

#theorem(title: "Staircase approximation", id: "universal-approximation-theorem")[
  Let $f: [a, b] -> RR$ be continuous and let $sigma_k (z) = 1 slash (1 + e^(-k z))$ be the logistic function with slope $k$. For every $epsilon > 0$ there are $N$, $k$, switching points $s_1 < dots < s_N$ and weights $Delta_1, dots, Delta_N$ such that the three-layer perceptron
  $ g(x) = f(a) + sum_(i=1)^N Delta_i sigma_k (x - s_i) $
  satisfies $sup_(x in [a, b]) |f(x) - g(x)| <= 3 epsilon$.
]
#proof[
  $f$ is uniformly continuous, so there is $h > 0$ with $|f(x) - f(y)| < epsilon$ whenever $|x - y| <= h$. Take nodes $a = t_0 < dots < t_N = b$ with $t_i - t_(i-1) <= h$, let $s_i = (t_(i-1) + t_i) slash 2$, $Delta_i = f(t_i) - f(t_(i-1))$ and $V = sum_i |Delta_i|$. Let $H$ be the unit step. The staircase $S(x) = f(a) + sum_i Delta_i H(x - s_i)$ equals $f(t_j)$ on $(s_j, s_(j+1))$ because $sum_(i <= j) Delta_i = f(t_j) - f(a)$, and every $x$ in that interval is within $h$ of $t_j$, so $|f(x) - S(x)| < epsilon$ there.

  Let $eta = min_i (s_(i+1) - s_i) slash 2$ and choose $k$ so that $V slash (1 + e^(k eta)) < epsilon$. If $x$ is at distance at least $eta$ from every $s_i$, each term satisfies $|sigma_k (x - s_i) - H(x - s_i)| <= 1 slash (1 + e^(k eta))$, so $|g(x) - S(x)| < epsilon$ and $|f(x) - g(x)| < 2 epsilon$. If $x$ is within $eta$ of $s_j$ (for one $j$ only), the terms with $i != j$ again contribute an error below $epsilon$ in total, and the $j$th term lies between $0$ and $Delta_j$; so $g(x)$ lies within $epsilon$ of the interval between $f(t_(j-1))$ and $f(t_j)$, both within $epsilon$ of $f(x)$ because $x$ is within $h$ of $t_(j-1)$ and $t_j$. Hence $|f(x) - g(x)| <= 3 epsilon$.
]

#remark[
  The result extends to continuous functions of $d$ variables, to any bounded non-constant sigmoid and to approximation of integrable functions in an $L^p$ norm: Cybenko (1989) for sigmoids with limits $0$ and $1$ in the sup norm, Hornik (1991) for bounded non-constant activations. Leshno, Lin, Pinkus and Schocken (1993) prove that a continuous activation gives a universal one-hidden-layer family if and only if it is not a polynomial. The lectures obtain the multivariate case with bumps built from steps, which uses two hidden layers (four layers in their counting) and measures the error as the area between the functions. The staircase needs of the order of $epsilon^(-d)$ pieces for a Lipschitz function of $d$ variables; Barron (1993) gives a rate independent of $d$ for functions with a bounded first Fourier moment. That some functions need exponentially many units in a shallow network but few in a deep one is shown by Telgarsky (2016) and Eldan and Shamir (2016).
]

#fig("/neural-networks/figures/mlp-staircase.svg", caption: [The construction of the theorem with $N = 6$ and $N = 24$ hidden units and $k = 12 N$ on $[0, 1]$: the largest error falls from $0.09$ to $0.02$.])

= Activation functions

#notes-line(notes, ("Activation Functions", "activation-functions"))

#definition(title: "Sigmoid function")[
  A function $phi: RR -> RR$ that is monotonically non-decreasing with finite limits at $-infinity$ and $+infinity$. Examples are the step, the semi-linear function (linear between two points, constant outside), the sine until saturation, the logistic function and the hyperbolic tangent.
]

#definition(title: "Logistic function", id: "logistic-function")[
  $sigma(z) = 1 slash (1 + e^(-z))$, with values in $(0, 1)$ and $sigma(0) = 1 slash 2$.
]

#lemma[
  $sigma'(z) = sigma(z)(1 - sigma(z)) <= 1 slash 4$, with equality at $z = 0$; $sigma(-z) = 1 - sigma(z)$; and $tanh z = 2 sigma(2 z) - 1$, $tanh'(z) = 1 - tanh^2 z <= 1$.
]
#proof[
  $sigma' = e^(-z) slash (1 + e^(-z))^2 = sigma dot (e^(-z) slash (1 + e^(-z))) = sigma (1 - sigma)$. The product of two numbers in $[0,1]$ with sum $1$ is at most $1 slash 4$ (AM-GM), with equality for both equal to $1 slash 2$. Further $2 sigma(2 z) - 1 = (1 - e^(-2z)) slash (1 + e^(-2z)) = tanh z$, so $tanh' = 4 sigma'(2 z) = 4 sigma(2z)(1 - sigma(2z)) = (1 + tanh z)(1 - tanh z) = 1 - tanh^2 z$.
]

#definition(title: "Rectified linear unit", id: "rectified-linear-unit")[
  $"relu"(z) = max(0, z)$, with derivative $0$ for $z < 0$ and $1$ for $z > 0$ (undefined at $0$). The leaky variant uses $alpha z$ for $z < 0$; the softplus $log(1 + e^z)$ is a smooth version, with derivative $sigma(z)$.
]

#remark[
  The ReLU is unbounded, hence not a sigmoid, but it is not a polynomial and so gives universal one-hidden-layer networks (Leshno et al., 1993).
]

#fig("/neural-networks/figures/activation-functions.svg", caption: [The logistic function, tanh and the ReLU (left) and their derivatives (right). The two sigmoids lose their slope for large $|z|$.])

= Training

#notes-line(notes, ("Training a Multi-Layer Perceptron", "training-mlp"))

== Gradient descent

#definition(title: "Gradient descent", id: "gradient-descent")[
  For an error $e(w)$ differentiable in the parameters $w$ (weights and thresholds), repeat $w arrow.l w - eta nabla_w e(w)$ with learning rate $eta > 0$. Online descent uses the gradient of one pattern's error, batch descent that of the sum over the training set.
]

#lemma(title: "Logistic unit")[
  For $y = sigma(w dot x - theta)$ and the pattern error $e = (o - y)^2$,
  $ partial e slash partial w_i = -2 (o - y) y (1 - y) x_i, quad partial e slash partial theta = 2 (o - y) y (1 - y). $
  Absorbing $2$ into $eta$, the corrections are $Delta w_i = eta (o - y) y (1 - y) x_i$ and $Delta theta = -eta (o - y) y (1 - y)$.
]
#proof[
  The chain rule with $partial y slash partial (w dot x - theta) = y (1 - y)$ and $partial (w dot x - theta) slash partial w_i = x_i$, $partial slash partial theta = -1$.
]

#remark[
  The factor $y (1 - y)$ is at most $1 slash 4$ and vanishes as $y -> 0$ or $1$: a saturated unit changes slowly whatever its error. For targets in ${0, 1}$ the error of a logistic output cannot reach $0$, since $y in (0, 1)$.
]

== Variants

#definition(title: "Momentum", id: "momentum")[
  $Delta w(t) = -eta nabla e(t) + beta Delta w(t - 1)$ with $0 <= beta < 1$. In a region of constant gradient the steps converge to $-eta nabla e slash (1 - beta)$, an effective rate $1 slash (1 - beta)$ times larger.
]

#definition(title: "Resilient propagation", id: "resilient-propagation")[
  Every parameter $w_i$ has its own step size $Delta_i$. With $g_i(t) = partial e slash partial w_i$ at step $t$:
  $ Delta_i(t) = cases(min(a^+ Delta_i(t-1), Delta_max) & "if" g_i(t) g_i(t-1) > 0, max(a^- Delta_i(t-1), Delta_min) & "if" g_i(t) g_i(t-1) < 0, Delta_i(t-1) & "otherwise"), quad Delta w_i = -"sign"(g_i(t)) Delta_i(t), $
  with $a^+ = 1.2$ and $a^- = 0.5$ (Riedmiller and Braun, 1993). Only the sign of the gradient enters.
]

#remark[
  _Manhattan training_ is $Delta w = -eta "sign"(nabla e)$ with a fixed step. _Flat-spot elimination_ replaces $phi'$ by $phi' + zeta$ for a small constant $zeta$ in the gradient. _Quickprop_ (Fahlman, 1988) approximates $e$ in each weight by a parabola through the last two gradients and jumps to its vertex, $Delta w(t) = g(t) slash (g(t - 1) - g(t)) dot Delta w(t - 1)$.
]

#fig("/neural-networks/figures/gradient-flat-spot.svg", caption: [Log error against iteration for $e = sigma(w)^2$ started at $w = 4$: plain gradient descent with $eta = 1$ stays on the flat tail, momentum with $beta = 0.9$ and Rprop leave it within about $30$ iterations.])

== Complexity

#definition(title: "Weight decay", id: "weight-decay")[
  Minimize $e_"tot" = e + (xi slash 2) sum_i w_i^2$ with $xi > 0$. The gradient step becomes $w_i arrow.l w_i (1 - eta xi) - eta partial e slash partial w_i$, since $partial slash partial w_i ((xi slash 2) w_i^2) = xi w_i$. For a linear unit with squared error this is ridge regression.
]

#definition(title: "Early stopping", id: "early-stopping")[
  Evaluate the error on a validation set after each epoch and stop when it begins to increase, keeping the parameters of the epoch with the smallest validation error.
]

#definition(title: "Sensitivity analysis", id: "sensitivity-analysis")[
  The sensitivity of the outputs to input $i$ over a training set $L$ is
  $ s_i = 1 / (|L|) sum_(l in L) sum_(v in U_"out") |partial out_v^((l)) slash partial ext_i^((l))|, $
  computed by back-propagation to the input units. It depends on the scale of the inputs and, being local, can underrate inputs that share their effect with correlated ones.
]

= Depth

#notes-line(notes, ("Deep Networks", "deep-learning"))

#theorem(title: "Depth gives exponentially many pieces")[
  Let $t(x) = 2 max(0, x) - 4 max(0, x - 1 slash 2)$, so that $t(x) = 2 x$ on $[0, 1 slash 2]$ and $t(x) = 2 - 2 x$ on $[1 slash 2, 1]$. The $k$-fold composition $t^k$, computed by $k$ layers of two ReLU units, is piecewise linear on $[0, 1]$ with $2^k$ pieces, each mapping onto $[0, 1]$. A network with one hidden layer of $m$ ReLU units is piecewise linear on $RR$ with at most $m + 1$ pieces, so representing $t^k$ on $[0, 1]$ takes $m >= 2^k - 1$ units.
]
#proof[
  For $k = 1$ the two pieces map onto $[0, 1]$. If $t^k$ has $2^k$ linear pieces each mapping affinely onto $[0, 1]$, then on each piece $t^(k+1) = t compose t^k$ is the composition of an affine onto map with $t$, which has two linear pieces; so $t^(k+1)$ has $2^(k+1)$ pieces, again onto $[0, 1]$. For the shallow network, $c + sum_(i=1)^m a_i max(0, w_i x - b_i)$ is linear except possibly at the $m$ points $b_i slash w_i$ (a unit with $w_i = 0$ is constant), so it has at most $m + 1$ pieces; $t^k$ has $2^k$ pieces with distinct slopes on neighbouring pieces, hence needs $m + 1 >= 2^k$.
]

#remark[
  _Parity._
  The lectures give $2^(n - 1)$ hidden units for the parity of $n$ bits, which is the construction of one unit per input with output $1$. A single hidden layer of $n$ threshold units suffices: $h_k = [x_1 + dots + x_n >= k]$ for $k = 1, dots, n$ and the output $y = [sum_k (-1)^(k+1) h_k >= 1 slash 2]$. If $s$ inputs are on, $h_1 = dots = h_s = 1$ and the others are $0$, so the sum is $1$ for odd $s$ and $0$ for even $s$. A chain of exclusive-or blocks of three threshold units each also gives $3 (n - 1)$ units in $n - 1$ layers. Exponential separations of depth from width are proved for other functions: Telgarsky (2016) for the sawtooth above, Eldan and Shamir (2016) for a radial function in $RR^d$.
]

#lemma(title: "Vanishing gradient bound")[
  In a layered network with $delta_l = partial e slash partial z_l$ the derivative with respect to the net input of layer $l$, $delta_l = (W_(l+1)^top delta_(l+1)) dot.o phi'(z_l)$. If $norm(W_l)_2 <= w$ for all $l$ and $|phi'| <= c$, then $norm(delta_l) <= (c w)^(L - l) norm(delta_L)$.
]
#proof[
  $norm(W^top v) <= norm(W)_2 norm(v)$ and a componentwise product with a vector bounded by $c$ multiplies the norm by at most $c$; iterate from $l = L - 1$ down.
]

#remark[
  For the logistic function $c = 1 slash 4$, so the bound decays unless $w > 4$; for tanh $c = 1$; for the ReLU $c = 1$ on active units.
]

#definition(title: "Dropout", id: "dropout")[
  In each training step every input or hidden unit is omitted independently with probability $p$, together with its connections. At test time all units are used and the outgoing weights are multiplied by $1 - p$ (equivalently, activations are scaled by $1 slash (1 - p)$ during training). See Srivastava et al. (2014).
]

#fig("/neural-networks/figures/depth-sawtooth.svg", caption: [The tent function composed $k$ times has $2^k$ linear pieces and needs $2 k$ ReLU units.])

= Summary of formulas

#formulas(
  ("Quantity", "Result", "Where explained"),
  [Network input, weighted sum], [$net_u = sum_(v in pred(u)) w_(u v) out_v$], [#link(notes + "introduction/#a-network-is-a-graph")[Introduction]],
  [Unit state], [$net_u -> act_u = f_"act"(net_u, theta_u) -> out_u = f_"out"(act_u)$], [#link(notes + "introduction/#a-network-is-a-graph")[Introduction]],
  [Feed-forward evaluation], [one pass in topological order, $|U|$ unit evaluations], [#link(notes + "introduction/#how-a-network-computes")[Introduction]],
  [Sum of squared errors], [$e = sum_l sum_k (o_k^((l)) - out_(v_k)^((l)))^2$], [#link(notes + "introduction/#what-learning-means")[Introduction]],
  [Gaussian log-likelihood], [$ell = -e slash (2 sigma^2) - (N m slash 2) log(2 pi sigma^2)$], [#link(notes + "introduction/#what-learning-means")[Introduction]],
  [Standardization], [$x' = (x - macron(x)) slash s$, mean 0, deviation 1], [#link(notes + "introduction/#preparing-the-data")[Introduction]],
  [One-hot distance], [$norm(e_i - e_j) = sqrt(2)$], [#link(notes + "introduction/#preparing-the-data")[Introduction]],
  [TLU], [$y = 1 <=> w dot x >= theta$], [#link(notes + "threshold-logic-units/#the-unit-as-a-hyperplane")[Threshold Logic Units]],
  [Separability], [$conv(A_0) inter conv(A_1) = emptyset$], [#link(notes + "threshold-logic-units/#linear-separability")[Threshold Logic Units]],
  [Unit firing only at $a$], [$w_i = 2 a_i - 1$, $theta = sum_i a_i$], [#link(notes + "threshold-logic-units/#two-layers-compute-everything")[Threshold Logic Units]],
  [Delta rule], [$Delta theta = -eta (o - y)$, $Delta w_i = eta (o - y) x_i$], [#link(notes + "threshold-logic-units/#the-delta-rule")[Threshold Logic Units]],
  [Corrections, online, $v_0 = 0$], [$k <= (R norm(v^*) slash gamma)^2$], [#link(notes + "threshold-logic-units/#convergence-and-where-it-ends")[Threshold Logic Units]],
  [Layer], [$a_l = phi_l (W_l a_(l-1) - theta_l)$], [#link(notes + "multi-layer-perceptron/#layers-of-units")[Multi-Layer Perceptron]],
  [Parameters of an MLP], [$sum_l n_l (n_(l-1) + 1)$], [#link(notes + "multi-layer-perceptron/#layers-of-units")[Multi-Layer Perceptron]],
  [Staircase network], [$g = f(a) + sum_i Delta_i sigma_k (x - s_i)$, $Delta_i = f(t_i) - f(t_(i-1))$], [#link(notes + "multi-layer-perceptron/#universal-approximation")[Multi-Layer Perceptron]],
  [Logistic slope], [$sigma' = sigma (1 - sigma) <= 1 slash 4$; $tanh' = 1 - tanh^2$], [#link(notes + "activation-functions/#the-logistic-function")[Activation Functions]],
  [Logistic unit step], [$Delta w_i = eta (o - y) y (1 - y) x_i$], [#link(notes + "training-mlp/#gradient-descent")[Training a Multi-Layer Perceptron]],
  [Momentum], [$Delta w(t) = -eta nabla e(t) + beta Delta w(t - 1)$], [#link(notes + "training-mlp/#variants-of-gradient-descent")[Training a Multi-Layer Perceptron]],
  [Weight decay], [$w arrow.l w (1 - eta xi) - eta partial e slash partial w$], [#link(notes + "training-mlp/#controlling-complexity")[Training a Multi-Layer Perceptron]],
  [Sensitivity], [$s_i = |L|^(-1) sum_l sum_v |partial out_v slash partial ext_i|$], [#link(notes + "training-mlp/#sensitivity-analysis")[Training a Multi-Layer Perceptron]],
  [Tent composition], [$2^k$ pieces from $2 k$ ReLU units; shallow net needs $>= 2^k - 1$], [#link(notes + "deep-learning/#why-depth")[Deep Networks]],
  [Gradient bound], [$norm(delta_l) <= (c w)^(L - l) norm(delta_L)$], [#link(notes + "deep-learning/#why-deep-networks-are-hard-to-train")[Deep Networks]],
)

= References

- R. Kruse, C. Borgelt, F. Klawonn, C. Moewes, M. Steinbrecher and P. Held, _Computational Intelligence: A Methodological Introduction_, Springer, 2013: the source of the general definition of a network (units, the three functions, input and output units) and of the structure of the lectures; Part I on neural networks.
- S. Haykin, _Neural Networks and Learning Machines_, 3rd ed., Pearson, 2009: the definition of a neural network as an adaptive parallel processor, and the properties usually listed for it.
- W. S. McCulloch and W. Pitts, "A logical calculus of the ideas immanent in nervous activity", _Bulletin of Mathematical Biophysics_ 5 (1943), 115 to 133; F. Rosenblatt, "The perceptron: a probabilistic model for information storage and organization in the brain", _Psychological Review_ 65 (1958), 386 to 408.
- F. A. C. Azevedo et al., "Equal numbers of neuronal and nonneuronal cells make the human brain an isometrically scaled-up primate brain", _Journal of Comparative Neurology_ 513 (2009), 532 to 541: the count of about 86 billion neurons.
- A. S. Morcos, D. G. T. Barrett, N. C. Rabinowitz and M. Botvinick, "On the importance of single directions for generalization", _ICLR_ 2018.
- B. Widrow and M. E. Hoff, "Adaptive switching circuits", _IRE WESCON Convention Record_ 4 (1960), 96 to 104: the delta rule and ADALINE.
- A. B. J. Novikoff, "On convergence proofs on perceptrons", _Symposium on the Mathematical Theory of Automata_ 12 (1962), 615 to 622: the convergence argument above. M. Minsky and S. Papert, _Perceptrons_, MIT Press, 1969: the limits of a single unit.
- OEIS A000609: the number of threshold functions of $n$ variables.
- G. Cybenko, "Approximation by superpositions of a sigmoidal function", _Mathematics of Control, Signals and Systems_ 2 (1989), 303 to 314; K. Hornik, "Approximation capabilities of multilayer feedforward networks", _Neural Networks_ 4 (1991), 251 to 257; M. Leshno, V. Y. Lin, A. Pinkus and S. Schocken, "Multilayer feedforward networks with a nonpolynomial activation function can approximate any function", _Neural Networks_ 6 (1993), 861 to 867: universal approximation.
- A. R. Barron, "Universal approximation bounds for superpositions of a sigmoidal function", _IEEE Transactions on Information Theory_ 39 (1993), 930 to 945; M. Telgarsky, "Benefits of depth in neural networks", _COLT_ 2016; R. Eldan and O. Shamir, "The power of depth for feedforward neural networks", _COLT_ 2016: how many units are needed.
- M. Riedmiller and H. Braun, "A direct adaptive method for faster backpropagation learning: the RPROP algorithm", _IEEE ICNN_ 1993; S. E. Fahlman, "An empirical study of learning speed in back-propagation networks", CMU technical report, 1988: the training variants.
- N. Srivastava, G. Hinton, A. Krizhevsky, I. Sutskever and R. Salakhutdinov, "Dropout: a simple way to prevent neural networks from overfitting", _Journal of Machine Learning Research_ 15 (2014), 1929 to 1958.
- C. M. Bishop, _Pattern Recognition and Machine Learning_, Springer, 2006, section 5.2: the error function of a network from maximum likelihood.
- Y. LeCun, L. Bottou, G. B. Orr and K.-R. Müller, "Efficient BackProp", in _Neural Networks: Tricks of the Trade_, Springer, 1998: preparation of the inputs.
