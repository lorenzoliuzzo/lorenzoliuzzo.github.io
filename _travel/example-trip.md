---
# `published: false` keeps this file out of site.travel and out of _site, so it is
# a schema you can read and copy rather than a trip that shows up on the map.
# Copy it to a new file, fill it in, and drop this line.
published: false

# --- required ---------------------------------------------------------------
title: "Iceland, the ring road"
date: 2024-07-14 # sorts the trip list; use the day you got back

# --- the map ----------------------------------------------------------------
# Every stop with `coords` becomes a pin. `route: true` also draws a line through
# them in the order written, which is what you want for a road trip and not what
# you want for a city you flew in and out of.
route: true
stops:
  - name: "Reykjavík"
    country: "Iceland"
    coords: [64.1466, -21.9426] # [latitude, longitude], decimal degrees
    date: 2024-07-01
    note: "Landed, picked up the van."
  - name: "Vík í Mýrdal"
    country: "Iceland"
    coords: [63.4194, -19.0060]
    date: 2024-07-04

# --- optional ---------------------------------------------------------------
excerpt: "Two weeks and 1,332 km, anticlockwise." # the blurb on /travel/
---

Prose goes here — the map is drawn above it automatically by `_layouts/travel.html`,
so there is no need to include anything.

Coordinates are easiest to get from openstreetmap.org: right-click the spot and
pick "Show address"; the lat/lon pair in the URL is already in the order this
file wants. A stop with no `coords` is dropped from the map rather than being
plotted at 0,0.
