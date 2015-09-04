# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'open-uri'

EventResult.delete_all
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
		EventResult.create!( name: name[0..97].gsub(/\s\w+\s*$/,'...'), price: price, lat: lat, long: long, address: address, imageurl: imglink ? imglink : '' , eventurl: link , startdate: date, enddate: "", description: '', types: '', source: eventbrite_source)
	end
end


#**************************************#
# 	Artslant Scrapper 		
#**************************************#
time = Time.now
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

		EventResult.create!( name: name, price: "free", lat: lat, long: long, address: address, imageurl: imglink , eventurl: link , startdate: date, enddate: enddate, description: "", types: "art, art gallery openings", source: artslant_source)
	end
end
=end



