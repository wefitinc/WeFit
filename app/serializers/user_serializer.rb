class UserSerializer < ActiveModel::Serializer

  attributes :id, 
    :first_name, 
    :last_name, 
    # :email, 
    :profile_pic_url,
    :gender, 
    :activated,
    :birthdate, 
    :bio,
    :professional,
    :professional_type,
    :follower_count, 
    :following_count

  def id
    object.hashid
  end
  def profile_pic_url
    object.get_image_url
  end
end
