---
# Feel free to add content and custom Front Matter to this file.
# To modify the layout, see https://jekyllrb.com/docs/themes/#overriding-theme-defaults

layout: default
---

# Upcoming events

{% assign events_sorted = site.data.events | sort: "datetime" %}

<div class="events-list">
  <h2>March</h2>
  {% for event in events_sorted %}
    <div class="event">
      <h3 class="title"><a href="#">{{ event.title }}</a></h3>
      <p class="location">{{ event.bookshop }}</p>
      <datetime>{{ event.datetime | date_to_long_string }}</datetime>
      <p class="description">{{ event.summary }}</p>
    </div>
  {% endfor %}
</div>