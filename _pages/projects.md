---
title: Projects Archive
permalink: /projects/
layout: single
classes: wide
author_profile: true
---

Some of my recent work at the intersection of physics, AI, and software engineering.

{% assign projects = site.projects | sort: 'date' | reverse %}
{% include entry-list.html entries=projects date=true empty="Nothing published here yet." %}
