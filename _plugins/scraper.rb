require 'httparty'
require 'nokogiri'
require 'json'
require 'date'
require 'time'
require 'pry'

def scrape_burley_fisher
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

def scrape_pages(branch)
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

def scrape_broadway_books
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

def scrape_all
  all_events = Array.new
  all_events << scrape_burley_fisher
  all_events << scrape_pages('hackney')
  all_events << scrape_pages('cheshire street')
  File.open("./_data/events.json", "w") do |file|
    file.write(JSON.pretty_generate(all_events.flatten))
  end
end

scrape_all
