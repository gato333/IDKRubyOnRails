class EventResult < ActiveRecord::Base
	validates :name, presence: true
  validates :eventurl, presence: true
  validates :address, presence: true
  validates_uniqueness_of :name, scope: :address
end