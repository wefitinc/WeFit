class ServiceRequest < ApplicationRecord

	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	DELIVERY_METHODS = ["EMAIL", "PHONE CALL", "VIDEO CALL"]

	enum service_request_status: [:submitted, :accepted, :rejected, :completed, :approved, :cancelled, :expired]

  # Define scopes
  scope :active, -> { where(service_request_status: [
    ServiceRequest.service_request_statuses["submitted"], 
    ServiceRequest.service_request_statuses["accepted"], 
    ServiceRequest.service_request_statuses["completed"]
  ]) }
  scope :approved, -> { where(service_request_status: [ServiceRequest.service_request_statuses["approved"]]) }

	belongs_to :user
  belongs_to :professional, 
    class_name: 'User'
  belongs_to :professional_service_length, optional: true

	validates :details,
    presence: true
  validates :price,
    presence: true,
    numericality: true
  validates :professional_service_length_id,
    presence: true,
    if: -> {is_custom == false}
  validates :delivery_method,
    inclusion: { in: DELIVERY_METHODS }
  validates :phone, presence: true, if: -> {delivery_method == "PHONE CALL" || delivery_method == "VIDEO CALL"}
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, if: -> {delivery_method == "EMAIL"}

  after_commit :start_create_scheduler, on: :create
	after_commit :start_update_scheduler, on: :update

  private

  def start_create_scheduler
  	# TODO
  	# Start the scheduler which will check the status after 72 hours and cancel the request 
  	# and refund the customer if no action has been taken on this request
  end

  def start_update_scheduler
  	# TODO
  	# Start a scheduler which will run after the professional acccepts the request.
  	# After 72 hours, it will notify the user and the professional if request hasn't been completed.

  	# If a request is updated to completed, send a notification to user

  	# If a request is accepted by the user as completed, then transfer the money to professional's account from wefit's account
  end

end
