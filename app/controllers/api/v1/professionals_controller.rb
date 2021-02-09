class Api::V1::ProfessionalsController < Api::V1::BaseController
  before_action :authorize, only: [ :signup ]
  # before_action :set_owner

  # GET /api/v1/professionals
  def index
    # By default, no filters. And sort according to the highest rating
    lat = params[:lat]
    lng = params[:lng]
    
    @users = User.professionals.joins("INNER join logins on logins.user_id=users.id AND logins.id = 
      (SELECT MAX(id) FROM logins WHERE logins.user_id = users.id)").select("users.*, 
      logins.id as login_id, logins.latitude, logins.longitude, logins.location").near([lat, lng], 
      999).order("rating desc, distance desc").page(@page_param)

    render json: @users
  end

  # POST /api/v1/professionals/filter
  def filter
    # Filter professionals by: professional type, and radius.
    # Sort by: highest rating, # of reviews

    lat = params[:lat]
    lng = params[:lng]
    radius = params[:radius]
    professional_type = params[:professional_type]

    # Get all professionals
    @users = User.professionals.joins("INNER join logins on logins.user_id=users.id AND logins.id = 
      (SELECT MAX(id) FROM logins WHERE logins.user_id = users.id)").select("users.*, 
      logins.id as login_id, logins.latitude, logins.longitude, logins.location").all
    # Filter out by professional type if present
    @users = @users.where(professional_type: professional_type) if professional_type.present?
    # Filter out by radius if present
    @users = @users.near([lat, lng], radius) if radius.present? && lat.present? && lng.present?
    
    # Sort by number of reviews
    @users = @users.order("reviews_count desc, distance desc") if params[:sort_by] == "reviews"
    # Sort by highest rating
    @users = @users.order("rating desc, distance desc") if params[:sort_by] == "ratings"
    # Paginate
    @users = @users.paginate(page: @page_param)
    # Render results
    render json: @users
  end

  # POST /api/v1/professionals/sign_up
  def signup
    # A record will be created in ProfessionalApplicationSubmission after successful update
    # Upon accepting the application request, professional field will be set to true for the user

    if not @current_user.update(professional_signup_params) then
      render json: { errors: @activity.errors }, status: :unprocessable_entity
    end
    render json: { message: "Application submission successful" }, status: :ok
  end

  # GET /api/v1/professionals/:id
  def show
    @user = User.professionals.where(id: params[:id]).last
    render json: { error: 'User not found with this id' }, status: :not_found unless @user.present?
  end

  # GET /api/v1/professionals/:id/service_requests
  def service_requests
    @requests = ServiceRequest.active.includes(:user, professional_service_length: [professional_service: 
      :service]).where(professional_id: params[:id]).paginate(page: @page_param)
  end

  # GET /api/v1/professionals/:id/receipts
  def receipts
    @requests = ServiceRequest.approved.includes(:user, professional_service_length: [professional_service: 
      :service]).where(professional_id: params[:id]).paginate(page: @page_param)

    render 'service_requests'
  end

  private

  def professional_signup_params
    params.require(:user).permit(
      :professional_type,
      :license_number,
      professional_services_attributes: [
        :service_id,  
        :description, 
        professional_service_lengths_attributes: [:length, :price] 
      ]
    )
  end

end