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

  after_commit :inc_post_score, on: :create
  after_commit :dec_post_score, on: :destroy

  private 

  def inc_post_score
  	if self.owner_type == "Post"
  		self.owner.update(score: self.owner.score + LikeValue)
  	end
  end

  def dec_post_score
  	if self.owner_type == "Post"
  		self.owner.update(score: self.owner.score - LikeValue)
  	end
  end

end
