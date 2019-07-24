require 'json_web_token'

class Api::V1::AuthController < Api::V1::BaseController
  before_action :authorize, except: :login

  # POST /auth/login
  def login 
    # Get the user by the email
    @user = User.find_by_email(login_params[:email])
    # If the user exists and the password matches
    if @user&.authenticate(login_params[:password])
      # Encode a new token with their user ID
      @token = JsonWebToken.encode(user_id: @user.id)
      @time = Time.now + 24.hours.to_i
      # Send the token as a response
      render json: { token: @token, exp: @time.strftime("%m-%d-%Y %H:%M"), user_id: @user.id }, status: :ok
    else
      render json: { error: 'unauthorized' }, status: :unauthorized
    end
  end

  # GET /auth/test
  def test
    render json: { status: 'ok' }, status: :ok
  end

  # GET /auth/user
  def user
    # Strip out some sensitive user data and return as JSON 
    render json: @current_user, except: [:created_at, :updated_at, :password_digest, :reset_digest, :reset_sent_at]
  end

  private
    def authorize
      # Get the authorization token from the header
    	header = request.headers['Authorization']
    	header = header.split(' ').last if header
    	begin
        # Try and decode the token
    		@decoded = JsonWebToken.decode(header)
        # Get the user by the user ID from the token
    		@current_user = User.find(@decoded[:user_id])
        # Return an error if the user doesn't exist 
        # NOTE: This should not happen, the token is encoded and signed with the secret key
        # But just incase theres a server error or something
        render json: { errors: "User not found" }, status: :not_found if @current_user == nil
    	rescue JWT::DecodeError => e
        # If theres an error decoding the token, respond with the error and a 401 status
    		render json: { errors: e.message }, status: :unauthorized
    	end 
    end
    def login_params
      params.permit(
          :email, 
          :password)
    end
end