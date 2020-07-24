class TopicSerializer < ActiveModel::Serializer
  has_one :user

  attributes :id,
    :user,
    :body, 
    :likes_count,
    :comments_count,
    :created_at, :updated_at
end
