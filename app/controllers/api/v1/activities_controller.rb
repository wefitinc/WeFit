class Api::V1::ActivitiesController < Api::V1::BaseController
  before_action :authorize, only: [:create]
  before_action :set_activity, only: [:show]

  # GET /activites
  def index
    render json: Activity.all
  end

  # GET /activities/:id
  def show
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
  def set_activity
    @activity = Activity.find(params[:id])
  end
end
