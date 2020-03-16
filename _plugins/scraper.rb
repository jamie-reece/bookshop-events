require 'httparty'
require 'nokogiri'
require 'json'
require 'date'
require 'time'
require 'pry'

def write_to_file(data)
  File.open("./_data/events.json", "w") do |file|
    file.write(JSON.pretty_generate(data))
  end
end

def burley_fisher
  base_url = "https://burleyfisherbooks.com"
  slug = "/events/"
  url = base_url + slug
  unparsed_page = HTTParty.get(url)
  parsed_page = Nokogiri::HTML(unparsed_page)
  events_list = parsed_page.css("div.tribe-events-loop")
  events_list_items = events_list.css("div.tribe-clearfix")
  puts "Found #{events_list_items.count} events at #{url}"
  events = Array.new
  events_list_items.each_with_index do |event_list_item, index|
    event = {
      index: index,
      bookshop: "Burley Fisher Books",
      category: "East",
      title: event_list_item.css("h3.tribe-events-list-event-title").text.strip,
      date_string: event_list_item.css("div.tribe-event-schedule-details").text.strip,
      datetime: DateTime.parse(event_list_item.css("div.tribe-event-schedule-details").text.strip, "%d %B @ %l:%M %P"),
      url: event_list_item.css("a.tribe-event-url")[0].attributes["href"].value,
      summary: event_list_item.css("div.tribe-events-list-event-description").text.strip.split("\n").first,
      img_src: event_list_item.css("div.tribe-events-event-image img")[0].attributes["src"].value
    }
    puts "#{event[:index]+1} #{event[:title]}"
    events << event
  end
  return events
end

def pages(branch)
  base_url = branch == "hackney" ? "https://pagesof#{branch}.co.uk" : "https://pages#{branch.gsub(/\s/,'')}.co.uk"
  slug = "/events/"
  url = base_url + slug
  unparsed_page = HTTParty.get(url)
  parsed_page = Nokogiri::HTML(unparsed_page)
  events_list = parsed_page.css("div.tribe-events-loop")
  events_list_items = events_list.css("div.tribe-clearfix")
  puts "Found #{events_list_items.count} events at #{url}"
  events = Array.new
  events_list_items.each_with_index do |event_list_item, index|
    event = {
      index: index,
      bookshop: branch == "hackney" ? "Pages of #{branch.capitalize}" : "Pages #{branch.capitalize}",
      category: "East",
      title: event_list_item.css("h3.tribe-events-list-event-title").text.strip.gsub(/^Event ./,""),
      date_string: event_list_item.css("div.tribe-event-schedule-details").text.strip,
      datetime: DateTime.parse(event_list_item.css("div.tribe-event-schedule-details").text.strip, "%d %B @ %l:%M %P"),
      url: event_list_item.css("a.tribe-event-url")[0].attributes["href"].value,
      summary: event_list_item.css("div.tribe-events-list-event-description").text.strip.split("\n").first,
      img_src: event_list_item.css("div.tribe-events-event-image a.img_quick_view")[0].attributes["href"].value
    }
    puts "#{event[:index]+1} #{event[:title]}"
    events << event
  end
  return events
end

def broadway_bookshop
  base_url = "https://broadwaybookshophackney.com"
  slug = "/events/"
  url = base_url + slug
  unparsed_page = HTTParty.get(url)
  parsed_page = Nokogiri::HTML(unparsed_page)
  events = Array.new
  counter = 0
  counter_end = parsed_page.css("div#content h3.news").length
  while counter < counter_end
    puts "#{counter}"
    event = {
      title: "#{parsed_page.css("div#content h3.news")[counter].text}",
      date_string: "#{parsed_page.css("div#content p.pub")[counter].css("strong").text}",
      # datetime: "#{DateTime.parse(parsed_page.css("div#content p.pub")[counter].css("strong").text, "%A, %d %B")}",
      desc: "#{parsed_page.css("div#content p.pub")[counter].next_element.text}"
    }
    events << event
    counter += 1
  end
  File.open("./_data/events.json", "w") do |file|
    file.write(JSON.pretty_generate(events))
  end
