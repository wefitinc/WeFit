class Comment < ApplicationRecord
  # Comments belong to an object (the thing being commented on) and have users
  belongs_to :user
  has_many :reports, 
    as: :owner,
    dependent: :destroy
  belongs_to :owner, 
    polymorphic: true,
    counter_cache: true
  has_many :reports, 
    as: :owner,
    dependent: :destroy
  # Users must exist, but need not be unique
  validates :user, presence: true
  # Validate the comment body
  validates :body, 
    presence: true, 
    allow_blank: false, 
    length: { maximum: 128 }

  after_commit :inc_post_score, on: :create
  after_commit :dec_post_score, on: :destroy

  private 

  def inc_post_score
    if self.owner_type == "Post"
      self.owner.update(score: self.owner.score + CommentValue)
    end
  end

  def dec_post_score
    if self.owner_type == "Post"
      self.owner.update(score: self.owner.score - CommentValue)
    end
  end
end
