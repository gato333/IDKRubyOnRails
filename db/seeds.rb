# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#pull from eventbrite
require 'time'

Eventbrite.token = '2JMBKUKZ75AVI7ETL3TR'

searchObj = Hash.new 
searchObj["location.latitude"] = "40.741080"
searchObj["location.longitude"] = "-73.988559" 
searchObj["location.within"] = "30mi"
searchObj["start_date.range_start"] = Time.now.utc.iso8601

categories = Eventbrite::Category.all

allCatagories = Hash.new
categories.categories.each do |c|
	allCatagories[c["id"]] = c["name"]
end

events = Eventbrite::Event.search(searchObj)
all_event = events.events
i = 0
if events.paginated? == false
	while events.next? && i <= 20
		searchObj[:page] = events.next_page 
		events = Eventbrite::Event.search(searchObj)
		all_event.concat(events.events)
		i += 1
		puts i
	end 
end

all_event.each do |e|
	EventResult.create( name: e["name"]["text"][0..72].gsub(/\s\w+\s*$/,'...'), address: e["venue_id"], imageurl: e["logo"]["url"], eventurl: e["url"] ,date: e["start"], description: e["description"]["text"][0..147].gsub(/\s\w+\s*$/,'...'), type: allCatagories[e["category"].to_i] )
end

