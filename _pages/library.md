---
title: Library
permalink: /library/
layout: single
classes: wide
author_profile: true
---

{% assign books = site.library %}
{% assign reading = books | where: "status", "reading" %}
{% assign finished = books | where_exp: "b", "b.status != 'reading'" %}

Every book I've read, shelf by shelf, with what I made of it. {{ finished.size }} finished{% if reading.size > 0 %}, {{ reading.size }} still open{% endif %}.

{% assign shelves_str = "" %}
{% for book in books %}
  {% if book.shelf %}{% assign shelves_str = shelves_str | append: book.shelf | append: "|" %}{% endif %}
{% endfor %}
{% assign shelves = shelves_str | split: "|" | uniq | sort %}
{% assign unshelved = books | where_exp: "b", "b.shelf == nil" %}

<nav class="notes-nav">
  <ul class="taxonomy__index">
    {% for shelf in shelves %}
      {% assign on_shelf = books | where: "shelf", shelf %}
      <li>
        <a href="#{{ shelf | slugify }}">
          <strong>{{ shelf }}</strong> <span class="tag-count">{{ on_shelf.size }}</span>
        </a>
      </li>
    {% endfor %}
    {% if unshelved.size > 0 %}
      <li>
        <a href="#unshelved">
          <strong>Unshelved</strong> <span class="tag-count">{{ unshelved.size }}</span>
        </a>
      </li>
    {% endif %}
  </ul>
</nav>

{% comment %}
  Within a shelf, whatever is still open comes first — that is the part of a reading
  list that changes week to week. The rest is most-recently-finished first, with
  books whose finish date was never recorded trailing at the end rather than being
  dated by guesswork.
{% endcomment %}
{% for shelf in shelves %}
  {% assign on_shelf = books | where: "shelf", shelf %}
  {% assign shelf_reading = on_shelf | where: "status", "reading" | sort: "started" | reverse %}
  {% assign shelf_read = on_shelf | where_exp: "b", "b.status != 'reading'" | sort: "finished" | reverse %}
  {% assign ordered = shelf_reading | concat: shelf_read %}

  <section id="{{ shelf | slugify }}" class="tag-section">
    <h2 class="tag-section__title">{{ shelf }}</h2>
    {% include entry-list.html entries=ordered books=true status=true %}
    <a href="#page-title" class="back-to-top">&uarr; Back to top</a>
  </section>
{% endfor %}

{% if unshelved.size > 0 %}
  {% assign unshelved_sorted = unshelved | sort: "finished" | reverse %}
  <section id="unshelved" class="tag-section">
    <h2 class="tag-section__title">Unshelved</h2>
    {% include entry-list.html entries=unshelved_sorted books=true status=true %}
    <a href="#page-title" class="back-to-top">&uarr; Back to top</a>
  </section>
{% endif %}

{% if books.size == 0 %}
  <p class="entry-list__empty">Nothing on the shelves yet.</p>
{% endif %}
