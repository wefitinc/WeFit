class ConversationSerializer < ActiveModel::Serializer
  has_one :recipient
  attributes :id, :recipient
end
