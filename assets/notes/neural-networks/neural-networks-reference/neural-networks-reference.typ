// Technical reference for the Neural Networks course (`_notes/ai/neural-networks/`), after Piuri's lectures.
// One document covers all of its notes: the site pages explain and stay short, this
// reference states the results precisely and proves the ones an exam is likely to ask for.
// Style, environments and figures come from assets/notes/_typst/note-style.typ; the rules
// for adding to it are in .claude/skills/write-typst-reference/.
#import "../../_typst/note-style.typ": *

#show: reference.with(
  title: "Neural Networks",
  subtitle: "Technical reference",
  abstract: [The general model of a neural network, learning tasks and their error, and data representation, with proofs. Each chapter says which site note explains it; the last chapter collects the formulas.],
  site: "https://lorenzoliuzzo.github.io/notes/",
)

#let notes = "https://lorenzoliuzzo.github.io/notes/ai/neural-networks/"
#let net = math.op("net")
#let act = math.op("act")
#let out = math.op("out")
#let ext = math.op("ext")
#let pred = math.op("pred")

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
)

= References

- R. Kruse, C. Borgelt, F. Klawonn, C. Moewes, M. Steinbrecher and P. Held, _Computational Intelligence: A Methodological Introduction_, Springer, 2013: the source of the general definition of a network (units, the three functions, input and output units) and of the structure of the lectures; Part I on neural networks.
- S. Haykin, _Neural Networks and Learning Machines_, 3rd ed., Pearson, 2009: the definition of a neural network as an adaptive parallel processor, and the properties usually listed for it.
- W. S. McCulloch and W. Pitts, "A logical calculus of the ideas immanent in nervous activity", _Bulletin of Mathematical Biophysics_ 5 (1943), 115 to 133; F. Rosenblatt, "The perceptron: a probabilistic model for information storage and organization in the brain", _Psychological Review_ 65 (1958), 386 to 408.
- F. A. C. Azevedo et al., "Equal numbers of neuronal and nonneuronal cells make the human brain an isometrically scaled-up primate brain", _Journal of Comparative Neurology_ 513 (2009), 532 to 541: the count of about 86 billion neurons.
- A. S. Morcos, D. G. T. Barrett, N. C. Rabinowitz and M. Botvinick, "On the importance of single directions for generalization", _ICLR_ 2018.
- C. M. Bishop, _Pattern Recognition and Machine Learning_, Springer, 2006, section 5.2: the error function of a network from maximum likelihood.
- Y. LeCun, L. Bottou, G. B. Orr and K.-R. Müller, "Efficient BackProp", in _Neural Networks: Tricks of the Trade_, Springer, 1998: preparation of the inputs.
