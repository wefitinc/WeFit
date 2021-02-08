class Review < ApplicationRecord
  # The user that is being reviewed
  belongs_to :user, counter_cache: true
  # The reviewer, also a user
  belongs_to :reviewer, class_name: 'User'

  validates :user, presence: true
  validates :reviewer, presence: true

  validates :text,
    presence: true,
    allow_blank: false,
    length: { maximum: 256 }
  validates :stars,
    presence: true,
    numericality: { 
      only_integer: true, 
      greater_than_or_equal_to: 1,
      less_than_or_equal_to: 5
    }

  after_commit :update_professionals_rating, on: :create

  private 

  def update_professionals_rating
    rating = self.user.rating.nil? ? self.stars : ((self.user.rating + self.stars)/2.0).ceil
    self.user.update(rating: rating)
  end

end
