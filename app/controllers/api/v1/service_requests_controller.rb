class Api::V1::ServiceRequestsController < Api::V1::BaseController
  before_action :authorize
  before_action :set_object, except: [ :create ]
  before_action :check_professional, only: [ :accept, :reject, :complete ]
  before_action :check_user, only: [ :cancel, :approve ]
  before_action :check_request_status, only: [ :accept, :complete, :approve ]

  # POST /api/v1/service_requests
  def create
    # Create the Service Request(user to professional): normal or custom
    @request = ServiceRequest.new(service_request_params)
    # Set the owner to the logged in user
    @request.user_id = @current_user.id
    # Attempt to save in DB
    if @request.save
      render json: { message: 'Request Submitted Sucessfully' }, status: :ok
    else
      render json: { errors: @request.errors }, status: :unprocessable_entity
    end
  end

  # POST /api/v1/service_requests/:id/accept
  def accept
    if @request.update(service_request_status: ServiceRequest.service_request_statuses["accepted"])
      render json: { message: 'Accepted' }, status: :ok
    else
      render json: { errors: @request.errors }, status: :unprocessable_entity
    end
  end

  # POST /api/v1/service_requests/:id/reject
  def reject
    if @request.update(service_request_status: ServiceRequest.service_request_statuses["rejected"])
      render json: { message: 'Rejected' }, status: :ok
    else
      render json: { errors: @request.errors }, status: :unprocessable_entity
    end
  end

  # POST /api/v1/service_requests/:id/complete
  def complete
    if @request.update(service_request_status: ServiceRequest.service_request_statuses["completed"])
      render json: { message: 'Completed' }, status: :ok
    else
      render json: { errors: @request.errors }, status: :unprocessable_entity
    end
  end

  # POST /api/v1/service_requests/:id/cancel
  def cancel
    if @request.update(service_request_status: ServiceRequest.service_request_statuses["cancelled"])
      render json: { message: 'Cancelled' }, status: :ok
    else
      render json: { errors: @request.errors }, status: :unprocessable_entity
    end
  end

  # POST /api/v1/service_requests/:id/approve
  def approve
    if @request.update(service_request_status: ServiceRequest.service_request_statuses["approved"])
      render json: { message: 'Approved' }, status: :ok
    else
      render json: { errors: @request.errors }, status: :unprocessable_entity
    end
  end

  private

  def service_request_params
    params.require(:service_request).permit(
      :professional_id,
      :professional_service_length_id,
      :details,
      :delivery_method,
      :phone_number,
      :email,
      :time,
      :price,
      :is_custom
    )
  end

  def set_object
    @request = ServiceRequest.find(params[:id])
    render json: { errors: "Not found" }, status: 404 if @request.nil?
  end

  def check_professional
    render json: { errors: "You are not authorized for this operation" }, status: :unauthorized unless @current_user.id == @request.professional_id
  end

  def check_user
    render json: { errors: "You are not authorized for this operation" }, status: :unauthorized unless @current_user.id == @request.user_id
  end

  def check_request_status
    render json: { errors: "Operation not permitted" }, status: :unprocessable_entity if 
      request_closed_statuses.include?(ServiceRequest.service_request_statuses[@request.service_request_status])
  end

  def request_closed_statuses
    return [
      ServiceRequest.service_request_statuses["rejected"], 
      ServiceRequest.service_request_statuses["cancelled"], 
      ServiceRequest.service_request_statuses["expired"],
      ServiceRequest.service_request_statuses["approved"]
    ]
  end

end