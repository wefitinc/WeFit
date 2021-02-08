class ProfessionalServiceLength < ApplicationRecord
	# This model stores the service lengths of services offered by a professional
	
	belongs_to :professional_service
end
