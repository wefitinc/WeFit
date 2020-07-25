class MessageSerializer < ActiveModel::Serializer
  has_one :user
  attributes :id, 
  	:user, 
  	:body, 
  	:read,
  	:created_at
end
