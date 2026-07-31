---
title: Notes Archive
permalink: /notes/
layout: single
classes: wide
author_profile: true
---

Select a topic below to jump straight to that section.

{% assign notes = site.notes | sort: "title" %}

{% assign main_tags_str = "" %}
{% for note in notes %}
  {% if note.tags[0] %}{% assign main_tags_str = main_tags_str | append: note.tags[0] | append: "|" %}{% endif %}
{% endfor %}
{% assign main_tags = main_tags_str | split: "|" | uniq | sort %}

<nav class="notes-nav">
  <ul class="taxonomy__index">
    {% for main_tag in main_tags %}
      {% assign in_main = notes | where_exp: "n", "n.tags[0] == main_tag" %}
      <li>
        <a href="#{{ main_tag | slugify }}">
          <strong>{{ main_tag }}</strong> <span class="tag-count">{{ in_main.size }}</span>
        </a>
      </li>
    {% endfor %}
  </ul>
</nav>

{% for main_tag in main_tags %}
  {% assign in_main = notes | where_exp: "n", "n.tags[0] == main_tag" %}

  {% assign sub_tags_str = "" %}
  {% for note in in_main %}
    {% if note.tags[1] %}{% assign sub_tags_str = sub_tags_str | append: note.tags[1] | append: "|" %}{% endif %}
  {% endfor %}
  {% assign sub_tags = sub_tags_str | split: "|" | uniq | sort %}

  <section id="{{ main_tag | slugify }}" class="tag-section">
    <h2 class="tag-section__title">{{ main_tag }}</h2>

    {% for sub_tag in sub_tags %}
      {% assign in_sub = in_main | where_exp: "n", "n.tags[1] == sub_tag" | sort: "date" | reverse %}
      <div class="tag-subsection">
        <h3 class="tag-subsection__title">{{ sub_tag }}</h3>
        {% include entry-list.html entries=in_sub date=true status=true %}
      </div>
    {% endfor %}

    {% assign uncategorized = in_main | where_exp: "n", "n.tags[1] == nil" | sort: "date" | reverse %}
    {% if uncategorized.size > 0 %}
      <div class="tag-subsection">
        {% if sub_tags.size > 0 %}<h3 class="tag-subsection__title">General</h3>{% endif %}
        {% include entry-list.html entries=uncategorized date=true status=true %}
      </div>
    {% endif %}

    <a href="#page-title" class="back-to-top">&uarr; Back to top</a>
  </section>
{% endfor %}
