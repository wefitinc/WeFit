class GroupAdminSerializer < ActiveModel::Serializer
  has_one :user
  attributes :id
end
