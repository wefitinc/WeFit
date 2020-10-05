class ActivitySerializer < ActiveModel::Serializer
  has_one :user
  attributes :id,
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
    :difficulty
  
  def image_url
    object.get_image_url
  end
  def is_attending
    # False by default if the user was not passed
    return false if not @instance_options[:current_user]
    # Return if an attending record exists for this user
    # NOTE: Use 'any?' instead of 'exists?' to try and prevent a second DB query
    @current_user = @instance_options[:current_user]
    return object.attendees.where(user_id: @current_user.id).any?
  end
end
