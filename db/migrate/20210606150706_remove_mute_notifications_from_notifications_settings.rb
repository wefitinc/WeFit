class RemoveMuteNotificationsFromNotificationsSettings < ActiveRecord::Migration[5.2]
  def change
  	remove_column :notification_settings, :mute_notifications
  end
end
