---
title: Threads
permalink: /threads/
layout: single
classes: wide
author_profile: true
---

A note belongs to one course, but an idea does not. Each thread follows one idea across the courses that use it, in the order that makes it make sense, and says where each step sits in the notes.

{% assign threads = site.threads | sort: "date" | reverse %}
{% include entry-list.html entries=threads date=true empty="No threads yet." %}
