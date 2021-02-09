json.user do
	json.id									@user.hashid
	json.first_name         @user.first_name
	json.profile_pic_url    @user.get_image_url
	json.gender	            @user.gender
	json.follower_count     @user.follower_count
	json.following_count    @user.following_count
	json.reviews_count      @user.reviews_count
	json.rating             @user.rating
	json.bio                @user.bio
	json.professional       @user.professional
	json.professional_type  @user.professional_type

	json.services @user.professional_services.includes(:service, :professional_service_lengths) do |professional_service|
		json.service_id                professional_service.service.id
		json.service_name              professional_service.service.name
		json.service_length_unit       professional_service.service.unit
		json.professional_service_id   professional_service.id
		json.service_lengths professional_service.professional_service_lengths do |length|
			json.service_length_id       length.id 
			json.service_length          length.length
			json.service_length_price    length.price
		end
	end	
end