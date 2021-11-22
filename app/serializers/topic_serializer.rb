class TopicSerializer < ActiveModel::Serializer
  # Make sure the user renders correctly
  has_one :user
  # The data to return
  attributes :id,
    :group_id,
    :anonymous,
    :mood,
    :user,
    :body, 
    :image_url,
    :link_urls,
    :media_urls,
    :is_liked,
    :likes_count,
    :comments_count,
    :created_at, :updated_at

  # NOTE: Topics can be anonymous, so return a nil user if that is the case
  def user
    object.anonymous? ? nil : object.user 
  end
  # def image_url
  #   object.get_image_url
  # end
  def is_liked
    # False by default if the user was not passed
    return false if not @instance_options[:current_user]
    # Return if an attending record exists for this user
    # NOTE: Use 'any?' instead of 'exists?' to try and prevent a second DB query
    @current_user = @instance_options[:current_user]
    return object.liked?(@current_user)
  end
end
