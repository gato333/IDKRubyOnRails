# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require "scrap/art_beat_scrapper"
require "scrap/artslant_scrapper"
require "scrap/eventbrite_scrapper"
require "scrap/ny_card_scrapper"

EventResult.delete_all

#EventResult.create( name: "yo")
es = EventbriteScrapper.new
es.scrap

=begin
#**************************************#
# 		Eventbrite Scrapper 		
#**************************************#
eventbrite_source = 'eventbrite'
pagecount = 1
urlbeg = "https://www.eventbrite.com/d/ny--manhattan/events--today/?"
urlend = "&slat=40.7831&slng=-73.9712&sort=best"

#pagination
loop do 
	page = "page=" + pagecount.to_s
	puts page
	html = Nokogiri::HTML(open(urlbeg + page + urlend))

	events = html.css(".js-event-list-container.l-block-stack div.l-block-2")
	break if events.empty?
	pagecount += 1

	events.each do |e|
		link =  e.css("a.js-search-result-click-action")[0]["href"]
		imglink = e.css(".list-card__header img")[0]["src"]
		price = e.css(".list-card__header span.list-card__label").text
		name = e.css(".list-card__body .list-card__title").text.split.join(" ")
		date = e.css(".list-card__body .list-card__date").text.split.join(" ")
		address = e.css(".list-card__body .list-card__venue").text.split.join(" ")
		org = e.css(".list-card__body .list-card__organizer").text.split.join(" ")
		geo = e.css(".list-card__body .list-card__venue span[itemprop='geo']")
		lat = geo.css("meta[itemprop='latitude']")[0]["content"]
		long = geo.css("meta[itemprop='longitude']")[0]["content"]
		EventResult.create!( name: name[0..98].gsub(/\s\w+\s*$/,'...'), price: price, lat: lat, long: long, address: address, imageurl: imglink ? imglink : '' , eventurl: link , startdate: date, enddate: "", description: '', types: '', source: eventbrite_source)
	end
end


#**************************************#
# 	Artslant Scrapper 		
#**************************************#
#for some reason artslant needs the tomorrow date to get "todays" openings (dum)
dateTomorrow = time.month.to_s + "/" + (time.day.to_i + 1).to_s  + "/" + time.year.to_s
artslanturl = "http://www.artslant.com/ny/events/list?featured=all&fromdate=#{dateTomorrow}&listtype=openings&todate=#{dateTomorrow}"
artslant_source = 'artslant'
pagecount = 1
Geocoder.configure(:lookup   => :dstk)

loop do 
	page = "&page=" + pagecount.to_s
	html = Nokogiri::HTML(open(artslanturl + page))
	events = html.css("tbody#thelist tr.t1")

	break if events.empty?
	pagecount += 1

	events.each do |e|
		imglink =  e.css("span.imagethumbfield img")[0]["src"]
		tableright = e.css("td table tr td")[1]
		date = time.to_date.to_s + " " + e.css("td table tr td")[2].css("b span").text.split("-")[0]
		enddate = time.to_date.to_s + e.css("td table tr td")[2].css("b span").text.split("-")[1]

		link = "http://www.artslant.com" + ( tableright.css("a")[1].nil? ? tableright.css("a")[0]["href"] : tableright.css("a")[1]["href"] )
		name = tableright.css("a span.artist").text.split.join(" ") + ": " + tableright.css("a i").text.split.join(" ")
		
		rightarray = tableright.text.split(/\n/).reject(&:empty?).reject(&:blank?)
		address =  rightarray[3] + " " + rightarray[4]

		geo = Geocoder.coordinates(address)

		lat = geo.nil? ? "" : geo[0]
		long = geo.nil? ? "" : geo[1]
		org = rightarray[1]

		EventResult.create!( name: name[0..98].gsub(/\s\w+\s*$/,'...'), price: "free", lat: lat, long: long, address: address, imageurl: imglink , eventurl: link , startdate: date, enddate: enddate, description: "", types: "art, art gallery openings", source: artslant_source)
	end
end


#**************************************#
# 	NYArtBeat Scrapper 		
#**************************************#

nyartbeaturl = "http://www.nyartbeat.com/list/event_opening"
nyartbeat_source = "nyartbeat"

html = Nokogiri::HTML(open(nyartbeaturl))
container = html.css("ul.longsmartlist")[0]
events = container.css("> li")

events.each do |e|
	name = e.css("h4 a").text.split.join(" ")
	imglink = "http://www.nyartbeat.com/" + e.css("div.smartpic_m a img")[0]["src"]
	link = e.css("div.smartpic_m a")[0]["href"]

	addressholder =  e.css("div.smart_details ul li")[2]
	address = addressholder.css("span").text

	datecontainer = e.css("div.smart_details ul li")[4]
	date = datecontainer.text.scan( /\d{2}\:\d{2}/ )
	startdate = time.to_date.to_s + " " + date[0]
	enddate = time.to_date.to_s + " " + date[1]

	geo = Geocoder.coordinates(address)
	lat = geo.nil? ? "" : geo[0]
	long = geo.nil? ? "" : geo[1]

	orgcontainer = e.css("div.smart_details ul li")[0]
	org = orgcontainer.text.split.join(" ")[3..-1]

	EventResult.create!( name: name[0..98].gsub(/\s\w+\s*$/,'...'), price: "free", lat: lat, long: long, address: address, imageurl: imglink , eventurl: link , startdate: startdate, enddate: enddate, description: "", types: "art, art gallery openings", source: nyartbeat_source)
end


#**************************************#
# 	NYCard Scrapper 		
#**************************************#

artcardsurl = "http://artcards.cc/"
artcards_source = "artcards"

html = Nokogiri::HTML(open(artcardsurl))

container = html.css("section")[1]
events = container.css("article")

events.each do |e|
	name = e.css("span[itemprop='name']").text.split.join(" ")
	imglink = e.css("a.thumb img")[0]["src"]
	link = e.css("a.thumb")[0]["href"]
	org = e.css("div[itemprop='location'] a[itemprop='url'] span").text.split.join(" ")

	address =  e.css("div[itemprop='location'] a.map-link").text.split.join(" ")
	geo = Geocoder.coordinates(address)
	lat = geo.nil? ? "" : geo[0]
	long = geo.nil? ? "" : geo[1]

	datecontainer = e.css("div[itemprop='location'] time").text.split("-")
	startdate =  time.to_date.to_s + " " + DateTime.parse(datecontainer[0] + "pm").strftime("%H:%M")
	enddate =  time.to_date.to_s + " " + DateTime.parse(datecontainer[1]).strftime("%H:%M")

	EventResult.create!( name: name[0..98].gsub(/\s\w+\s*$/,'...'), price: "free", lat: lat, long: long, address: address, imageurl: imglink , eventurl: link , startdate: startdate, enddate: enddate, description: "", types: "art, art gallery openings", source: artcards_source)
end
=end





