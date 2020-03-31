class LikeSerializer < ActiveModel::Serializer
  has_one :user
end
