class UserSerializer < ActiveModel::Serializer
  attributes :id, 
    :first_name, 
    :last_name, 
    :email, 
    :gender, 
    :activated,
    :birthdate, 
    :follower_count, 
    :following_count

  def id
    object.hashid
  end
end
