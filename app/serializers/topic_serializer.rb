class TopicSerializer < ActiveModel::Serializer
  # Make sure the user renders correctly
  has_one :user
  # The data to return
  attributes :id,
    :group_id,
    :anonymous,
    :user,
    :body, 
    :likes_count,
    :comments_count,
    :created_at, :updated_at

  # NOTE: Topics can be anonymous, so return a nil user if that is the case
  def user
    object.anonymous? ? nil : object.user 
  end
end
