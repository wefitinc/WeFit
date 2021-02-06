class Api::V1::ProfessionalsController < Api::V1::BaseController
  before_action :authorize, only: [ :signup ]
  # before_action :set_owner

  # GET /api/v1/professionals
  def index
    # By default the highest rating will show, all professional types, and no radius, 
    # but professionals list by default when there is no radius should still show closest ones first.
      
    lat = params[:lat]
    lng = params[:lng]
    
    @users = User.joins("INNER join logins on logins.user_id=users.id AND logins.id = 
      (SELECT MAX(id) FROM logins WHERE logins.user_id = users.id)").where(professional: true).select("users.*, 
      logins.id as login_id, logins.latitude, logins.longitude, logins.location").near([lat, lng], 
      999).order("rating desc, distance desc").page(@page_param)

    render json: @users
  end

  # POST /api/v1/professionals/filter
  def filter
    # Users can filter this list to view professionals by rating 
    # Number of reviews or highest rating/score, professional type, and lastly radius.

    lat = params[:lat]
    lng = params[:lng]
    radius = params[:radius]
    professional_type = params[:professional_type]

    # Get all professionals
    @users = User.joins("INNER join logins on logins.user_id=users.id AND logins.id = 
      (SELECT MAX(id) FROM logins WHERE logins.user_id = users.id)").where(professional: true).select("users.*, 
      logins.id as login_id, logins.latitude, logins.longitude, logins.location").all
    # Filter out by professional type if present
    @users = User.where(professional_type: professional_type) if professional_type.present?
    # Filter out by radius if present
    @users = @users.near([lat, lng], radius) if radius.present? && lat.present? && lng.present?
    # Sort by number of reviews
    @users = @users.order("reviews_count desc, distance desc") if params[:reviews].present?
    # Sort by highest rating
    @users = @users.order("rating desc, distance desc") if params[:rating].present?
    # Paginate
    @users = @users.paginate(page: @page_param)
    # Render results
    render json: @users
  end

  # 
  def services
    # based on professional type
    @services = Service.where(professional_type: params[:professional_type])
    # name, unit
  end

  # POST /api/v1/professionals/sign_up
  def signup
    # params: {
      # professional_type: <>, 
      # certificate_number: <>, 
      # services: [{service_type: <service_id>, service_lengths: [{length: <>, price: <>}], service_description: <desc> }]
    # }  

    # User - set professional to true, and professional_type to selected profession
    # Service - master table for services (service_name, service_length_unit(mins, weeks), professional_type)
    
    # ProfessionalServices - join table with user_id, service_id, service_description, service_time, service_price
    byebug
    @current_user.update(professional_signup_params)
    # after update is successful, we need to create a record for admin approvals. Once an admin approves this user, 
    # we can set the professional field as true
  end

  # GET /api/v1/professionals/:id
  def show
    # user info (name, professional_type, following, followers, reviews, bio)
    @user = User.find_by_id(params[:id])
    @services = @user.professional_services
    # services offered
  end

  # User will request for service from the professional
  # This API Will be used to create service request: normal or custom
  def request_service

  end


  private

  def professional_signup_params
    params.require(:user).permit(
      :professional_type,
      :license_number,
      professional_services_attributes: [:service_id,  :description, 
        professional_service_lengths_attributes: [:length, :price] 
      ]
    )
  end

  def service_request_params
    params.require(:service_request).permit(
      :service_name,
      :professional_id,
      :user_id,
      :details,
      :delivery_method (phone call, video call, email),
      :phone_number,
      :email,
      :date,
      :time,
      :price,
      :is_custom,
      :is_accepted,
      :is_completed
    )
  end

end