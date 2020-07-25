class LoginSerializer < ActiveModel::Serializer
  has_one :user
  attributes :user, :address, :created_at
end
