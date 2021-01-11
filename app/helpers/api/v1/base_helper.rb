require 'json_web_token'

module Api::V1::BaseHelper

  # Check for authorization in the header
  def authorize
    # Get the authorization token from the header
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    if header.nil?
      render json: { errors: "Authorization token required" }, status: :unauthorized 
    else
      begin
        # Try and decode the token
        @decoded = JsonWebToken.decode(header)
        # Get the user by the user ID from the token
        @current_user = User.find_by_hashid(@decoded[:user_id])
        # Return an error if the user doesn't exist 
        # NOTE: This should not happen, the token is encoded and signed with the secret key
        # But just incase theres a server error or something
        render json: { errors: "User not found" }, status: :not_found if @current_user.nil?
      rescue JWT::DecodeError => e
        # If theres an error decoding the token, respond with the error and a 401 status
        render json: { errors: e.message }, status: :unauthorized
      end
    end
  end

  def check_debug
    debug_password = 'SuperSecretDebugAuthorization'
    debug_digest   = Digest::SHA256.digest debug_password

    header = request.headers['Debug']
    header = header.split(' ').last if header
    if header.nil? || Digest::SHA256.digest(header) != debug_digest
      render json: { errors: "Unauthorized access" }, status: :unauthorized
    end
  end

end
