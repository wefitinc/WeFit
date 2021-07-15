class Conversation < ApplicationRecord
  # Each conversation is between two people
  belongs_to :sender, class_name: 'User'
  belongs_to :recipient, class_name: 'User'
  # Each conversaion should be unique
  validates_uniqueness_of :sender_id, scope: :recipient_id

  # Each conversation has many messages
  has_many :messages, dependent: :destroy

  has_one :last_message, -> { order("created_at DESC") }, :class_name => "Message"

  scope :between, -> (sender_id,recipient_id) {
    where("(conversations.sender_id=? AND conversations.recipient_id=?) OR (conversations.sender_id=? AND conversations.recipient_id=?)", 
      sender_id,recipient_id, 
      recipient_id,sender_id)
  }

  def allowed?(user)
    return self.sender_id == user.id || self.recipient_id == user.id
  end
end
