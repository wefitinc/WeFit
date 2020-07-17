class Login < ApplicationRecord
  belongs_to :user

  validates :user, presence: true
  validates :ip_address, presence: true
end
