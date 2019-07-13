class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  attr_accessor :reset_token

  acts_as_gendered
  has_secure_password
  
  validates :terms_of_use, acceptance: true
  validates :email, presence: true, format: {with: VALID_EMAIL_REGEX}, uniqueness: true

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

  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(
      reset_digest: User.digest(reset_token),
      reset_sent_at: Time.zone.now)
  end
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  def User.new_token
    SecureRandom.urlsafe_base64
  end
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns true if the given token matches the digest.
  def authenticated?(attribute, token)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    string = send("#{attribute}_digest")
    return false if string.nil?
    BCrypt::Password.create(string, cost: cost).is_password?(token)
  end
end
