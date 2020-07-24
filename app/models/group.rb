class Group < ApplicationRecord
  # Every group has a creator
  belongs_to :user
  # Groups have many members
  has_many :members, dependent: :destroy
  has_many :invites, dependent: :destroy
  has_many :topics, dependent: :destroy
  # Groups have a title, which cannot be blank
  validates :title, 
  	presence: true,
  	allow_blank: false
  # Groups have a location, which cannot be blank
  validates :location,
  	presence: true,
  	allow_blank: false
  # Groups have a description, can be blank, limit to 256 characters
  validates :description, 
  	presence: true,
  	allow_blank: true,
  	length: { maximum: 256 }
  # Groups are either public or invite only
  validates :public, inclusion: { in: [ true, false ] }

  def owner?(user)
    return self.user.id == user.id
  end
  def member?(user)
    return self.owner?(user) || self.members.exists?(user_id: user.id)
  end
  def invited?(user)
    return self.invites.exists?(user_id: user.id)
  end
end
