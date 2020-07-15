class Api::V1::ActivitiesController < Api::V1::BaseController
  before_action :authorize, only: [:create, :update, :filter]
  before_action :set_activity, only: [:show, :update]
  before_action :validate_owner, only: [:update]

  # GET /activites
  def index
    render json: Activity.all
  end

  # POST /activities/filter
  def filter
    # All activities by default
    @activities = Activity.all
    # Filter based on attending
    @activities = @activities.joins(:attendees).where(user_id: @current_user.id) if filter_params[:attending]
    # Filter for difficulty
    @activities = @activities.min_difficulty(filter_params[:min_difficulty]) if filter_params[:min_difficulty]
    @activities = @activities.max_difficulty(filter_params[:max_difficulty]) if filter_params[:max_difficulty]
    # Paginate results
    @activities = @activities.paginate(page: filter_params[:page], per_page: 5) if filter_params[:page]
    # Render results
    render json: @activities
  end

  # GET /activities/:id
  def show
    render json: @activity
  end

  # PUT/PATCH /activities/:id
  def update
    @activity.update(activity_params)
    render json: @activity
  end

  # POST /activities
  def create
    # Create the activity
    @activity = Activity.new(activity_params)
    # Set the owner to the logged in user
    @activity.user_id = @current_user.id
    # Attempt to save in DB
    if @activity.save
      render json: @activity
    else
      render json: { errors: @activity.errors }, status: :unprocessable_entity
    end
  end

private
  def activity_params
    params.require(:activity).permit(
      :name,
      :description,
      :event_time,
      :google_placeID,
      :location_name,
      :location_address,
      :difficulty)
  end
  def filter_params
    params.require(:filters).permit(
      :page, 
      :attending,
      :min_difficulty, :max_difficulty)
  end
  def set_activity
    @activity = Activity.find(params[:id])
    render json: { errors: "Not found" }, status: 404 if @activity.nil?
  end
  def validate_owner
    render json: { errors: "You are not the owner of this activity" }, status: :unauthorized if not @current_user.id == @activity.user_id
  end
  
end
