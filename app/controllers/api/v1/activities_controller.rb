class Api::V1::ActivitiesController < Api::V1::BaseController
  before_action :authorize, only: [:index, :create, :update, :filter, :destroy, :show, :search]
  before_action :set_activity, only: [:show, :update, :destroy]
  before_action :validate_owner, only: [:update, :destroy]

  # GET /activites
  # Params: {page: <int>, lat: <decimal>, lng: <decimal>}
  def index
    # Initial Filters: upcoming, 25 miles, and all difficulties selected.
    @lat = params[:latitude]
    @lon = params[:longitude]
    # Order by event date/time
    @activities = Activity.all.order('event_time ASC').where("date(event_time) > ?", Date.today)
    # Filter by location
    @activities = @activities.near([@lat, @lon], InitialRadialDistance) if @lat && @lon
    # Paginate results
    @activities = @activities.paginate(page: @page_param)
    # Get participants list
    attendee_list, absentee_list = get_participants_list(@activities)
    # Render results
    render json: { 
      current_page: @activities.current_page, 
      total_pages:  @activities.total_pages,
      activities: ActiveModelSerializers::SerializableResource.new(@activities, 
        current_user: @current_user, attendee_list: attendee_list, absentee_list: absentee_list).as_json
    }
  end

  # GET /activities/suggestions
  def suggestions
    # Use index API to get suggestions
  end

  # POST /activities/search
  def search
    @activities = Activity.where("date(event_time) > ?", Date.today).search_for(params[:search]).paginate(page: @page_param)
    # Get participants list
    attendee_list, absentee_list = get_participants_list(@activities)
    # Render results
    render json: { 
      current_page: @activities.current_page, 
      total_pages:  @activities.total_pages,
      activities: ActiveModelSerializers::SerializableResource.new(@activities, 
        current_user: @current_user, attendee_list: attendee_list, absentee_list: absentee_list).as_json
    }
  end

  # POST /activities/filter
  def filter
    # All activities by default
    @activities = Activity.all
    # Order by event date/time
    @activities = @activities.order('event_time ASC').where("event_time > ?", Time.now.in_time_zone)
    # Filter based on attending
    @activities = @activities.joins(:attendees).where(user_id: @current_user.id) if filter_params[:attending]
    # Filter based on date
    @activities = @activities.where(event_time: filter_params[:min_date]..filter_params[:max_date]) if filter_params[:min_date] && filter_params[:max_date]
    # Filter for difficulty
    # @activities = @activities.min_difficulty(filter_params[:min_difficulty]) if filter_params[:min_difficulty]
    # @activities = @activities.max_difficulty(filter_params[:max_difficulty]) if filter_params[:max_difficulty]
    @activities = @activities.in_difficulty(filter_params[:difficulty]) if filter_params[:difficulty]
    # Filter by location
    @lat = filter_params[:latitude]
    @lon = filter_params[:longitude]
    # @radius = filter_params[:radius]
    @radius = filter_params[:max_proximity]
    # Filter activities where the distance is within the radius
    @activities = @activities.near([@lat, @lon], @radius) if (@radius != -1) and @lat and @lon
    # Paginate results
    @page = filter_params[:page] || 1
    @activities = @activities.paginate(page: @page, per_page: 10)
    # Get participants list
    attendee_list, absentee_list = get_participants_list(@activities)
    # Render results
    render json: { 
      current_page: @activities.current_page, 
      total_pages:  @activities.total_pages,
      activities: ActiveModelSerializers::SerializableResource.new(@activities, current_user: @current_user).as_json
    }
  end

  # GET /activities/:id
  def show
    # Get participants list
    attendee_list, absentee_list = get_participants_list([@activity])
    # Render results
    render json: { 
      activity: ActiveModelSerializers::SerializableResource.new(@activity, 
        current_user: @current_user, attendee_list: attendee_list, absentee_list: absentee_list).as_json
    }
  end

  # PUT/PATCH /activities/:id
  def update
    # @activity.image.attach(data: params[:image]) if not params[:image].nil?
    if not @activity.update(activity_params) then
      render json: { errors: @activity.errors }, status: :unprocessable_entity
    end
    render json: @activity
  end

  # POST /activities
  def create
    # Create the activity
    @activity = Activity.new(activity_params)
    # Set the owner to the logged in user
    @activity.user_id = @current_user.id
    # Attach the image to the activity
    @activity.image.attach(data: params[:image]) if not params[:image].nil?
    # Attempt to save in DB
    if @activity.save
      render json: @activity
    else
      render json: { errors: @activity.errors }, status: :unprocessable_entity
    end
  end

  # DELETE /activities/:id
  def destroy
    @activity.destroy
    render json: { message: "Activity destroyed" }
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
      :difficulty, 
      :latitude, 
      :longitude,
      :image_url)
  end
  def filter_params
    params.require(:filters).permit(
      :page, 
      :attending,
      :min_date, :max_date,
      :min_difficulty, :max_difficulty,
      :min_proximity, :max_proximity,
      :latitude, :longitude, :radius,
      difficulty: [])
  end
  def set_activity
    @activity = Activity.find(params[:id])
    render json: { errors: "Not found" }, status: 404 if @activity.nil?
  end
  def validate_owner
    render json: { errors: "You are not the owner of this activity" }, status: :unauthorized if not @current_user.id == @activity.user_id
  end

end
