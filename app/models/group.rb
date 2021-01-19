class Group < ApplicationRecord
  include PgSearch::Model
  include Rails.application.routes.url_helpers
  
  # Every group has a creator
  belongs_to :user
  # Associate an image with each group
  has_one_base64_attached :image
  # Groups have many members
  has_many :members, dependent: :destroy
  has_many :admins, foreign_key: "group_id", class_name: "GroupAdmin", dependent: :destroy
  has_many :requests, foreign_key: "group_id", class_name: "JoinRequest", dependent: :destroy
  has_many :invites, dependent: :destroy
  has_many :topics, dependent: :destroy
  has_many :reports, 
    as: :owner,
    dependent: :destroy
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

  # Allow search on title and description
  pg_search_scope :search_for, against: {title: 'A', description: 'B'}, using: {
    tsearch: { prefix: true }
  }

  # Helper
  def owner?(user)
    return self.user.id == user.id
  end
  def admin?(user)
    return self.admins.exists?(user_id: user.id)
  end
  def member?(user)
    return self.owner?(user) || self.members.exists?(user_id: user.id) || self.admins.exists?(user_id: user.id)
  end
  def invited?(user)
    return self.invites.exists?(user_id: user.id)
  end
  def invited_by_owner_or_admin?(user)
    owner_ids = [self.user_id] + self.admins.pluck(:user_id)
    return self.invites.exists?(user_id: user.id, invited_by_id: owner_ids)
  end
  def get_image_url
    url_for(self.image) if self.image.attached?
  end
end
