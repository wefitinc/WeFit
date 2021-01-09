class PostTaggedUser < ApplicationRecord
  belongs_to :user
  belongs_to :post
end
