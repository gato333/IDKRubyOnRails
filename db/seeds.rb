# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require "scrap/abstract_scrapper"
require "scrap/art_beat_scrapper"
require "scrap/artslant_scrapper"
require "scrap/eventbrite_scrapper"
require "scrap/my_free_concert_scrapper"
require "scrap/ny_card_scrapper"
require "scrap/timeout_scrapper"

EventResult.delete_all

total = 0 

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
