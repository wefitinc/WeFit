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
		json.service_name          professional_service.service.name
		json.service_length_unit   professional_service.service.unit
		json.service_lengths professional_service.professional_service_lengths do |lengths|
			json.length              lengths.length
			json.price               lengths.price
		end
	end	
end