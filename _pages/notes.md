---
title: Notes Archive
permalink: /notes/
layout: single
classes: wide
author_profile: true
---

Select a course or topic below to jump straight to that section, filter by title,
or fold the parts away to skim the outline. Within a course the notes are numbered
in reading order.

<div class="archive-controls">
  <div class="archive-filter">
    <input type="search" id="archive-filter" placeholder="Filter notes by title&hellip;" autocomplete="off" aria-label="Filter notes by title">
  </div>
  <button type="button" class="fold-toggle" id="fold-toggle" hidden>Collapse all</button>
</div>
<p class="archive-filter__empty" id="archive-filter-empty" hidden>No notes match that filter.</p>

{% assign notes = site.notes | sort: "title" %}
{% assign planned = site.data.planned_notes %}
{% assign courses = site.data.courses %}

{% comment %}
  Courses (_data/courses.yml) come first, in the order the file lists them. Notes
  that a course lists are drawn inside it; everything else is `loose` and keeps the
  old grouping by tag below. Liquid has no set, so claimed paths go into one
  delimited string and membership is a `contains` on "|path|".
{% endcomment %}
{% assign claimed = "|" %}
{% for course in courses %}
  {% for part in course.parts %}
    {% for p in part.notes %}
      {% assign claimed = claimed | append: "_notes/" | append: p | append: ".md|" %}
    {% endfor %}
  {% endfor %}
{% endfor %}

{% assign loose = "" | split: "" %}
{% for n in notes %}
  {% assign key = "|" | append: n.relative_path | append: "|" %}
  {% unless claimed contains key %}{% assign loose = loose | push: n %}{% endunless %}
{% endfor %}
{% assign planned_loose = "" | split: "" %}
{% for n in planned %}
  {% assign key = "|" | append: n.path | append: "|" %}
  {% unless claimed contains key %}{% assign planned_loose = planned_loose | push: n %}{% endunless %}
{% endfor %}

{% assign main_tags_str = "" %}
{% for note in loose %}
  {% if note.tags[0] %}{% assign main_tags_str = main_tags_str | append: note.tags[0] | append: "|" %}{% endif %}
{% endfor %}
{% for note in planned_loose %}
  {% if note.tags[0] %}{% assign main_tags_str = main_tags_str | append: note.tags[0] | append: "|" %}{% endif %}
{% endfor %}
{% assign main_tags = main_tags_str | split: "|" | uniq | sort %}

<nav class="notes-nav">
  <ul class="taxonomy__index">
    {% for course in courses %}
      {% assign written = 0 %}
      {% assign upcoming = 0 %}
      {% for part in course.parts %}
        {% for p in part.notes %}
          {% assign rel = "_notes/" | append: p | append: ".md" %}
          {% assign doc = notes | where: "relative_path", rel | first %}
          {% if doc %}{% assign written = written | plus: 1 %}{% else %}{% assign upcoming = upcoming | plus: 1 %}{% endif %}
        {% endfor %}
      {% endfor %}
      <li>
        <a href="#{{ course.title | slugify }}">
          <strong>{{ course.title }}</strong> <span class="tag-count">{{ written }}</span>
          {% if upcoming > 0 %}<span class="tag-count tag-count--planned">{{ upcoming }} planned</span>{% endif %}
        </a>
      </li>
    {% endfor %}
    {% for main_tag in main_tags %}
      {% assign in_main = loose | where_exp: "n", "n.tags[0] == main_tag" %}
      {% assign planned_main = planned_loose | where_exp: "n", "n.tags[0] == main_tag" %}
      <li>
        <a href="#{{ main_tag | slugify }}">
          <strong>{{ main_tag }}</strong> <span class="tag-count">{{ in_main.size }}</span>
          {% if planned_main.size > 0 %}<span class="tag-count tag-count--planned">{{ planned_main.size }} planned</span>{% endif %}
        </a>
      </li>
    {% endfor %}
  </ul>
</nav>

