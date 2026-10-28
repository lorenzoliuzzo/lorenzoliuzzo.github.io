---
collection: notes
title: "Partial Derivatives and the Gradient"
date: 2026-10-27
excerpt: "Partial derivatives, the gradient, the chain rule and extrema of functions of several variables."
hook: "A function of several variables has one slope per direction, and the gradient collects them into the direction of steepest increase."
goals:
  - compute partial derivatives and the gradient
  - find and classify extrema, with constraints
requires:
  - derivative
  - taylor-expansion
defines:
  - {id: partial-derivative, name: "partial derivative", anchor: def-partial-derivative}
  - {id: gradient, name: "gradient", anchor: def-gradient}
  - {id: jacobian, name: "Jacobian", anchor: def-jacobian}
read_time: true
tags:
  - Mathematics
  - Calculus
---

Most quantities in physics and machine learning depend on many variables at once: a potential on space, a loss on thousands of weights. The one-variable derivative becomes a vector, the gradient, and the rest of the theory is what that vector tells you.

# Partial derivatives

> The **partial derivative** of $f(x_1,\dots,x_n)$ with respect to $x_i$ is the derivative in $x_i$ with all other variables held fixed: $\dfrac{\partial f}{\partial x_i}=\lim_{h\to0}\dfrac{f(\dots,x_i+h,\dots)-f(\dots,x_i,\dots)}{h}$.
{: .definition #def-partial-derivative title="Partial derivative"}

One computes it with the ordinary rules, treating the other variables as constants. For $f(x,y)=x^2y+\sin y$ one gets $f_x=2xy$ and $f_y=x^2+\cos y$. Second derivatives come in a matrix of $n^2$ entries, but they are not all independent.

> If the second partial derivatives of $f$ are continuous, then $\dfrac{\partial^2f}{\partial x\,\partial y}=\dfrac{\partial^2f}{\partial y\,\partial x}$.
{: .theorem #thm-schwarz title="Equality of mixed partials"}

> Let $\Delta=f(x+h,y+k)-f(x+h,y)-f(x,y+k)+f(x,y)$. The mean value theorem applied to $s\mapsto f(s,y+k)-f(s,y)$ and then to the resulting difference in $y$ gives $\Delta=hk\,\partial_y\partial_xf(\xi_1,\eta_1)$ for some point in the rectangle. Applying it in the other order gives $\Delta=hk\,\partial_x\partial_yf(\xi_2,\eta_2)$. Dividing by $hk$ and letting $h,k\to0$, continuity of the second derivatives makes both sides tend to the values at $(x,y)$, which are therefore equal.
{: .proof}

For the example, $f_{xy}=2x=f_{yx}$. The practical use is a check on calculations, and in thermodynamics it is the source of the Maxwell relations.

The partial derivatives are what the first-order Taylor expansion needs: near a point, $f(\mathbf x+\mathbf h)\approx f(\mathbf x)+\sum_i\frac{\partial f}{\partial x_i}h_i$, so a small step changes $f$ by the sum of the slopes times the steps. This holds when $f$ is **differentiable**, which continuous partial derivatives guarantee; having partial derivatives that merely exist does not.

# The gradient

The sum above is a dot product, and the vector it uses has a name.

> The **gradient** of $f$ is the vector of its partial derivatives, $\nabla f=\big(\partial f/\partial x_1,\dots,\partial f/\partial x_n\big)$. The rate of change of $f$ along a unit vector $\mathbf u$, the **directional derivative**, is $D_{\mathbf u}f=\nabla f\cdot\mathbf u$.
{: .definition #def-gradient title="Gradient"}

> At a point where $\nabla f\ne0$, the gradient points in the direction of steepest increase of $f$, its length is the steepest slope, and it is perpendicular to the level set of $f$ through that point.
{: .property title="Geometry of the gradient"}

Both facts come from $D_{\mathbf u}f=|\nabla f|\cos\theta$, where $\theta$ is the angle between $\mathbf u$ and the gradient: it is largest for $\theta=0$, and zero along the level set, where $f$ does not change. For $f=x^2+2y^2$ at $(1,1)$, $\nabla f=(2,4)$, so the steepest ascent is along $(1,2)/\sqrt5$ with slope $\sqrt{20}\approx4.47$, and moving along $(2,-1)$ keeps $f$ constant to first order.

{% include fig.html src="calculus/gradient-contours" id="fig-gradient-contours" alt="Concentric elliptical level curves of a function, with short arrows at points on two of them. Every arrow is perpendicular to its curve and points outward, away from the centre where the function is smallest." caption="Level curves of $f=x^2+2y^2$ and its gradient at points on two of them. The gradient is normal to the curve through each point and points toward larger $f$." %}

> Minimizing a loss $L$ by **gradient descent** repeats $\mathbf x\leftarrow\mathbf x-\eta\nabla L$, a small step against the steepest ascent. On $f=x^2+2y^2$ the update multiplies the $x$ coordinate by $1-2\eta$ and the $y$ coordinate by $1-4\eta$, so it converges only if $\eta<0.5$: the steepest curvature limits the step size.
{: .application title="Gradient descent"}

# Chain rule and Jacobian

When the variables themselves depend on others, the gradient chains. For $f(\mathbf x(t))$, $\dfrac{df}{dt}=\nabla f\cdot\dfrac{d\mathbf x}{dt}$. For a vector-valued map $\mathbf f:\mathbb R^n\to\mathbb R^m$ the partial derivatives form a matrix.

> The **Jacobian** of $\mathbf f=(f_1,\dots,f_m)$ is the $m\times n$ matrix $J$ with entries $J_{ij}=\partial f_i/\partial x_j$. It is the matrix of the best linear approximation $\mathbf f(\mathbf x+\mathbf h)\approx\mathbf f(\mathbf x)+J\mathbf h$, and the chain rule reads $J_{\mathbf g\circ\mathbf f}=J_{\mathbf g}\,J_{\mathbf f}$.
{: .definition #def-jacobian title="Jacobian"}

For $m=1$ the Jacobian is the gradient written as a row. When $m=n$, $|\det J|$ is the local factor by which the map scales volume, which is why it appears when changing variables in an integral. In polar coordinates $x=r\cos\theta$, $y=r\sin\theta$, $J=\begin{pmatrix}\cos\theta&-r\sin\theta\\\sin\theta&r\cos\theta\end{pmatrix}$ and $\det J=r$, so $dx\,dy=r\,dr\,d\theta$.

# Extrema

At a local extremum of a differentiable function the first-order change vanishes in every direction, so $\nabla f=0$. Such a **critical point** can be a minimum, a maximum or a saddle, and the second-order term of the Taylor expansion decides: $f(\mathbf x_0+\mathbf h)\approx f(\mathbf x_0)+\tfrac12\mathbf h^{\mathsf T}H\mathbf h$, where $H_{ij}=\partial^2f/\partial x_i\partial x_j$ is the **Hessian**, symmetric by the theorem above.

{% capture t %}
| Hessian at the critical point | Eigenvalues | Type |
|:--|:--|:--|
| positive definite | all $>0$ | local minimum |
| negative definite | all $<0$ | local maximum |
| indefinite | mixed signs | saddle |
| singular | some $=0$ | undecided, look at higher order |
{% endcapture %}
{% include tab.html id="tab-hessian" caption="Classifying a critical point from the Hessian." body=t %}
{: .booktabs}

With a constraint $g(\mathbf x)=0$ the extremum is no longer a critical point of $f$ alone. On the constraint surface one cannot move to first order against $\nabla g$, so at an extremum the gradient of $f$ must have no component along the surface:
$$ \nabla f=\lambda\nabla g. $$
This is the method of **Lagrange multipliers**, with $\lambda$ an extra unknown solved together with $g=0$. To maximize $xy$ on $x+y=2$: $(y,x)=\lambda(1,1)$ gives $x=y=1$ and the maximum value $1$.

> The condition $\nabla f=0$ also holds at saddles, and on a closed region the extremum may lie on the boundary where $\nabla f\ne0$. Check the boundary and the Hessian before calling a critical point a minimum.
{: .trap}

# Recap

<details class="qa" markdown="1">
<summary>Why does the gradient point in the direction of steepest increase?</summary>

The rate of change along a unit vector $\mathbf u$ is $\nabla f\cdot\mathbf u=|\nabla f|\cos\theta$, which is largest when $\mathbf u$ is along $\nabla f$, with value $|\nabla f|$.
</details>

<details class="qa" markdown="1">
<summary>What does the Jacobian determinant measure?</summary>

The local factor by which a map from $\mathbb R^n$ to itself scales volume, which is the extra factor in a change of variables in an integral ($r$ for polar coordinates).
</details>

<details class="qa" markdown="1">
<summary>How do you recognise a constrained extremum?</summary>

The gradient of $f$ is parallel to the gradient of the constraint, $\nabla f=\lambda\nabla g$, together with $g=0$.
</details>
