class Invite < ApplicationRecord
  # The group that the user is being invited to 
  belongs_to :group
  # The user who is being invited
  belongs_to :user
  # The user who created this invitiaion
  belongs_to :invited_by, class_name: 'User'

  after_commit :send_notification_to_invited_user, on: :create

  private

  def send_notification_to_invited_user
    # TODO Notification
  	# Push notification worker to send out notification
  end
end
