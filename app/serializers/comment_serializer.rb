class CommentSerializer < ActiveModel::Serializer
  has_one :user
  attributes :body, :created_at, :updated_at
end
