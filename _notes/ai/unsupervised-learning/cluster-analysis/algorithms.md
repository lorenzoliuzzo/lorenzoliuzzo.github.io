---
collection: notes
title: "Clustering Algorithms: Partitional, Hierarchical, and Density-Based"
date: 2026-07-31
order: 2
tags: 
  - Artificial Intelligence
  - Unsupervised Learning
  - Clustering
---

When trying to discover natural groupings within data, the choice of the clustering algorithm heavily depends on the underlying topological assumptions of the dataset and the computational constraints of the deployment environment.

## 1. K-Means Clustering

K-means is a partitional, centroid-based approach where the hyperparameter $K$ (number of clusters) must be defined *a priori*. It assumes clusters are convex, isotropic (spherical), and roughly of similar variance.


### 1.1 The Lloyd's Learning Algorithm

The standard approach is an iterative refinement technique related to the Expectation-Maximization (EM) algorithm.

```text
Algorithm: Standard K-Means (Lloyd's)
Input: Dataset X, integer K
Output: Centroids C, Assignments c

1. C = Select-Initial-Centroids(X, K)
2. Repeat until convergence (centroids C stop changing):
   // Expectation Step: Assign points
   3. For each x_i in X:
        c(i) = argmin_j ||x_i - C_j||^2
   // Maximization Step: Update centroids
   4. For each j in {1, ..., K}:
        C_j = Mean({x_i in X | c(i) == j})
5. Return C, c

```

> **Note on Convergence:** While the theoretical centroid is the mean, alternative metrics like the medoid (the actual data point closest to the mean) can be used for L1-norm optimization (K-Medoids). Because the algorithm guarantees monotonic decrease of the objective function, convergence is certain, though often truncated early in practice when assignment changes fall below a tolerance threshold.

### 1.2 Objective Function

K-Means minimizes the **Sum of Squared Errors (SSE)**, also known as cluster inertia. It represents the variance within the clusters:

$$SSE = \sum_{i=1}^K \sum_{x \in C_i} \text{dist}^2(\mu_i, x) = \sum_{i=1}^K \sum_{x \in C_i} \sum_{j=1}^d (\mu_{ij} - x_{ij})^2$$

Where $C_i$ is the $i$-th cluster, and $\mu_i$ is its centroid. K-Means is guaranteed to find a local minimum of the SSE, but not necessarily the global minimum, which is NP-hard to compute.

### 1.3 Initialization Strategies

The non-convex nature of the SSE surface means random initialization often traps the algorithm in sub-optimal local minima.

* **Multiple Restarts:** Run the algorithm $N$ times with different random seeds and keep the model with the lowest final SSE. Brute-force but often necessary.
* **K-Means++:** A probabilistic initialization that spreads out the initial centroids, guaranteeing an approximation ratio of $O(\log K)$ to the optimal solution.

```text
Algorithm: K-Means++ Initialization
Input: Dataset X, integer K
Output: Initial Centroids C

1. c_1 = Randomly sample one point uniformly from X
2. C = {c_1}
3. For t = 2 to K:
     4. For each x in X:
          D(x)^2 = min_{c in C} ||x - c||^2  // Dist to nearest chosen centroid
     5. Select next centroid c_t from X with probability proportional to D(x)^2
     6. C = C U {c_t}
7. Return C

```

* **Bisecting K-Means:** A top-down approach that builds a hierarchy. It is highly resistant to initialization traps and naturally handles clusters of slightly varying sizes.

```text
Algorithm: Bisecting K-Means
Input: Dataset X, integer K
Output: Cluster assignments

1. Initialize a single cluster C_1 containing all points in X.
2. Active_Clusters = {C_1}
3. While |Active_Clusters| < K:
     4. Select the cluster C_target from Active_Clusters with the highest SSE.
     5. Run standard K-Means on C_target with K=2 to produce C_a and C_b.
     6. Remove C_target from Active_Clusters.
     7. Add C_a and C_b to Active_Clusters.
8. Return Active_Clusters

```

\
**1.4 Complexity and Optimization**

* **Time Complexity:** $\mathcal{O}(N \cdot K \cdot I \cdot d)$ where $N$ is points, $I$ is iterations, and $d$ is dimensionality.
* **Algorithmic Optimizations:** For high-dimensional data or massive $N$, algorithms like **Elkan's K-Means** utilize the triangle inequality to avoid redundant distance calculations, drastically reducing the constant factor in the time complexity at the cost of $\mathcal{O}(N \cdot K)$ memory overhead.

---

## 2. Hierarchical Clustering

Hierarchical methods build a tree of nested clusters (dendrogram). They do not require a predetermined $K$ and provide an interpretable lineage of cluster formation.

**Types and Linkage Criteria**