{% for course in courses %}
  {% assign cslug = course.title | slugify %}
  {% assign total = 0 %}
  {% assign done = 0 %}
  {% assign first_doc = nil %}
  {% for part in course.parts %}
    {% for p in part.notes %}
      {% assign total = total | plus: 1 %}
      {% assign rel = "_notes/" | append: p | append: ".md" %}
      {% assign doc = notes | where: "relative_path", rel | first %}
      {% if doc %}
        {% assign done = done | plus: 1 %}
        {% unless first_doc %}{% assign first_doc = doc %}{% endunless %}
      {% endif %}
    {% endfor %}
  {% endfor %}
  <section id="{{ cslug }}" class="tag-section course-section">
    <h2 class="tag-section__title">{{ course.title }}</h2>
    {% if course.summary or course.reference %}
      <p class="course-intro">
        {{ course.summary }}
        {% if course.reference %}<a href="{{ course.reference | relative_url }}">Technical reference (PDF)</a>{% endif %}
      </p>
    {% endif %}
    <div class="course-progress">
      <span class="course-progress__bar" role="img" aria-label="{{ done }} of {{ total }} notes written"><span style="width: {{ done | times: 100 | divided_by: total }}%"></span></span>
      <span class="course-progress__text">{{ done }} of {{ total }} notes written</span>
      {% if first_doc %}<a class="course-progress__start" href="{{ first_doc.url | relative_url }}">Start with {{ first_doc.title }} &rarr;</a>{% endif %}
    </div>

    {% assign n = 0 %}
    {% for part in course.parts %}
      {% assign written = 0 %}
      {% assign upcoming = 0 %}
      {% for p in part.notes %}
        {% assign rel = "_notes/" | append: p | append: ".md" %}
        {% assign doc = notes | where: "relative_path", rel | first %}
        {% if doc %}{% assign written = written | plus: 1 %}{% else %}{% assign upcoming = upcoming | plus: 1 %}{% endif %}
      {% endfor %}
      {% assign hue = forloop.index0 | modulo: 6 | plus: 1 %}
      <details class="tag-subsection" id="{{ cslug }}-{{ part.title | slugify }}" style="--part: var(--hue-{{ hue }})" open>
        <summary class="tag-subsection__summary">
          <span class="part-dot" aria-hidden="true"></span>
          <h3 class="tag-subsection__title">{{ part.title }}</h3>
          <span class="tag-count">{{ written }}</span>
          {% if upcoming > 0 %}<span class="tag-count tag-count--planned">{{ upcoming }} planned</span>{% endif %}
        </summary>
        {% if part.blurb %}<p class="part-blurb">{{ part.blurb }}</p>{% endif %}
        <div class="entry-list entry-list--dense">
          {% for p in part.notes %}
            {% assign rel = "_notes/" | append: p | append: ".md" %}
            {% assign doc = notes | where: "relative_path", rel | first %}
            {% if doc %}
              {% assign n = n | plus: 1 %}
              <article class="entry-card entry-card--dense">
                <h3 class="entry-card__title"><span class="entry-card__num">{{ n }}</span><a href="{{ doc.url | relative_url }}">{{ doc.title | default: "Untitled" }}</a></h3>
                <div class="entry-card__aside">
                  {% include note-status.html document=doc compact=true %}
                  {% if doc.date %}<p class="entry-card__meta"><time datetime="{{ doc.date | date_to_xmlschema }}">{{ doc.date | date: site.date_format }}</time></p>{% endif %}
                </div>
              </article>
            {% else %}
              {% assign stub = planned | where: "path", rel | first %}
              <div class="planned-list__item">
                <span class="planned-list__title"><span class="entry-card__num">&middot;</span>{{ stub.title | default: p }}</span>
                <span class="planned-list__badge">planned</span>
              </div>
            {% endif %}
          {% endfor %}
        </div>
      </details>
    {% endfor %}

    <a href="#page-title" class="back-to-top">&uarr; Back to top</a>
  </section>
{% endfor %}

{% for main_tag in main_tags %}
  {% assign in_main = loose | where_exp: "n", "n.tags[0] == main_tag" %}
  {% assign planned_main = planned_loose | where_exp: "n", "n.tags[0] == main_tag" %}

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
      <details class="tag-subsection" id="{{ main_tag | slugify }}-{{ sub_tag | slugify }}" open>
        <summary class="tag-subsection__summary">
          <h3 class="tag-subsection__title">{{ sub_tag }}</h3>
          <span class="tag-count">{{ in_sub.size }}</span>
          {% if planned_sub.size > 0 %}<span class="tag-count tag-count--planned">{{ planned_sub.size }} planned</span>{% endif %}
        </summary>
        {% include entry-list.html entries=in_sub date=true status=true dense=true %}
        {% include planned-list.html entries=planned_sub %}
      </details>
    {% endfor %}

    {% assign uncategorized = in_main | where_exp: "n", "n.tags[1] == nil" | sort: "date" | reverse %}
    {% assign planned_uncat = planned_main | where_exp: "n", "n.tags[1] == nil" %}
    {% if uncategorized.size > 0 or planned_uncat.size > 0 %}
      {% if sub_tags.size > 0 %}
        <details class="tag-subsection" id="{{ main_tag | slugify }}-general" open>
          <summary class="tag-subsection__summary">
            <h3 class="tag-subsection__title">General</h3>
            <span class="tag-count">{{ uncategorized.size }}</span>
            {% if planned_uncat.size > 0 %}<span class="tag-count tag-count--planned">{{ planned_uncat.size }} planned</span>{% endif %}
          </summary>
          {% include entry-list.html entries=uncategorized date=true status=true dense=true %}
          {% include planned-list.html entries=planned_uncat %}
        </details>
      {% else %}
        <div class="tag-subsection">
          {% include entry-list.html entries=uncategorized date=true status=true dense=true %}
          {% include planned-list.html entries=planned_uncat %}
        </div>
      {% endif %}
    {% endif %}

    <a href="#page-title" class="back-to-top">&uarr; Back to top</a>
  </section>
{% endfor %}

{% include archive-filter.html %}
