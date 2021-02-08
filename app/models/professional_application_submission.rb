class ProfessionalApplicationSubmission < ApplicationRecord
	# This model records the applications submitted by professionals and their status

  belongs_to :user
  belongs_to :reviewer, 
    class_name: 'User', optional: true

  # The user needs to be there
  validates :user, 
  	presence: true
  
  validates :application_status,
  	presence: true

  enum application_status: [:submitted, :accepted, :rejected]

end
