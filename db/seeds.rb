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

tim = TimeoutScrapper.new
tim.scrap


puts EventResult.all.inspect
=begin
myf = MyFreeConcertScrapper.new
myf.scrap

arts = ArtslantScrapper.new
arts.scrap

nyc = NyCardScrapper.new
nyc.scrap

artb = ArtBeatScrapper.new
artb.scrap

es = EventbriteScrapper.new
es.scrap
=end
