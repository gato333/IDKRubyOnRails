class EventResult < ActiveRecord::Base
  validates :name, presence: true,  length: { maximum: 75 }
  validates :start_time, presence: true
  validates :eventurl, presence: true
  validates :address, presence: true
  validates :description, presence: true,  length: { maximum: 150 }
  validates :address, presence: true
end