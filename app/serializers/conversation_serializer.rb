class ConversationSerializer < ActiveModel::Serializer
  has_one :recipient
  has_one :last_message
  attributes :id, :recipient, :last_message
end
