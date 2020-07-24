class GroupSerializer < ActiveModel::Serializer
  has_one :user
  attributes :id,
    :title,
    :public,
    :location,
    :description,
    :members_count,
    :topics_count
end
