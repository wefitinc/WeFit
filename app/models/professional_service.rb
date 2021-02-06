class ProfessionalService < ApplicationRecord
  # belongs to a service from amongst the services defined
  belongs_to :service
  # user is professional
  belongs_to :user

  has_many :professional_service_lengths, dependent: :destroy
  accepts_nested_attributes_for :professional_service_lengths

end
