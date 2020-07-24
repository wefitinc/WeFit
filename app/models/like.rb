class Like < ApplicationRecord
  # Likes belong to an object (the thing being 'liked') and have users
  belongs_to :user
  belongs_to :owner, 
    polymorphic: true,
    counter_cache: true
  # Users must exist and be unique
  validates :user,
    presence: true,
    uniqueness: { scope: :owner }
end
