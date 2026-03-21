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

<div class="tag-cloud" style="margin-top: 20px; margin-bottom: 40px;">
  <ul class="taxonomy__index" style="display: flex; flex-wrap: wrap; list-style: none; padding: 0; gap: 10px;">
    {% for tag in unique_tags %}
      {% assign count = 0 %}
      {% for t in all_tags %}{% if t == tag %}{% assign count = count | plus: 1 %}{% endif %}{% endfor %}
      <li>
        <a href="#{{ tag | slugify }}" style="padding: 5px 15px; background: #eee; border-radius: 20px; text-decoration: none; color: #333; font-size: 0.9rem;">
          <strong>{{ tag }}</strong> <small style="margin-left: 5px;">({{ count }})</small>
        </a>
      </li>
    {% endfor %}
  </ul>
</div>

<hr>

<div class="entries-wrapper" style="margin-top: 25px;">
  {% for tag in unique_tags %}
    <section id="{{ tag | slugify }}" style="margin-bottom: 50px;">
      <h2 style="border-bottom: 2px solid; padding-bottom: 10px;">
        {{ tag }}
      </h2>
      
      <ul style="list-style: none; padding: 0;">
        {% for note in site.notes %}
          {% if note.tags contains tag %}
            <li style="margin-bottom: 20px;">
              <h3 style="margin: 0;">
                <a href="{{ note.url | relative_url }}" style="text-decoration: none;">
                  {{ note.title | default: "Untitled Note" }}
                </a>
              </h3>
              <small style="color: #666;">
                {{ note.date | date: "%B %d, %Y" }}
              </small>
              {% if note.excerpt %}
                <p style="margin: 5px 0 0 0; font-size: 0.95rem; color: #444;">
                  {{ note.excerpt | strip_html | truncate: 150 }}
                </p>
              {% endif %}
            </li>
          {% endif %}
        {% endfor %}
      </ul>
      
      <a href="#page-title" style="font-size: 0.8rem; color: #999;">&uarr; Back to Top</a>
    </section>
  {% endfor %}
</div>