end

def libreria
  base_url = "https://libreria.io/"
  slug = "cultural-programme/"
  url = base_url + slug
  unparsed_page = HTTParty.get(url)
  parsed_page = Nokogiri::HTML(unparsed_page)
  events_list = parsed_page.css("div#whats-content ul")
  events_list_items = events_list.css("li.whats-on-post")
  puts "Found #{events_list_items.count} events at #{url}"
  # binding.pry
  events = Array.new
  events_list_items.each_with_index do |event_list_item, index|
    event = {
      index: index,
      bookshop: "Libreria",
      category: "East",
      title: event_list_item.css("h2.sml").text.strip,
      date_string: event_list_item.css("div.date").text.strip,
      datetime: (DateTime.parse(event_list_item.css("div.date").text.strip,"%d %B %Y") rescue nil),
      url: base_url + slug + event_list_item.attributes["data-url"].value[1..-1],
      summary: libreria_modal(base_url + slug + event_list_item.attributes["data-url"].value[1..-1]),
      img_src: event_list_item.css("div.image img")[0].attributes["src"].value
    }
    puts "#{event[:index]+1} #{event[:title]}"
    events << event
  end
  return events
end

def libreria_modal(url)
  unparsed_page = HTTParty.get(url)
  parsed_page = Nokogiri::HTML(unparsed_page)
  # date = parsed_page.css("section.left").css("div.date").text.strip
  desc = parsed_page.css("section.left").css("div.copy p").text
  return desc
end

def lrb
  base_url = "https://www.lrb.co.uk/"
  slug = "events/"
  url = base_url + slug
  unparsed_page = HTTParty.get(url)
  parsed_page = Nokogiri::HTML(unparsed_page)
  events_list = parsed_page.css("div.eventspage-list--contents")
  events_list_items = events_list.css("div.eventspage-list--item")
  puts "Found #{events_list_items.count} events at #{url}"
  # binding.pry
  events = Array.new
  events_list_items.each_with_index do |event_list_item, index|
    event = {
      index: index,
      bookshop: "London Review Bookshop",
      category: "Central",
      title: event_list_item.css("div.itemContents div.title h2 a").text.strip,
      date_string: event_list_item.css("div.itemContents div.date").text.strip,
      datetime: (DateTime.parse(event_list_item.css("div.itemContents div.date").text.strip,"%d %B %Y at %l:%M%p") rescue nil),
      url: event_list_item.css("div.itemContents div.title h2 a")[0].attributes["href"].value,
      summary: lrb_modal(event_list_item.css("div.itemContents div.title h2 a")[0].attributes["href"].value),
      img_src: event_list_item.css("div.itemImage-holder span")[0].attributes["data-bg"].value
    }
    puts "#{event[:index]+1} #{event[:title]}"
    events << event
  end
  # write_to_file(events)
  return events
end

def lrb_modal(url)
  unparsed_page = HTTParty.get(url)
  parsed_page = Nokogiri::HTML(unparsed_page)
  desc = parsed_page.css("div.js-xd-read-more-contents p").text
  return desc
end

# lrb

def scrape
  all_events = Array.new
  all_events << burley_fisher
  all_events << pages('hackney')
  all_events << pages('cheshire street')
  all_events << libreria
  all_events << lrb
  arr = all_events.flatten.select { |event| event[:datetime] }
  now = DateTime.now
  upcoming_events = arr.delete_if { |event| event[:datetime] < now }
  write_to_file(upcoming_events)
end

scrape

# def brick_lane_bookshop
#   url = https://www.bricklanebookshop.org/events.html
# end

# def newham_bookshop
#   url = https://www.newhambooks.co.uk/
# end

# def white_review
#   url = https://www.thewhitereview.org/news_and_events/
# end

# def rsl
#   url = https://rsliterature.org/whats-on/
# end

# def daunt
#   url = https://dauntbooks.co.uk/events/
# end

# def foyles
# end

# def waterstones
# end

# def gays_the_word
# end

# def spineless
# end

# def dinner_party
# end
