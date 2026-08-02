// Draws the maps emitted by _includes/travel-map.html. Loaded only on pages with
// `travel_map: true` in their front matter — see _includes/footer/custom.html.
(function () {
  "use strict";

  var TILE_URL = "https://tile.openstreetmap.org/{z}/{x}/{y}.png";
  var ATTRIBUTION =
    '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors';

  // Popups are built as DOM nodes rather than an HTML string: the text comes from
  // front matter the author writes freehand, and a place name with an angle
  // bracket in it should stay a place name.
  function popup(point, tripTitle, tripUrl) {
    var root = document.createElement("div");
    root.className = "travel-popup";

    var name = document.createElement("strong");
    name.className = "travel-popup__name";
    name.textContent = point.name;
    root.appendChild(name);

    var meta = [point.place, point.when].filter(Boolean).join(" · ");
    if (meta) {
      var metaEl = document.createElement("p");
      metaEl.className = "travel-popup__meta";
      metaEl.textContent = meta;
      root.appendChild(metaEl);
    }

    if (point.note) {
      var note = document.createElement("p");
      note.className = "travel-popup__note";
      note.textContent = point.note;
      root.appendChild(note);
    }

    if (tripUrl) {
      var link = document.createElement("a");
      link.className = "travel-popup__link";
      link.href = tripUrl;
      link.textContent = tripTitle;
      root.appendChild(link);
    }

    return root;
  }

  function marker(point, variant) {
    return L.circleMarker([point.lat, point.lng], {
      radius: 6,
      weight: 2,
      // Colours live in _sass/_travel.scss so the pins follow the theme toggle.
      // Leaflet writes fill/stroke as SVG presentation attributes, which any CSS
      // declaration outranks, so styling by class works without !important.
      className: "travel-pin travel-pin--" + variant
    });
  }

  // A dash pattern alone is hard to tell apart at a glance, especially between
  // similar ones (bike vs. hiking). Dropped at the route's midpoint rather than
  // an endpoint, which is already busy with a stop pin and its popup.
  function emojiMarker(latlng, emoji) {
    return L.marker(latlng, {
      icon: L.divIcon({
        className: "travel-route-emoji",
        html: emoji,
        iconSize: [24, 24]
      }),
      keyboard: false,
      interactive: false
    });
  }

  function render(container) {
    var payloadEl = document.getElementById(container.id + "-data");
    if (!payloadEl) return;

    var data;
    try {
      data = JSON.parse(payloadEl.textContent);
    } catch (e) {
      console.error("travel-map: could not parse payload for #" + container.id, e);
      return;
    }

    var map = L.map(container, {
      // The map is embedded mid-page, so grabbing the wheel would trap the reader
      // inside it. Zoom is enabled on click and dropped again on blur.
      scrollWheelZoom: false,
      worldCopyJump: true
    });

    L.tileLayer(TILE_URL, { maxZoom: 18, attribution: ATTRIBUTION }).addTo(map);

    map.on("click", function () {
      map.scrollWheelZoom.enable();
    });
    map.on("mouseout", function () {
      map.scrollWheelZoom.disable();
    });

    var bounds = [];

    (data.trips || []).forEach(function (trip) {
      var line = [];

      trip.stops.forEach(function (stop) {
        var latlng = [stop.lat, stop.lng];
        line.push(latlng);
        bounds.push(latlng);
        marker(stop, "trip")
          .bindPopup(popup(stop, trip.title, trip.url))
          .addTo(map);
      });

      if (trip.route && line.length > 1) {
        // `type` is slugified server-side (see travel-map.html), so it is safe to
        // concatenate into a class. Each trip type gets its own dash pattern.
        var routeClass = "travel-route";
        if (trip.type) routeClass += " travel-route--" + trip.type;

        // `geometry` traces the actual roads driven, precomputed with OSRM. Fall
        // back to straight lines between stops when a trip doesn't have one.
        var routeLine = trip.geometry && trip.geometry.length > 1 ? trip.geometry : line;

        L.polyline(routeLine, { weight: 2, className: routeClass }).addTo(map);

        if (trip.emoji) {
          var midpoint = routeLine[Math.floor(routeLine.length / 2)];
          emojiMarker(midpoint, trip.emoji).addTo(map);
        }
      }
    });

    (data.places || []).forEach(function (place) {
      bounds.push([place.lat, place.lng]);
      marker(place, "place").bindPopup(popup(place)).addTo(map);
    });

    if (bounds.length > 1) {
      map.fitBounds(bounds, { padding: [32, 32] });
    } else if (bounds.length === 1) {
      map.setView(bounds[0], 6);
    } else {
      map.setView([20, 0], 2);
    }
  }

  function init() {
    if (typeof L === "undefined") {
      console.error("travel-map: Leaflet failed to load");
      return;
    }
    document.querySelectorAll("[data-travel-map]").forEach(render);
  }

  // Loaded with `defer`, so the document is already parsed by the time this runs.
  // The readyState check is only here for the case where it is ever loaded async.
  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", init);
  } else {
    init();
  }
})();
