class User < ApplicationRecord
  include PgSearch::Model
  include Rails.application.routes.url_helpers
  # Basic email REGEX for server side validation
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  VALID_DATE_REGEX = /([12]\d{3})-(0[1-9]|1[0-2])-(0[1-9]|[12]\d|3[01])/

  # Stuff for professionals
  PROFESSIONAL_RATES = ['Standard', 'Plus']
  PROFESSIONAL_TYPES = ["None", "Personal Trainer", "Dietitian", "Psychiatrist", "Psychologist"]

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
  hashid_config override_find: true

  scope :professionals, -> { where('professional = ?', true) }

  # Associate a pofile pic with each user
  has_one_base64_attached :profile_pic

  # Associate posts with users
  has_many :posts, dependent: :destroy
  accepts_nested_attributes_for :posts

  # Associate services with professionals
  has_many :professional_services, dependent: :destroy
  accepts_nested_attributes_for :professional_services


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

  # Associate each review with a user (being reviewed)
  has_many :reviews
  # Record user logins
  has_many :logins
  # Record users that this user has blocked
  has_many :blocks
  # User has many groups
  has_many :members, dependent: :destroy
  has_many :groups, through: :members

  reverse_geocoded_by "logins.latitude", "logins.longitude"

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
    on: :create,
    presence: true, 
    uniqueness: true,
    allow_blank: false, 
    length: { maximum: 255 },
    format: { with: VALID_EMAIL_REGEX }
  # Downcase emails
  before_save { email.downcase! }
  # Needs a password
  validates :password,
    on: :create,
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
  # Add in a user-written bio
  validates :bio,
    presence: true,
    allow_blank: true,
    length: { maximum: 256 }
  # Professional validation
  validates :professional,
    presence: true,
    allow_blank: true
  validates :professional_type,
    presence: true,
    if: :professional? # A professional type is only required if the user is a professional
  validates :professional_type,
    inclusion: { in: PROFESSIONAL_TYPES }
  validates :license_number,
    presence: true,
    if: :professional? # A license number is only required if the user is a professional


  # Allow search on title and description
  pg_search_scope :search_by_full_name, 
                  against: [:first_name, :last_name], 
                  using: {tsearch: { prefix: true }},
                  :order_within_rank => "users.follower_count DESC"

  pg_search_scope :search_by_professional_type, against: [:professional_type], using: {
    tsearch: { prefix: true }
  }

  pg_search_scope :search_by_location, :associated_against => {
      logins: :location
  },
  using: {
    tsearch: { prefix: true }
  }  

  after_update :submit_professional_application

  def get_image_url
    url_for(self.profile_pic) if self.profile_pic.attached?
  end

  # Friends are defined as users who are both following you and you are following
  # Or: follwers ∩ following
  def friends
    followers & following
  end

  def conversations
    Conversation.where('sender_id=? OR recipient_id=?', self.id,self.id)
  end

  def blocked?(user)
    self.blocks.where(blocked_id: user.id).exists?
  end

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

  def name
    "#{first_name} #{last_name}"
  end

  private

  def submit_professional_application
    if saved_change_to_professional_type?
      ProfessionalApplicationSubmission.create!(user_id: self.id)
    end
  end


end
