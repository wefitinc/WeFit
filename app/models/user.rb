class User < ApplicationRecord
  # Basic email REGEX for server side validation
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  # Allow the user mailer to access the reset token
  attr_accessor :reset_token
  # Implement the gendered behavior (see lib/acts_as_gendered.rb)
  acts_as_gendered 
  # Implement BCrypt passwords
  has_secure_password
  # Use hashids for more secure lookup
  include Hashid::Rails
  
  # The user needs to have accepted the tos on signup
  validates :terms_of_use, acceptance: true
  # The user needs a valid email address, unique within the database
  validates :email, presence: true, format: {with: VALID_EMAIL_REGEX}, uniqueness: true

  # Implements the signup/login via the omniauth plugins
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

  # Creates a password reset token for the user and stores the digest in the database
  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(
      reset_digest: User.digest(reset_token),
      reset_sent_at: Time.zone.now)
  end
  # Emails a password reset email to this user
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end
  # Checks if the password reset token has expired
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  # Creates a new token
  def User.new_token
    SecureRandom.urlsafe_base64
  end
  # Creates a BCrypt digest of a string
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns true if the given token matches the digest.
  def authenticated?(attribute, token)
    string = send("#{attribute}_digest")
    return false if string.nil?
    BCrypt::Password.new(string).is_password?(token)
  end
end
