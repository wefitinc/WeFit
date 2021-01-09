class PostSerializer < ActiveModel::Serializer
  has_one :user
  attributes :id,
    :user, 
    :media_url,
    # :background,
    # :header_color,
    # :text, 
    # :font, :font_size, :color,
    # :textview_rotation,
    # :textview_position_x, 
    # :textview_position_y, 
    # :textview_width, 
    # :textview_height,
    # :image_url,
    # :image_rotation,
    # :image_position_x, 
    # :image_position_y, 
    # :image_width, 
    # :image_height,
    :latitude, :longitude,
    :likes_count, :views_count, :comments_count, 
    :tag_list,
    :created_at, :updated_at

  def image_url
    object.get_image_url
  end
end
