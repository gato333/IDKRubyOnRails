class EventResult < ActiveRecord::Base
  validates :name, presence: true,  length: { maximum: 100 }
  validates :eventurl, presence: true
  validates :address, presence: true
end