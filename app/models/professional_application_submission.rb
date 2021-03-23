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

  after_update :update_professional_record

  private

  def update_professional_record
    if saved_change_to_application_status? && self.application_status == "accepted"
      # Updating user's professional to true is application is accepted
      self.user.update!(professional: true)
    elsif saved_change_to_application_status? && self.application_status == "rejected"
      # Updating user's professional type to "None" and purging data if application is rejected
      self.user.update!(professional_type: "None")
      ProfessionalService.where(user_id: self.user_id).destroy_all
    end
  end

end
