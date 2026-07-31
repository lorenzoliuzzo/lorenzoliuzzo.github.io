---
title: Notes Archive
permalink: /notes/
layout: single
classes: wide
author_profile: true
---

Select a topic below to jump straight to that section, or filter by title.

<div class="archive-filter">
  <input type="search" id="archive-filter" placeholder="Filter notes by title&hellip;" autocomplete="off" aria-label="Filter notes by title">
</div>
<p class="archive-filter__empty" id="archive-filter-empty" hidden>No notes match that filter.</p>

{% assign notes = site.notes | sort: "title" %}
{% assign planned = site.data.planned_notes %}

{% assign main_tags_str = "" %}
{% for note in notes %}
  {% if note.tags[0] %}{% assign main_tags_str = main_tags_str | append: note.tags[0] | append: "|" %}{% endif %}
{% endfor %}
{% for note in planned %}
  {% if note.tags[0] %}{% assign main_tags_str = main_tags_str | append: note.tags[0] | append: "|" %}{% endif %}
{% endfor %}
{% assign main_tags = main_tags_str | split: "|" | uniq | sort %}

<nav class="notes-nav">
  <ul class="taxonomy__index">
    {% for main_tag in main_tags %}
      {% assign in_main = notes | where_exp: "n", "n.tags[0] == main_tag" %}
      {% assign planned_main = planned | where_exp: "n", "n.tags[0] == main_tag" %}
      <li>
        <a href="#{{ main_tag | slugify }}">
          <strong>{{ main_tag }}</strong> <span class="tag-count">{{ in_main.size }}</span>
          {% if planned_main.size > 0 %}<span class="tag-count tag-count--planned">{{ planned_main.size }} planned</span>{% endif %}
        </a>
      </li>
    {% endfor %}
  </ul>
</nav>

{% for main_tag in main_tags %}
  {% assign in_main = notes | where_exp: "n", "n.tags[0] == main_tag" %}
  {% assign planned_main = planned | where_exp: "n", "n.tags[0] == main_tag" %}

  {% assign sub_tags_str = "" %}
  {% for note in in_main %}
    {% if note.tags[1] %}{% assign sub_tags_str = sub_tags_str | append: note.tags[1] | append: "|" %}{% endif %}
  {% endfor %}
  {% for note in planned_main %}
    {% if note.tags[1] %}{% assign sub_tags_str = sub_tags_str | append: note.tags[1] | append: "|" %}{% endif %}
  {% endfor %}
  {% assign sub_tags = sub_tags_str | split: "|" | uniq | sort %}

  <section id="{{ main_tag | slugify }}" class="tag-section">
    <h2 class="tag-section__title">{{ main_tag }}</h2>

    {% for sub_tag in sub_tags %}
      {% assign in_sub = in_main | where_exp: "n", "n.tags[1] == sub_tag" | sort: "date" | reverse %}
      {% assign planned_sub = planned_main | where_exp: "n", "n.tags[1] == sub_tag" %}
      <div class="tag-subsection" id="{{ main_tag | slugify }}-{{ sub_tag | slugify }}">
        <h3 class="tag-subsection__title">{{ sub_tag }}</h3>
        {% include entry-list.html entries=in_sub date=true status=true dense=true %}
        {% include planned-list.html entries=planned_sub %}
      </div>
    {% endfor %}

    {% assign uncategorized = in_main | where_exp: "n", "n.tags[1] == nil" | sort: "date" | reverse %}
    {% assign planned_uncat = planned_main | where_exp: "n", "n.tags[1] == nil" %}
    {% if uncategorized.size > 0 or planned_uncat.size > 0 %}
      <div class="tag-subsection">
        {% if sub_tags.size > 0 %}<h3 class="tag-subsection__title">General</h3>{% endif %}
        {% include entry-list.html entries=uncategorized date=true status=true dense=true %}
        {% include planned-list.html entries=planned_uncat %}
      </div>
    {% endif %}

    <a href="#page-title" class="back-to-top">&uarr; Back to top</a>
  </section>
{% endfor %}

{% include archive-filter.html %}
