class Api::V1::AttendeesController < Api::V1::BaseController
  before_action :find_activity
  before_action :authorize, only: [:create, :destroy]

  # GET /api/v1/activities/:id/attendees
  def index
    render json: @activity.attendees
  end
  # POST /api/v1/activities/:id/attendees
  def create
    @activity.attendees.where(user_id: @current_user.id).first_or_create
    render json: { message: "Marked as attending" }
  end
  # DELETE /api/v1/activities/:id/attendees
  def destroy
    @attendee = @activity.attendees.where(user_id: @current_user.id).first
    @attendee.destroy if !@attendee.nil?
    render json: { message: "No longer attending" }
  end

private
  def find_activity
    @activity = Activity.find(params[:activity_id])
    render json: { message: "Activity not found" }, status: :not_found if @activity.nil?
  end
end