Hierarchical clustering is split into **Agglomerative** (bottom-up, $\mathcal{O}(N^3)$ time) and **Divisive** (top-down, $O(2^N)$ time in the worst naive case).

The core of agglomerative clustering is the proximity matrix and the **linkage criterion**, which dictates the distance $D(A, B)$ between two clusters $A$ and $B$:

1. **Single Linkage (MIN):** $D(A, B) = \min\_{x \in A, y \in B} \|\|x - y\|\|$. Prone to *chaining* (forming long, thin clusters), but can capture non-elliptical manifolds.
2. **Complete Linkage (MAX):** $D(A, B) = \max\_{x \in A, y \in B} \|\|x - y\|\|$. Avoids chaining, forces compact clusters, but highly sensitive to outliers.
3. **Average Linkage:** $D(A, B) = \frac{1}{\|A\|\|B\|} \sum\_{x \in A} \sum\_{y \in B} \|\|x - y\|\|$. A stable compromise.
4. **Ward's Method:** Merges the two clusters that result in the minimum increase in total intra-cluster variance (SSE). It behaves similarly to K-Means but in a hierarchical framework.

> **Note on Implementation (Lance-Williams):** Modern implementations do not recompute distances from scratch. They use the Lance-Williams update formula, which allows the distance between a newly formed cluster $(A \cup B)$ and an existing cluster $C$ to be computed in $\mathcal{O}(1)$ time from the known distances $D(A,B), D(A,C),$ and $D(B,C)$.

---

## 3. Density-Based Clustering (DBSCAN)

Density-based algorithms bypass the globular assumption entirely. They define clusters as contiguous regions of high point density, separated by regions of low density.

\
**3.1 Core Concpets**
DBSCAN requires two parameters:

* $\epsilon$ (Eps): The search radius defining a neighborhood.
* $MinPts$: The minimum number of points required within an $\epsilon$-neighborhood to consider a region "dense."

Points are classified into:

* **Core Points:** $|N_\epsilon(x)| \geq MinPts$.
* **Border Points:** Not a core point, but falls within the $N_\epsilon$ of a core point.
* **Noise (Outliers):** Neither core nor border.

\
**3.2 Graph-Theoretic Perspective**

DBSCAN is elegantly understood through graph theory.

1. Construct an $\epsilon$-neighborhood graph where edges exist between any two points within $\epsilon$ distance.
2. Retain only edges between Core points.
3. The connected components of this filtered graph form the fundamental clusters.
4. Border points are assigned to the cluster of their nearest connected Core point. Noise points are disconnected isolates.

\
**3.3 Complexity**

Naive implementation requires $\mathcal{O}(N^2)$ to compute the distance matrix. However, by using spatial indexing structures like **KD-Trees** or **Ball Trees**, the neighborhood queries $N_\epsilon(x)$ can be accelerated, yielding an average time complexity of $\mathcal{O}(N \log N)$.

> **Note on Curse of Dimensionality**: These tree structures suffer from the "curse of dimensionality"; for $d > 15$, performance degrades back toward $\mathcal{O}(N^2)$.

---

## 4. Algorithm Confrontation & Selection Matrix

When engineering an ML pipeline, algorithm selection dictates system architecture and failure modes:

| Feature | K-Means | Hierarchical (Agglomerative) | DBSCAN |
| --- | --- | --- | --- |
| **Assumed Topology** | Globular / Spherical | Depends on linkage (Ward = Globular, Single = Manifold) | Arbitrary geometry |
| **Hyperparameters** | $K$ (Number of clusters) | Distance metric & Linkage criteria | $\epsilon$ and $MinPts$ |
| **Noise Handling** | Extremely poor (drags centroids) | Poor (disrupts linkage trees) | **Excellent** (isolates as noise) |
| **Density Variations** | Fails with varying variances | Handles reasonably well | Fails if density varies wildly (Use **OPTICS** instead) |
| **Time Complexity** | $\mathcal{O}(N \cdot K \cdot I \cdot d)$ | $\mathcal{O}(N^2 \log N)$ to $\mathcal{O}(N^3)$ | $\mathcal{O}(N \log N)$ with spatial index |
| **Space Complexity** | $\mathcal{O}(K \cdot d)$ | $\mathcal{O}(N^2)$ (Proximity Matrix) | $\mathcal{O}(N)$ |

**Strategic Takeaways for Deployment**
* Use **K-Means** for massive datasets where VRAM/RAM constraints dictate the need for low memory overhead and high SIMD/AVX vectorization potential.
* Use **Hierarchical** when taxonomy is the goal (e.g., phylogenetics) and $N < 10^4$.
* Use **DBSCAN** for geospatial data, anomaly detection, or when underlying physical manifolds dictate non-linear, interlocking cluster shapes.
