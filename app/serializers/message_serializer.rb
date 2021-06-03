class MessageSerializer < ActiveModel::Serializer
  has_one :user
  attributes :id, 
  	:user, 
  	:body, 
  	:read,
  	:messageable_type,
  	:messageable_id,
  	:created_at
end
