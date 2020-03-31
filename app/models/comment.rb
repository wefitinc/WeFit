class Comment < ApplicationRecord
  belongs_to :post, counter_cache: true
  belongs_to :user
    # The post must exist
  validates :post,
    presence: true
  # Users must exist
  validates :user,
    presence: true
  # Validate the comment body
  validates :body, 
    presence: true, 
    allow_blank: false, 
    length: { maximum: 128 }
end
