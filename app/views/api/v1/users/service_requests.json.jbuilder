json.current_page  @requests.current_page
json.total_pages   @requests.total_pages
json.requests @requests do |request|
	json.id										request.id
	json.user_id            	request.user_id
	json.user_name          	request.user.name
	json.details            	request.details
	json.delivery_method    	request.delivery_method
	json.phone              	request.phone
	json.email              	request.email
	json.time               	request.time          
	json.price              	request.price
	json.status             	request.service_request_status
	json.service_length       request.professional_service_length.try(:professional_service).try(:service).try(:name)
	json.service_length_unit  request.professional_service_length.try(:professional_service).try(:service).try(:unit)
	json.created_at         	request.created_at
end