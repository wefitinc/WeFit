class View < ApplicationRecord
  # Views are on posts and have users
  belongs_to :post, counter_cache: true
  belongs_to :user
  # The post must exist
  validates :post,
    presence: true
  # Users must exist and be unique
  validates :user,
    presence: true,
    uniqueness: { scope: :post }
end
