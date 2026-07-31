---
title: Travel
permalink: /travel/
layout: single
classes: wide
author_profile: true
travel_map: true
---

Trips with something to say about them get a page; everywhere else is just a pin.

{% assign trips = site.travel | sort: "date" | reverse %}

{% comment %}
  A _data file holding nothing but comments parses to `false`, not to an empty
  list, and `false | sort` is a build error. So default to a genuinely empty
  array and only sort when there is something there.
{% endcomment %}
{% assign places = "" | split: "" %}
{% if site.data.places %}{% assign places = site.data.places | sort: "name" %}{% endif %}

{% include travel-map.html trips=trips places=places empty="No coordinates on the map yet." %}

## Trips

{% include entry-list.html entries=trips date=true empty="No trips written up yet." %}

{% if places.size > 0 %}
## Also been

<ul class="place-list">
  {% for place in places %}
    <li class="place-list__item">
      <span class="place-list__name">{{ place.name }}</span>
      {% if place.country %}<span class="place-list__where">{{ place.country }}</span>{% endif %}
      {% if place.year %}<span class="place-list__year">{{ place.year }}</span>{% endif %}
    </li>
  {% endfor %}
</ul>
{% endif %}
