// Technical reference for the Neural Networks course (`_notes/ai/neural-networks/`), after Piuri's lectures.
// One document covers all of its notes: the site pages explain and stay short, this
// reference states the results precisely and proves the ones an exam is likely to ask for.
// Style, environments and figures come from assets/notes/_typst/note-style.typ; the rules
// for adding to it are in .claude/skills/write-typst-reference/.
#import "../../_typst/note-style.typ": *

#show: reference.with(
  title: "Neural Networks",
  subtitle: "Technical reference",
  abstract: [The general model of a neural network, learning tasks and their error, data representation, and threshold logic units with the delta rule, with proofs. Each chapter says which site note explains it; the last chapter collects the formulas.],
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
- C. M. Bishop, _Pattern Recognition and Machine Learning_, Springer, 2006, section 5.2: the error function of a network from maximum likelihood.
- Y. LeCun, L. Bottou, G. B. Orr and K.-R. Müller, "Efficient BackProp", in _Neural Networks: Tricks of the Trade_, Springer, 1998: preparation of the inputs.
