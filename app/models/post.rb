class Post < ApplicationRecord
  include Rails.application.routes.url_helpers
  
  # REGEX defining a valid color in HTML hex format (#ffffff)
  # VALID_COLOR_REGEX = /#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})/

  # Associate every post with a user
  belongs_to :user

  # Add in the likes, views, and comments
  has_many :views, dependent: :destroy
  # NOTE: Comments and likes are polymorphic, need to be owned as such!
  has_many :comments, 
    as: :owner, 
    dependent: :destroy
  has_many :likes, 
    as: :owner,
    dependent: :destroy
  has_many :reports, 
    as: :owner,
    dependent: :destroy
  has_many :post_tagged_users, 
    dependent: :destroy
  accepts_nested_attributes_for :post_tagged_users

  # Add a tag list
  acts_as_taggable_on :tags

  # Associate an image with each post
  # has_one_base64_attached :image

  # Reverse geocoding for spatial lookups
  reverse_geocoded_by :latitude, :longitude

  # TODO Validate the coordinates
  validates :latitude, :longitude,
    presence: true,
    numericality: true

  # Validate the presence of media_url
  validates :media_url,
    presence: true

  # Validate data presence before storing in DB
  # NOTE: Background can be an image or a color, should we validate for this?
  
  # validates :background, presence: true
  # validates :header_color,
  #   presence: true,
  #   format: { with: VALID_COLOR_REGEX }
  # validates :text, presence: true
  # validates :font, presence: true
  # validates :font_size, 
  #   presence: true,
  #   numericality: { only_integer: false, greater_than: 0 }
  
  # Data for text display 
  # TODO: Maybe these should just be default 0 with no required presence?

  # validates :textview_rotation, presence: true, numericality: true
  # validates :textview_position_x, presence: true, numericality: true
  # validates :textview_position_y, presence: true, numericality: true
  # validates :textview_width, :textview_height,
  #   presence: true,
  #   numericality: { only_integer: false, greater_than: 0 }
  
  # Data for image display 
  # TODO: Maybe these should just be default 0 with no required presence?

  # validates :image_rotation, presence: true, numericality: true
  # validates :image_position_x, presence: true, numericality: true
  # validates :image_position_y, presence: true, numericality: true
  # validates :image_width, :image_height,
  #   presence: true,
  #   numericality: { only_integer: false, greater_than: 0 }

  # Color has to fit the color regex
  
  # validates :color, 
  #   presence: true, 
  #   format: { with: VALID_COLOR_REGEX }
  
  # Validate image properties
  # validates :image,
  #   size: { less_than: 4.megabytes },
  #   content_type: ['image/png', 'image/jpg', 'image/jpeg', 'video/mp4']

  # Helper
  def get_image_url
    url_for(self.image) if self.image.attached?
  end

end
