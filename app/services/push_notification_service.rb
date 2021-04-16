class PushNotificationService

  def self.perform notification_id
    notification = Notification.find notification_id
    return unless notification.present?

    priority = 'normal'
    PushNotification.to_user(notification.user_id, PushContent.notification_content(notification, priority))
  end

end