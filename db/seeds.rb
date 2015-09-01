# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'open-uri'

html = Nokogiri::HTML(open("https://www.eventbrite.com/d/ny--manhattan/events--today/?view=list"))

events = html.css(".js-event-list-container.l-block-stack div.l-block-2")

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
	puts org
end