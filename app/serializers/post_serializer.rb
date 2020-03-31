class PostSerializer < ActiveModel::Serializer
  has_one :user
  attributes :id, 
    :background,
    :header_color,
    :text, 
    :font, :font_size, :color,
    :position_x, :position_y, :rotation,
    :textview_width, :textview_height,
    :latitude, :longitude,
    :image_url,
    :likes_count, :views_count, :comments_count, 
    :created_at, :updated_at

  def image_url
    object.get_image_url
  end
end