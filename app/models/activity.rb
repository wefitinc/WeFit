class Activity < ApplicationRecord
  include Rails.application.routes.url_helpers
  
  # Each activity belongs to it's creating user
  belongs_to :user
  # Each activity has many attending users (hopefully)
  has_many :attendees, dependent: :destroy

  # Allow filtering on difficulty ramges
  scope :min_difficulty, ->(min) { where('difficulty >= ?', min) }
  scope :max_difficulty, ->(max) { where('difficulty <= ?', max) }

  # Geocode the address into latitude and longitude
  geocoded_by :location_address
  after_validation :geocode 

  # Associate an image with each activity
  has_one_base64_attached :image

  # The name of the activity
  validates :name,
    presence: true,
    length: { maximum: 128 }
  # Description of the activity
  validates :description,
    presence: true,
    length: { maximum: 256 }
  # Event time and date
  validates :event_time, 
    presence: true
  # Google place ID
  # NOTE: Used on the client side for image lookup
  validates :google_placeID, 
    presence: true
  # Location name and address
  validates :location_name, :location_address,
    presence: true
  # Difficulty level of the event [1, 5]
  validates :difficulty, 
    presence: true,
    numericality: { 
      only_integer: true, 
      greater_than_or_equal_to: 1,
      less_than_or_equal_to: 5
    }

  # Helper
  def get_image_url
    url_for(self.image) if self.image.attached?
  end
end
