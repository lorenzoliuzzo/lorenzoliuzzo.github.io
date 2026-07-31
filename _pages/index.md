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
    - label: "Library"
      url: "/library/"
---

<script
  data-goatcounter="https://lorenzoliuzzo.goatcounter.com/count" 
  async src="//gc.zgo.at/count.js"
></script>


## Recent Projects
{% assign projects = site.projects | sort: 'date' | reverse | slice: 0, 2 %}
{% include entry-list.html entries=projects empty="Nothing published here yet." %}
{% if projects.size > 0 %}<p><a href="/projects/" class="btn btn--primary">All Projects →</a></p>{% endif %}


## Recent Notes
{% assign notes = site.notes | where_exp: "n", "n.title and n.title != empty" | sort: 'date' | reverse | slice: 0, 3 %}
{% include entry-list.html entries=notes date=true status=true empty="Nothing published here yet." %}
{% if notes.size > 0 %}<p><a href="/notes/" class="btn btn--primary">All Notes →</a></p>{% endif %}