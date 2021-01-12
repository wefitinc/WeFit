class Api::V1::ParticipantsController < Api::V1::BaseController
  before_action :find_activity, only: [:index, :attendees]
  before_action :authorize, only: [:create, :destroy]

  # GET /api/v1/activities/:id/participants
  def index
    render json: @activity.participants
  end

  # GET /api/v1/activities/:id/participants/attendees
  def attendees
    render json: @activity.attendees
  end

  # POST /api/v1/activities/:activity_id/participants
  # Params: {is_attending: <boolean>}
  def create
    participant_obj = Participant.where(user_id: @current_user.id, activity_id: params[:activity_id]).last
    if participant_obj.present?
      unless participant_obj.is_attending == ActiveModel::Type::Boolean.new.cast(params[:is_attending])
        participant_obj.update(is_attending: params[:is_attending])
      end
    else
      Participant.create(user_id: @current_user.id, activity_id: params[:activity_id], 
        is_attending: params[:is_attending])
    end

    render json: { message: "Success" } 
  end

private
  def find_activity
    @activity = Activity.find(params[:activity_id])
    render json: { message: "Activity not found" }, status: :not_found if @activity.nil?
  end
end
