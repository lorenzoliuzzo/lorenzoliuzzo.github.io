---
title: Travel
permalink: /travel/
layout: single
classes: wide
author_profile: true
travel_map: true
---

{% assign trips = site.travel | sort: "date" | reverse %}

{% comment %}
  A _data file holding nothing but comments parses to `false`, not to an empty
  list, and `false | sort` is a build error. So default to a genuinely empty
  array and only sort when there is something there.
{% endcomment %}
{% assign places = "" | split: "" %}
{% if site.data.places %}{% assign places = site.data.places | sort: "name" %}{% endif %}

{% comment %}
  Countries are counted across both sources, so a country reached on a trip and
  later revisited as a standalone pin is still one country. Liquid has no set, so
  it goes via append/split/uniq — the same trick trip-meta.html uses per trip.
{% endcomment %}
{% assign countries_str = "" %}
{% for trip in trips %}
  {% for stop in trip.stops %}
    {% if stop.country %}{% assign countries_str = countries_str | append: stop.country | append: "|" %}{% endif %}
  {% endfor %}
{% endfor %}
{% for place in places %}
  {% if place.country %}{% assign countries_str = countries_str | append: place.country | append: "|" %}{% endif %}
{% endfor %}
{% assign countries = countries_str | split: "|" | uniq %}

Trips with something to say about them get a page; everywhere else is just a pin.
{% if trips.size > 0 or places.size > 0 %}
{{ trips.size }} trip{% if trips.size != 1 %}s{% endif %}{% if places.size > 0 %}, {{ places.size }} other place{% if places.size != 1 %}s{% endif %}{% endif %}{% if countries.size > 0 %}, {{ countries.size }} countr{% if countries.size == 1 %}y{% else %}ies{% endif %}{% endif %}.
{% endif %}

{% include travel-map.html trips=trips places=places empty="No coordinates on the map yet." %}

## Trips

{% include entry-list.html entries=trips trips=true empty="No trips written up yet." %}

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
