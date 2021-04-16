json.current_page  @users.current_page
json.total_pages   @users.total_pages
json.posts @users do |user|
	json.id									user.hashid
	json.first_name         user.first_name
	json.last_name          user.last_name
	json.latitude           user.latitude
	json.longitude          user.longitude
	json.location           user.location
	json.activated          user.activated
	json.birthdate          user.birthdate
	json.bio                user.bio
	json.created_at         user.created_at.to_i
	json.profile_pic_url    user.get_image_url
	json.gender	            user.gender
	json.reviews_count      user.reviews_count
	json.follower_count     user.follower_count
  json.following_count    user.following_count
  json.rating             user.rating
  json.facebook_link      user.facebook_link
  json.instagram_link     user.instagram_link
  json.twitter_link       user.twitter_link

	json.professional       user.professional
	json.professional_type  user.professional_type

end