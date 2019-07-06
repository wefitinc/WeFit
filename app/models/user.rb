class User < ApplicationRecord
  acts_as_gendered
  has_secure_password
  
  validates :terms_of_use, acceptance: true
  validates :email, presence: true, uniqueness: true

  def self.find_or_create_from_auth_hash(auth)
  	where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |user|
  		user.uid = auth.uid
  		user.provider = auth.provider
  		user.email = auth.info.email
  		user.first_name = auth.info.first_name
  		user.last_name = auth.info.last_name
  		user.gender = auth.raw_info.gender.upcase_first
  		user.save!
  	end
  end
end
