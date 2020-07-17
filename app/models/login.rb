class Login < ApplicationRecord
  # This is for recording user logins, so each login has a user
  belongs_to :user
  # Take the IP address and do a lookup for user location
  # NOTE: This won't be exact, its just for getting general location to 
  # allow user's to see if their account has been compromised
  geocoded_by :ip_address
  after_validation :geocode 
  # The only inputs needed are a user and an ip address
  # NOTE: The IP address comes from the request anyway
  validates :user, presence: true
  validates :ip_address, presence: true
end
