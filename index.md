---
# Feel free to add content and custom Front Matter to this file.
# To modify the layout, see https://jekyllrb.com/docs/themes/#overriding-theme-defaults

layout: default
---

# Upcoming events

{% assign events = site.data.events | sort: "datetime" %}

{% include events-list.html %}
