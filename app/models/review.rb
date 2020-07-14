class Review < ApplicationRecord
  belongs_to :user
  belongs_to :reviewer,
    class_name: 'User'

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
end
