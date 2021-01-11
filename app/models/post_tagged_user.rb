class PostTaggedUser < ApplicationRecord
  belongs_to :user
  belongs_to :post

  # The post must exist
  validates :post,
    presence: true
  # Users must exist and be unique
  validates :user,
    presence: true,
    uniqueness: { scope: :post }
end
