class Api::V1::BaseController < ActionController::API
  # Include the base helper functions in every controller
  include Api::V1::BaseHelper

  before_action :set_default_response_format
  before_action :get_page_param

  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response

  def not_found
    render json: { errors: "No route found for " }, status: not_found
  end

  def render_unprocessable_entity_response(exception)
    render json: exception.record.errors, status: :unprocessable_entity
  end

  def render_not_found_response(exception)
    render json: { error: exception.message }, status: :not_found
  end

  def set_default_response_format
    request.format = :json
  end

  def get_page_param
    @page_param = params[:page] || FirstPage
  end

  def get_participants_list(records)
    participants = Participant.where(activity_id: records.map(&:id), user_id: @current_user.id)
    attendee_list = []; absentee_list = []
    participants.each do |obj|
      attendee_list << obj.activity_id if obj.is_attending
      absentee_list << obj.activity_id unless obj.is_attending
    end
    return attendee_list, absentee_list
  end
  
end
