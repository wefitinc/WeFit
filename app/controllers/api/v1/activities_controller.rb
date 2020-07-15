class Api::V1::ActivitiesController < Api::V1::BaseController
  before_action :authorize, only: [:create, :update]
  before_action :set_activity, only: [:show, :update]
  before_action :validate_owner, only: [:update]

  # GET /activites
  def index
    render json: Activity.all
  end

  # POST /activities/filter
  def filter
    @activities = Activity.all
    @activities = @activities.paginate(page: filter_params[:page], per_page: 5) if filter_params[:page]

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
      :difficulty,
      :date)
  end
  def set_activity
    @activity = Activity.find(params[:id])
    render json: { errors: "Not found" }, status: 404 if @activity.nil?
  end
  def validate_owner
    render json: { errors: "You are not the owner of this activity" }, status: :unauthorized if not @current_user.id == @activity.user_id
  end
  
end
