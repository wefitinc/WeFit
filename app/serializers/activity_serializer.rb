class ActivitySerializer < ActiveModel::Serializer
  has_one :user
  attributes :id,
    :name,
    :description,
    :event_time,
    :google_placeID,
    :image_url,
    :location_name,
    :location_address,
    :latitude,
    :longitude,
    :attendees_count,
    :difficulty
  
  def image_url
    object.get_image_url
  end
end
