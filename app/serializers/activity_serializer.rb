class ActivitySerializer < ActiveModel::Serializer
  attributes :id,
    :user_id,
    :name,
    :description,
    :event_time,
    :google_placeID,
    :location_name,
    :location_address,
    :difficulty

  def user_id
    object.user.hashid
  end
end
