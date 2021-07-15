json.settings do
	json.id													@setting.id
	json.unmute_at                  @setting.unmute_at
	json.mute_likes         				@setting.mute_likes
  json.mute_comments      				@setting.mute_comments
  json.mute_followers     				@setting.mute_followers
  json.mute_activities    				@setting.mute_activities
  json.mute_groups        				@setting.mute_groups
  json.mute_messages      				@setting.mute_messages
  json.mute_exercise_reminders    @setting.mute_exercise_reminders
  json.mute_motivation_messages   @setting.mute_motivation_messages
  json.mute_professionals         @setting.mute_professionals
  json.mute_email                 @setting.mute_emails
end