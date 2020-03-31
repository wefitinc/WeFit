class User < ApplicationRecord
  # Basic email REGEX for server side validation
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  VALID_DATE_REGEX = /([12]\d{3})-(0[1-9]|1[0-2])-(0[1-9]|[12]\d|3[01])/
  # Allow the user mailer to access the tokens
  attr_accessor :reset_token
  attr_accessor :activation_token
  attr_accessor :unlock_token
  # Implement the gendered behavior (see lib/acts_as_gendered.rb)
  acts_as_gendered 
  # Implement BCrypt passwords
  has_secure_password
  # Use hashids for more secure lookup
  include Hashid::Rails

  # Associate posts with users
  has_many :posts, dependent: :destroy
  accepts_nested_attributes_for :posts

  # Create relationships for following users
  # Follows = The record of follows
  has_many :follows
  # NOTE: Follows only go one way:
  # Follower -> Followed
  has_many :follower_relationships, foreign_key: :user_id, class_name: 'Follow'
  has_many :followed_relationships, foreign_key: :follower_id, class_name: 'Follow'
  # Alias for relations
  # Followers = people following this user
  # Following = people this user has followed
  has_many :followers, through: :follower_relationships, source: :follower
  has_many :following, through: :followed_relationships, source: :user

  # The user needs a valid name
  validates :first_name,  
    presence: true, 
    allow_blank: false, 
    length: { maximum: 50 }
  validates :last_name,  
    presence: true, 
    allow_blank: false, 
    length: { maximum: 50 }
  # The user needs a valid email address, unique within the database
  validates :email, 
    presence: true, 
    uniqueness: true,
    allow_blank: false, 
    length: { maximum: 255 },
    format: { with: VALID_EMAIL_REGEX }
  # Needs a password
  validates :password,
    presence: true,
    allow_blank: false, 
    length: { minimum: 6 }
  # Needs a gender
  validates :gender,
    presence: true,
    allow_blank: false, 
    inclusion: { in: ActsAsGendered::GENDERS }
  # Needs a birthdate in YYYY-MM-DD format
  validates :birthdate,
    presence: true,
    allow_blank: false, 
    format: { with: VALID_DATE_REGEX }

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

  # Create an account activation token in the DB
  def create_activation_digest
    self.activation_token = User.new_token
    update_columns(activation_digest: User.digest(activation_token))
  end
  # Send the user a nice welcome/activation email
  def send_activation_email
    UserMailer.welcome(self).deliver_now
  end
  # Mark this user as activated
  def activate!
    update_columns(activated: true)
  end

  # Create an unlock token
  def create_unlock_digest
    self.unlock_token = User.new_token
    update_columns(
      unlock_digest: User.digest(unlock_token),
      locked_at: Time.zone.now)
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
