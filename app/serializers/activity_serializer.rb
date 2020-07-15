class ActivitySerializer < ActiveModel::Serializer
  has_one :user
  attributes :id,
    :name,
    :description,
    :event_time,
    :google_placeID,
    :location_name,
    :location_address,
    :attendees_count,
    :difficulty
end
