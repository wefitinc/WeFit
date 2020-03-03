class Api::V1::BaseController < ActionController::API
  # Include the base helper functions in every controller
  include Api::V1::BaseHelper

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
 
  rescue_from Exception do |exception|
    render json: { error: exception }, status: 500
  end

protected
  # Check for authorization in the header
  def authorize
    # Get the authorization token from the header
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    begin
      # Try and decode the token
      @decoded = JsonWebToken.decode(header)
      # Get the user by the user ID from the token
      @current_user = User.find_by_hashid(@decoded[:user_id])
      # Return an error if the user doesn't exist 
      # NOTE: This should not happen, the token is encoded and signed with the secret key
      # But just incase theres a server error or something
      render json: { errors: "User not found" }, status: :not_found if @current_user == nil
    rescue JWT::DecodeError => e
      # If theres an error decoding the token, respond with the error and a 401 status
      render json: { errors: e.message }, status: :unauthorized
    end 
  end

private
  def record_not_found
    render json: { error: "404 Not Found", status: 404 }, status: 404
  end
end
