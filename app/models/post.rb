class Post < ApplicationRecord
  include Rails.application.routes.url_helpers
  
  # REGEX defining a valid color in HTML hex format (#ffffff)
  VALID_COLOR_REGEX = /#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})/

  # Associate every post with a user
  belongs_to :user

  # Add in the likes and comments
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy

  # Add a tag list
  acts_as_taggable

  # Associate an image with each post
  has_one_base64_attached :image

  # Make sure to allow for reverse geocoding
  reverse_geocoded_by :latitude, :longitude
  # ERROR This breaks everything, but we need it for post lookup
  # after_validation :reverse_geocode

  # Validate data presence before storing in DB
  # NOTE: Background can be an image or a color, should we validate for this?
  validates :background, presence: true
  validates :text, presence: true
  validates :font, presence: true
  validates :font_size, presence: true
  # Color has to fit the color regex
  validates :color, 
    presence: true, 
    format: { with: VALID_COLOR_REGEX }
  # TODO: Maybe these should just be default 0 with no required presence?
  validates :position_x, presence: true
  validates :position_y, presence: true
  validates :rotation, presence: true
  # TODO Validate the coordinates
  validates :latitude, presence: true
  validates :longitude, presence: true
  # Validate image presence, what's a post without an image?
  validates :image, presence: true

  # Helper
  def get_image_url
    url_for(self.image) if self.image.attached?
  end

  # JSON serializer
  def as_json(*)
    super.tap do |hash|
        hash["user_id"] = user.hashid
        hash["image_url"] = get_image_url
        hash["likes"] = likes.count
        hash["comments"] = comments.count
      end
  end

end
