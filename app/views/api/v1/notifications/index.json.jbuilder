json.current_page  @notifications.current_page
json.total_pages   @notifications.total_pages
json.notifications @notifications do |notification|
	json.id									notification.id
	json.user_id            notification.user_id

	notification.text       get_notification_text(notification)
	notification.is_seen    notification.is_seen
	notification.is_deleted notification.is_deleted
end