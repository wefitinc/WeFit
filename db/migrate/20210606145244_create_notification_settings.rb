class CreateNotificationSettings < ActiveRecord::Migration[5.2]
  def change
    create_table :notification_settings do |t|
    	t.references :user, foreign_key: true
    	t.boolean :mute_notifications
    	t.boolean :mute_likes
    	t.boolean :mute_comments
    	t.boolean :mute_followers
    	t.boolean :mute_activities
    	t.boolean :mute_groups
    	t.boolean :mute_messages
    	t.boolean :mute_exercise_reminders
    	t.boolean :mute_motivation_messages
    	t.boolean :mute_professionals
    	t.boolean :mute_emails
    	t.datetime :unmute_at
      t.timestamps
    end
  end
end
