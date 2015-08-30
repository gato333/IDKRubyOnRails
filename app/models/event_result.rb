class EventResult < ActiveRecord::Base
  validates :name, presence: true,  length: { maximum: 100 }
  validates :eventurl, presence: true
  validates :address, presence: true
  validates :description, presence: true,  length: { maximum: 200 }
  validates :address, presence: true
end