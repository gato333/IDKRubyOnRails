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
require "scrap/ny_card_scrapper"

EventResult.delete_all

#se demora mucho!!!
#es = EventbriteScrapper.new
#es.scrap

nyc = NyCardScrapper.new
nyc.scrap

artb = ArtBeatScrapper.new
artb.scrap

arts = ArtslantScrapper.new
arts.scrap
