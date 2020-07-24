class Invite < ApplicationRecord
  # The group that the user is being invited to 
  belongs_to :group
  # The user who is being invited
  belongs_to :user
  # The user who created this invitiaion
  belongs_to :invited_by, class_name: 'User'
end
