class ActivitySerializer < ActiveModel::Serializer
  has_one :user
  attributes :id,
    :user,
    :name,
    :description,
    :is_attending,
    :event_time,
    :google_placeID,
    :image_url,
    :location_name,
    :location_address,
    :latitude,
    :longitude,
    :attendees_count,
    :absentees_count,
    :difficulty
  
  def image_url
    object.get_image_url
  end

  def is_attending
    return true if @instance_options[:attendee_list] && @instance_options[:attendee_list].include?(object.id)
    return false if @instance_options[:absentee_list] && @instance_options[:absentee_list].include?(object.id)
    return nil
  end
end
