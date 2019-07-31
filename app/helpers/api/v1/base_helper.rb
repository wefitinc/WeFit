# Require JSON web token code
require 'json_web_token'

module Api::V1::BaseHelper
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

  def render_user(user)
    render json: user, except: [
      # Strip the user id, it's internal
      :id, 
      # Do NOT include the password digest or anything related to it!
      :password_digest, 
      # Strip the database timestamps
      # NOTE: No security reason, they're just not useful
      :created_at, :updated_at, 
      # Strip reset data
      # NOTE: Not a huge security risk, but nothing would need it
      :reset_digest, :reset_sent_at]
  end
end
