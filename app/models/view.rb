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

  after_commit :inc_post_score, on: :create

  private 

  def inc_post_score
    self.post.update(score: self.post.score + ViewValue)
  end

end
