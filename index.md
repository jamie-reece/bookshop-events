---
# Feel free to add content and custom Front Matter to this file.
# To modify the layout, see https://jekyllrb.com/docs/themes/#overriding-theme-defaults

layout: default
---

{{ site.time | date: '%d %B, %Y' }}

# Upcoming events

{% assign events_sorted = site.data.events | sort: "datetime" | reverse %}

<div class="events-list">
  <h2>March</h2>
  {% for event in events_sorted %}
    <div class="event">
      <h3 class="title"><a href="#">{{ event.title }}</a></h3>
      <div class="meta">
        <p>{{ event.datetime | date: '%d %B, %Y' }}</p>
        <p class="divider">//</p>
        <p class="location">{{ event.bookshop }}</p>
        <p class="divider">//</p>
        <p class="tag"><a href="#">{{ event.category }}</a></p>
      </div>
      <p class="description">{{ event.summary | truncatewords: 60 }}</p>
    </div>
  {% endfor %}
</div>