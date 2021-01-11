json.posts @posts do |post|
	json.id									post.id
	json.media_url          post.media_url
	json.latitude           post.latitude
	json.longitude          post.longitude
	json.created_at         post.created_at.to_i
	json.likes_count        post.likes_count
	json.views_count	      post.views_count 
	json.comments_count     post.comments_count

	json.tagged_users post.post_tagged_users do |tagged_user|
		json.user_id          tagged_user.user.hashid
		json.user_name        tagged_user.user.name
		json.user_profile_pic tagged_user.user.get_image_url
	end

	json.owner_id           post.user.hashid
	json.owner_name         post.user.name
	json.owner_profile_pic  post.user.get_image_url	

	json.is_viewer_owner    post.user_id == @current_user.id
	json.is_post_liked      @liked_posts_ids.include?(post.id)
end