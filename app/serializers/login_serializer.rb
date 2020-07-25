class LoginSerializer < ActiveModel::Serializer
  has_one :user
  attributes :user, :created_at
end
