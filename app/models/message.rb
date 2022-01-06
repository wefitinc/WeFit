class Message < ApplicationRecord
  belongs_to :conversation
  belongs_to :user

 	# Different type of messages a user can send from messages screen:
	# 1. Text (messageable_type: "Text", messageable_id: <>)
	# 2. Image (messageable_type: "Image", messageable_id: <>, media_urls: [])
	# 3. Video (messageable_type: "Video", messageable_id: <>, media_urls: [])
	# 4. Location (messageable_type: "Location", messageable_id: <>, user_location: {title: <>, address: <>, 
	#    latitude: <>, longitude: <>})

	# Sharing:
	# 1. Share Group via message (messageable_type: "Group", messageable_id: <group_id>)
	# 2. Share User via message (messageable_type: "User", messageable_id: <user_id>)
	# 3. Share Professional User via message (messageable_type: "User", messageable_id: <user_id>)
	# 4. Share Activity via message (messageable_type: "Activity", messageable_id: <activity_id>)
	# 5. Share post via message (messageable_type: "Post", messageable_id: <post_id>)

  validates :body,
    length: { maximum: 512 }
end
