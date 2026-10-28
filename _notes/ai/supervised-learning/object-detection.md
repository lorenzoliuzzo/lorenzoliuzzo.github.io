---
title: "Object Recognition and Detection"
date: 2026-08-24
collection: notes
layout: single
order: 3
read_time: true
toc: true
toc_sticky: true
tags:
  - Artificial Intelligence
  - Supervised Learning
  - Computer Vision
  - Computer Vision
  - Object Detection
  - Deep Learning
---

## Classical Object Recognition & Viola-Jones
* **Instance Recognition:** Utilizes local descriptors like SIFT, geometric verification via RANSAC, and visual word quantization using Bag of Words (BoW) models[cite: 6, 8, 19]. Applied to panorama stitching and tracking[cite: 6, 8].
* **Viola-Jones Framework:** Employs homogeneous coordinates, Haar-like feature extraction computed via integral images, and AdaBoost cascade classifiers for real-time face/object detection[cite: 6, 8, 16].

## Detection Evaluation Metrics
* **Intersection over Union (IoU):** Measures spatial overlap between predicted bounding box $B_p$ and ground truth $B_{gt}$[cite: 6, 8, 14]:
  $$\text{IoU} = \frac{\text{Area}(B_p \cap B_{gt})}{\text{Area}(B_p \cup B_{gt})}$$
* **mean Average Precision (mAP):** Computes the mean AP score across all target classes at designated IoU thresholds[cite: 6, 8, 14].

## Deep Learning Object Detection Paradigms
* **Two-Stage Detectors (Coarse-to-Fine):** Generate class-agnostic region proposals (e.g., Selective Search) followed by classification and bounding box regression[cite: 6, 8, 14]. 
  * *Evolution:* R-CNN $\rightarrow$ Fast R-CNN (shared feature maps) $\rightarrow$ Faster R-CNN (Region Proposal Networks & anchor boxes)[cite: 6, 8, 14].
* **Single-Shot Detectors (Unified Pass):** Frame detection as a single unified regression problem over a spatial grid[cite: 6, 8, 14, 18].
  * *YOLO Framework:* Processes images in a single feedforward step at high frame rates (e.g., 45 to 155 FPS), capturing global image context[cite: 6, 8, 18]. Updated across iterations (v2–v7) with multi-scale predictions and anchor tweaks[cite: 6, 8].