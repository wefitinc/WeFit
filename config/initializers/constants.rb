# Posts Display
FirstPage = 1
CategoryTopPostsNumber = 10
PostsSinceLastXHours = 24
CategoryPostsSinceLastXHours = 99999
FollowingCategoryName = "Following"

# Score Values
ViewValue = 0.1
LikeValue = 1
CommentValue = 2

# Activities
InitialRadialDistance = 25

# Users
PROFESSIONAL_TYPES = ["None", "Personal Trainer", "Dietitian", "Psychiatrist", "Psychologist"]
Prepositions = ["in", "at", "around", "of", "from", "across", "along", "by", "near", "off", "on"]

# WillPaginate 
DefaultPerPage = 20


# Notification Action Template
ActionTemplate =  {
	like: "#actor_name# liked your post",
	comment: "#actor_name# commented on your post",
	attention: "Your post is getting a lot of attention",
	follow: "#actor_name# started following you",
	
	activity_attend: "You are now attending: #activity_name# created by #creator_name#",
	activity_reminder: "Reminder: #activity_name# is starting in 30 minutes!",
	activity_suggestion: "Checkout this activity you might like!",
	activity_cancellation: "Alert: #activity_name# has been cancelled",

	group_invite: "You have been invited by #actor_name# to join a group called #group_name#",
	group_acceptance: "Your request to join #group_name# has been approved. Welcome to the group!",
	group_join_request: "#actor_name# has requested to join #group_name#",
	group_privacy_change: "#group_name# has updated privacy settings",
	group_inactivity: "Hey #user_name#, Your groups miss and need you. Go catch up!",
	group_suggestion: "Checkout this group you might like!",

	message: "#actor_name# messaged you!",

	exercise_reminder: "Daily Reminder: Did you workout today?",
	
	motivation: "Daily Motivation: #motivational_sentence#",

	service_purchasal: "Confirmation of purchase: #service_name# with #professional_name#",
	service_fulfilled: "Your Service #service_name# has been fulfilled by #professional_name#",
	service_review: "You have been reviewed for your recent service #service_name# to #buyer_name#",
	service_payment: "You have been paid for your recent service #service_name# to #buyer_name#",
	service_delay: "Reminder: You are late fulfilling your service #service_name# to #buyer_name#",
	service_refund: "#buyer_name# has requested a refund for #service_name#",
	service_rejection: "#professional_name# has rejected your service request because #rejection_reason#",
	service_acceptance: "#professional_name# has accepted your service request and will begin working on it. Expect the service to be fulfilled within around 72 hours.",
	service_funds_transfer: "Your transfer of funds has been initiated. Please allow up to 3 business days to receive funds in your bank account.",
	professional_account_acceptance: "Congrats! Your professional account submission has been approved!",
	professional_account_rejection: "Unfortunately your request for a professioanl account has been rejected.",


	new_feature: "#message#",
	app_review: "Help us: We want our community to thrive, and for that, we need your help. Give us a good review!"
}



