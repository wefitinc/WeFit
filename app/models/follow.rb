class Follow < ApplicationRecord
  # Each follow has a user and a follower
  belongs_to :user, 
    counter_cache: :follower_count
  belongs_to :follower, 
    class_name: 'User', 
    counter_cache: :following_count
  # The user neeeds to be there and unique for each follower
  validates :user, 
  	presence: true,
  	uniqueness: { scope: :follower }
  # The follower must be there
  validates :follower,
  	presence: true
end