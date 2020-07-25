class CommentSerializer < ActiveModel::Serializer
  has_one :user
  attributes :id, 
  	:user, 
  	:body, 
  	:created_at, :updated_at
end
