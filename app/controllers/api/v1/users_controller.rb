class Api::V1::UsersController < Api::V1::BaseController
  before_action :authorize, only: [:professionals_suggestions, :suggestions, :search, :groups]
  before_action :find_user, only: [:show, :destroy, :reset]
  before_action :check_debug, only: [:destroy]

  # GET /users/:id
  def show
    # Render the user
    render json: @user
  end

  # DELETE /users/:id
  def destroy
    @user.destroy
    render json: { message: "Account deleted" }
  end

  # POST /users/:id/reset
  def reset
    @user.create_reset_digest
    @user.send_password_reset_email
    render json: { message: "Password reset email sent" }, status: :ok
  end

  # GET /users/:id/groups
  # Get support groups of a user
  def groups
    @groups = @current_user.groups.page(@page_param)
    render json: { 
      current_page: @groups.current_page, 
      total_pages:  @groups.total_pages,
      groups: ActiveModelSerializers::SerializableResource.new(@groups).as_json
    }
  end

  # GET /users/:id/service_requests
  # Get service requests requested by user to professional
  def service_requests
    @requests = ServiceRequest.active.includes(:user, professional_service_length: [professional_service: 
      :service]).where(user_id: params[:id]).paginate(page: @page_param)
  end

  # GET /users/professionals
  def index_professionals
    @users = User.where(professional: true)
    render json: @users
  end

  # GET /users/suggestions
  def suggestions
    # Load second connects first and then popular users
    # Second Connects - who people I am following are following that I don't already follow

    # Get second connects
    second_connect_ids = get_second_connect_query
    results = ActiveRecord::Base.connection.execute(second_connect_ids)
    second_connects = User.where(id: Follow.where(id: results.map {|e| e["id"]}).where.not(follower_id: 
      @current_user.id).pluck(:user_id)).order(follower_count: :desc).pluck(:id)

    # Get Popular Users
    popular_users = User.where.not(id: Follow.where(follower_id: 
      @current_user.id).pluck(:user_id)).order(follower_count: :desc).pluck(:id)
    
    # Get combined ids to preserve the order
    ids = second_connects + popular_users

    # Get suggested users from ids calculated above
    @users = User.where(id: ids).order("position(id::text in '#{ids.join(',')}')").page(@page_param)
    
    # Render results
    render json: { 
      current_page: @users.current_page, 
      total_pages:  @users.total_pages,
      users: ActiveModelSerializers::SerializableResource.new(@users).as_json
    }
  end

  # POST /users/search
  def search
    # Searching users by name. 
    # First, all followers and following will be given priority and then all the popular users

    # Get related user ids
    user_ids = Follow.where("user_id = #{@current_user.id} or follower_id = #{@current_user.id}").pluck(:user_id, :follower_id)
    user_ids = user_ids.flatten - [@current_user.id]

    # Build query condition for getting the related users - either followers or following
    query_condition = "id IN (#{user_ids.join(',')})" if user_ids.present?
    
    # Get related users for current user - will be given priority
    related_users = User.search_by_full_name(params[:search]).where(query_condition).pluck(:id)

    # Get popular users
    popular_users = User.search_by_full_name(params[:search]).where.not(id: related_users).pluck(:id)
    
    # Get user ids for related users and popular users in a defined order
    ids = related_users + popular_users

    # Preserving the order in which ids are passed. First, related users and then popular users
    @users = User.where(id: ids).order("position(id::text in '#{ids.join(',')}')").page(@page_param)

    # Render results
    render json: { 
      current_page: @users.current_page, 
      total_pages:  @users.total_pages,
      users: ActiveModelSerializers::SerializableResource.new(@users).as_json
    }
  end


  # GET /users/get_professionals
  # Params: {lat: <decimal>, lng: <decimal>}
  def professionals_suggestions
    # Location, popularity (followers), and a combination mixture of rating + # of reviews. In that order
    # sort by distance or get 10 miles users first, and then 20 miles, and then 50 miles etc
    lat = params[:lat]
    lng = params[:lng]
    unless lat.present? && lng.present?
      login = Login.where(user_id: @current_user.id).order(created_at: :desc).first
      lat = login.latitude if login.present?
      lng = login.longitude if login.present?
    end

    @users = User.joins("INNER join logins on logins.user_id=users.id AND logins.id = 
      (SELECT MAX(id) FROM logins WHERE logins.user_id = users.id)").where(professional: true).select("users.*, 
      logins.id as login_id, logins.latitude, logins.longitude, logins.location").near([lat, lng], 
      50).order("follower_count desc, distance desc").page(@page_param)
    
    render 'professionals'
  end

  def search_professionals
    # search professionals by name, professional type, location, or combination of type & location 
    # (such as 'personal trainers in Los Angeles').

    @users = User.joins("INNER join logins on logins.user_id=users.id AND logins.id = 
      (SELECT MAX(id) FROM logins WHERE logins.user_id = users.id)").where(professional: true).select("users.*, 
      logins.id as login_id, logins.latitude, logins.longitude, logins.location")

    professional_type = get_professional_type(params[:search])
    if professional_type.present?
      @users = @users.search_by_professional_type(professional_type)
      contains_preposition, preposition = param_contains_preposition(params[:search])
      if contains_preposition
        location = get_location(params[:search], preposition, professional_type)
        @users = @users.search_by_location(location) if location
      end
    else
      @users = @users.search_by_full_name(params[:search])
    end
    
    # Paginate
    @users = @users.page(@page_param)

    render 'professionals'
  end

private
  def find_user
    # Use find_by_hashid to not allow sequential ID lookups
    @user = User.find_by_hashid(params[:id])
    render json: { errors: "Couldn't find user with id=#{params[:id]}" }, status: 404 if @user.nil?
  end

  def get_professional_type(search_param)
    professional_type = nil
    PROFESSIONAL_TYPES.each do |type|
      if search_param.try(:downcase).include?(type.downcase)
        professional_type = type
      end
    end
    return professional_type
  end

  def param_contains_preposition(search_param)
    is_contained = false
    param_preposition = nil
    Prepositions.each do |preposition|
      if search_param.try(:split, ' ').map(&:downcase).include?(preposition.downcase)
        is_contained = true
        param_preposition = preposition
      end
    end
    return is_contained, param_preposition
  end

  def get_location(search_param, preposition, professional_type)
    if preposition
      location = search_param.split(preposition).last.try(:strip)
    else
      professional_type = professional_type.downcase.split(' ') + professional_type.downcase.pluralize.split(' ')
      location = search_param.downcase.split(' ') - professional_types
    end
    return location
  end

  def get_second_connect_query
    "Select id from follows where follower_id IN (Select user_id from follows where follower_id = #{@current_user.id})"
  end

end
