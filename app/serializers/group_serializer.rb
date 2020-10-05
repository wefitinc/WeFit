class GroupSerializer < ActiveModel::Serializer
  has_one :user
  attributes :id,
    :title,
    :public,
    :image_url,
    :location,
    :description,
    :members_count,
    :topics_count

  def image_url
    object.get_image_url
  end
end
