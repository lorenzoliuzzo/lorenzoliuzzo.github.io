---
title: References
permalink: /references/
layout: single
classes: wide
author_profile: true
---

Every work the notes cite, with the notes that cite it. A note numbers its references in order of first appearance; this page is the one list behind all of them.

{% assign works = site.data.papers | sort: "year" %}
{% assign cited_count = 0 %}
<ol class="references__list references__list--all">
{% for paper in works %}
  {% assign citing = site.data.citation_index[paper.id] %}
  <li id="ref-{{ paper.id }}" class="reference">
    {% include reference-entry.html paper=paper also=false %}
    {% if citing.size > 0 %}
      <span class="reference__also">Cited in
        {%- for n in citing %} <a href="{{ n.url | relative_url }}">{{ n.title }}</a>{% unless forloop.last %},{% endunless %}{% endfor %}.</span>
    {% else %}
      <span class="reference__also reference__also--none">Not cited by any note yet.</span>
    {% endif %}
  </li>
{% endfor %}
</ol>
