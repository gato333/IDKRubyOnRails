
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

# seems it might not be possible to scrape Timeout anymore, they've implmented some sort cert for reteivign the page
# tim = TimeoutScrapper.new
# total = total + tim.scrap

#  My Free Concerts is currently offline till supposedly March 2017 ( yet its already May 2017 )
#  myf = MyFreeConcertScrapper.new
#  total = total + myf.scrap

# => ArtSlant is un-navigatale now of a while now, November 2019
#  arts = ArtslantScrapper.new
#  total = total + arts.scrap

nyc = NyCardScrapper.new
total = total + nyc.scrap

artb = ArtBeatScrapper.new
total = total + artb.scrap

es = EventbriteScrapper.new
total = total + es.scrap

puts "Total Events Scrapped: " + total.to_s
