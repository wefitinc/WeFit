class MemberSerializer < ActiveModel::Serializer
  has_one :user
end
