---
layout: page
title: "Upcoming events: East"
permalink: "/area/east"
---

{% assign events = site.data.events | sort: "datetime" | where: "category", "East" %}

{% include events-list.html %}
  