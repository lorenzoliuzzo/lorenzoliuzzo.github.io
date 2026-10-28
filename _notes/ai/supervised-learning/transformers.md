---
title: "Transformers & Attention Mechanisms"
date: 2026-08-24
collection: notes
layout: single
order: 4
read_time: true
toc: true
toc_sticky: true
tags:
  - Artificial Intelligence
  - Deep Learning
  - Attention Mechanisms
---

## Scaled Dot-Product Self-Attention
Transformers map sequence elements by computing relationship scores between Query ($Q$), Key ($K$), and Value ($V$) linear projections[cite: 6, 7]:

$$\text{Attention}(Q, K, V) = \text{softmax}\left(\frac{QK^T}{\sqrt{d_k}}\right)V$$[cite: 6, 7]

The scaling factor $\sqrt{d_k}$ stabilizes gradients during training for higher dimensional vectors[cite: 6, 7].

## Core Architectural Blocks
* **Positional Encodings:** Injects spatial or sequence position information into feature representations since self-attention operations are permutation-invariant[cite: 6, 7].
* **Multi-Head Attention:** Runs multiple parallel attention mechanisms ("heads"), allowing the model to jointly attend to information from different representation subspaces at different positions[cite: 6, 7].
* **Transformer Layer Stacks:** Stacks multi-head attention blocks with feed-forward sub-layers, residual connections, and layer normalization to build deep sequence processing networks[cite: 6, 7].