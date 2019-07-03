class User < ApplicationRecord
  acts_as_gendered
  has_secure_password
  
  validates :terms_of_use, acceptance: true
  validates :email, presence: true, uniqueness: true
end
