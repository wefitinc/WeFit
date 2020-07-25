class LikeSerializer < ActiveModel::Serializer
  has_one :user
  attributes :id, :user
end
