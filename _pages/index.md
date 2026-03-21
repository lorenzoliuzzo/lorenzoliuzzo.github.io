---
title: "Hello, World!"
excerpt: "Welcome to my personal site, a knowledge base where I publish notes and project updates."
permalink: /

layout: single
classes: wide

header:
  overlay_color: "#12223aff"
  overlay_filter: "0.5"
  overlay_image: /assets/images/Planck_CMB.jpg  

  actions:
    - label: "About Me"
      url: "/about/"
    - label: "View Projects"
      url: "/projects/"
    - label: "Browse Notes"
      url: "/notes/"
---

<script
  data-goatcounter="https://lorenzoliuzzo.goatcounter.com/count" 
  async src="//gc.zgo.at/count.js"
></script>


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