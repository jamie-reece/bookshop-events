---
layout: page
title: "Upcoming events: Central"
permalink: "/area/central"
---

{% assign events = site.data.events | sort: "datetime" | where: "category", "Central" %}

{% include events-list.html %}
  