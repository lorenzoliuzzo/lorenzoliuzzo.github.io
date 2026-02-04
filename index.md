---
title: "Hello, World!"
layout: single
permalink: /
author_profile: true
classes: wide
excerpt: "Welcome to my personal site, a knowledge base where I publish notes and project updates."
header:
  overlay_color: "#193155ff"
  overlay_filter: "0.65"
  overlay_image: /assets/images/Planck_CMB.jpg  
  actions:
    - label: "More About Me"
      url: "/about/"
    - label: "View Projects"
      url: "/projects/"
    - label: "Browse Notes"
      url: "/notes/"
---


## What I'm Working On
- 
- 
- 


## Recent Projects
{% assign projects = site.projects | sort: 'date' | reverse | limit: 2 %}
{% for project in projects %}
  <article class="archive__item" style="margin-bottom: 1.5em;">
    <h3 class="archive__item-title">
      <a href="{{ project.url | relative_url }}">{{ project.title }}</a>
    </h3>
    <p class="archive__item-excerpt">
      {{ project.excerpt | strip_html | truncate: 160 }}
    </p>
  </article>
{% endfor %}

<p><a href="/projects/" class="btn btn--primary">All Projects →</a></p>


## Recent Notes
{% assign notes = site.notes | sort: 'date' | reverse | limit: 3 %}
{% for note in notes %}
  <article class="archive__item" style="margin-bottom: 1.5em;">
    <h3 class="archive__item-title">
      <a href="{{ note.url | relative_url }}">{{ note.title }}</a>
    </h3>
    <p class="archive__item-excerpt">
      {{ note.excerpt | strip_html | truncate: 160 }}
    </p>
  </article>
{% endfor %}

<p><a href="/notes/" class="btn btn--primary">All Notes →</a></p>

---