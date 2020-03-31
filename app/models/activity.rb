class Activity < ApplicationRecord
  belongs_to :user

  validates :name,
    presence: true,
    length: { maximum: 128 }
  validates :description,
    presence: true,
    length: { maximum: 256 }
  validates :event_time, 
    presence: true
  validates :google_placeID, 
    presence: true
  validates :location_name, :location_address,
    presence: true
  validates :difficulty, 
    presence: true,
    numericality: { 
      only_integer: true, 
      greater_than_or_equal_to: 1,
      less_than_or_equal_to: 5
    }
end
