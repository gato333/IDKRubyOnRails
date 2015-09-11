class EventResult < ActiveRecord::Base
	attr_accessor :lat, :long, :address, :name, :types, :imageurl, :price, :description, :eventurl, :startdate, :enddate, :source 
  validates :name, presence: true
  validates :eventurl, presence: true
  validates :address, presence: true
end