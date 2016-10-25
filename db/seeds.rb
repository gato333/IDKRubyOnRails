
# to run:
# 					rake db:seed
# to run on heroku:
# 									heroku rake db:seed
require "scrap/abstract_scrapper"
require "scrap/art_beat_scrapper"
require "scrap/artslant_scrapper"
require "scrap/eventbrite_scrapper"
require "scrap/my_free_concert_scrapper"
require "scrap/ny_card_scrapper"
require "scrap/timeout_scrapper"

total = 0

if( EventResult.count > 10000 )
	puts "HEROKU db limit has been reached, truncating...."
	EventResult.destroy_all
end

tim = TimeoutScrapper.new
total = total + tim.scrap

myf = MyFreeConcertScrapper.new
total = total + myf.scrap

arts = ArtslantScrapper.new
total = total + arts.scrap

nyc = NyCardScrapper.new
total = total + nyc.scrap

artb = ArtBeatScrapper.new
total = total + artb.scrap

es = EventbriteScrapper.new
total = total + es.scrap

puts "Total Events Scrapped: " + total.to_s
