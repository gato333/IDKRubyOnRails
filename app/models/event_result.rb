class EventResult < ActiveRecord::Base
	validates :name, presence: true
  validates :eventurl, presence: true
end