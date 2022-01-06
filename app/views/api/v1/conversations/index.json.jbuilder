json.current_page  @conversations.current_page
json.total_pages   @conversations.total_pages
json.conversations @conversations do |conversation|
	
	json.id									conversation.id
	json.recipient          @current_user.id == conversation.sender_id ? conversation.recipient : conversation.sender
	json.last_message       conversation.last_message

end