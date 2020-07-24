class Comment < ApplicationRecord
  # Comments belong to an object (the thing being commented on) and have users
  belongs_to :user
  belongs_to :owner, 
    polymorphic: true,
    counter_cache: true
  # Users must exist, but need not be unique
  validates :user, presence: true
  # Validate the comment body
  validates :body, 
    presence: true, 
    allow_blank: false, 
    length: { maximum: 128 }
end
