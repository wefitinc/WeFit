class ParticipantSerializer < ActiveModel::Serializer
  has_one :user
end
