---
# Feel free to add content and custom Front Matter to this file.
# To modify the layout, see https://jekyllrb.com/docs/themes/#overriding-theme-defaults

layout: default
---

# Upcoming events

{% assign events_sorted = site.data.events | sort: "datetime" %}

<!-- <div class="events-list">
  <h2>March</h2>
  {% for event in events_sorted %}
    <div class="event">
      <h3 class="title"><a href="#">{{ event.title }}</a></h3>
      <div class="meta">
        <p>{{ event.datetime | date_to_long_string: "ordinal", "US" }}</p>
        <p class="divider">//</p>
        <p class="location">{{ event.bookshop }}</p>
        <p class="divider">//</p>
        <p class="tag"><a href="#">{{ event.category }}</a></p>
      </div>
      <p class="description">{{ event.summary | truncatewords: 60 }}</p>
    </div>
  {% endfor %}
</div> -->

<div class="events-list">
{% for event in events_sorted %}
  {% assign currentdate = event.datetime | date: "%B" %}
  {% if currentdate != date %}
    {% unless forloop.first %}</div>{% endunless %}
    <h2 id="{{ event.datetime | date: "%B %Y"}}">{{ currentdate }}</h2>
    <div class="event">
    {% assign date = currentdate %}
  {% endif %}
    <h3 class="title"><a href="{{ event.url }}">{{ event.title }}</a></h3>
    <div class="meta">
      <p>{{ event.datetime | date_to_long_string: "ordinal", "US" }}</p>
      <p class="divider">//</p>
      <p class="location">{{ event.bookshop }}</p>
      <p class="divider">//</p>
      <p class="tag"><a href="#">{{ event.category }}</a></p>
    </div>
    <p class="description">{{ event.summary | truncatewords: 60 }}</p>
  {% if forloop.last %}</div>{% endif %}
{% endfor %}
</div>