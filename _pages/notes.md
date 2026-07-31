---
title: Notes Archive
permalink: /notes/
layout: single
classes: wide
author_profile: true
---

Select a tag below to jump straight to that topic.

{% assign all_tags = site.notes | map: "tags" | join: "," | split: "," | sort %}
{% assign unique_tags = all_tags | uniq %}

<div class="tag-cloud">
  <ul class="taxonomy__index">
    {% for tag in unique_tags %}
      {% assign tagged = site.notes | where_exp: "n", "n.tags contains tag" %}
      <li>
        <a href="#{{ tag | slugify }}">
          <strong>{{ tag }}</strong> <span class="tag-count">{{ tagged.size }}</span>
        </a>
      </li>
    {% endfor %}
  </ul>
</div>

{% for tag in unique_tags %}
  {% assign tagged = site.notes | where_exp: "n", "n.tags contains tag" | sort: 'date' | reverse %}
  <section id="{{ tag | slugify }}" class="tag-section">
    <h2 class="tag-section__title">{{ tag }}</h2>
    {% include entry-list.html entries=tagged date=true status=true %}
    <a href="#page-title" class="back-to-top">&uarr; Back to top</a>
  </section>
{% endfor %}