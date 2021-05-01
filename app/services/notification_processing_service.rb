class NotificationProcessingService

  def self.perform params
    Notification.create params
  end

end