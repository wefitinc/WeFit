class GroupSerializer < ActiveModel::Serializer
  has_one :user
  attributes :id,
    :title,
    :public,
    :is_member,
    :is_invited,
    :image_url,
    :location,
    :description,
    :members_count,
    :topics_count

  def image_url
    object.get_image_url
  end
  def is_member
    # False by default if the user was not passed
    return false if not @instance_options[:current_user]
    # Return if an attending record exists for this user
    # NOTE: Use 'any?' instead of 'exists?' to try and prevent a second DB query
    @current_user = @instance_options[:current_user]
    return object.member?(@current_user)
  end
  def is_invited
    # False by default if the user was not passed
    return false if not @instance_options[:invited_groups]
    # Return if an invited record exists for this user
    return @instance_options[:invited_groups].include?(object.id)
  end
end
