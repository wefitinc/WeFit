class Topic < ApplicationRecord
  # Each topic is created by a user in a group
  belongs_to :user
  belongs_to :group, counter_cache: true
  # NOTE: Comments and likes are polymorphic, need to be owned as such!
  has_many :comments, 
    as: :owner, 
    dependent: :destroy
  has_many :likes, 
    as: :owner,
    dependent: :destroy
  # Each topic has a body
  # TODO: Check and see if this is too few characters
  validates :body, length: { maximum: 512 }
  # Allow topics to be anonymous if the user so chooses
  validates :anonymous, inclusion: { in: [ true, false ] }
end
