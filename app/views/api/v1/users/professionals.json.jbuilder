json.current_page  @users.current_page
json.total_pages   @users.total_pages
json.posts @users do |user|
	json.id									user.hashid
	json.first_name         user.first_name
	json.latitude           user.latitude
	json.longitude          user.longitude
	json.location           user.location
	json.created_at         user.created_at.to_i
	json.profile_pic_url    user.get_image_url
	json.gender	            user.gender
	json.reviews_count      user.reviews_count

	json.professional       user.professional
	json.professional_type  user.professional_type
end