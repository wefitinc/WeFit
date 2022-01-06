class MessageSerializer < ActiveModel::Serializer
  has_one :user
  attributes :id, 
  	:user, 
  	:body, 
  	:read,
  	:messageable_type,
  	:messageable_id,
  	:user_location,
  	:media_urls,
  	:created_at
end
