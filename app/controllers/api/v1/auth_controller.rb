require 'json_web_token'

class Api::V1::AuthController < Api::V1::BaseController
  before_action :authorize, except: [:login, :signup]

  # POST /auth/login
  def login 
    # Get the user by the email
    @user = User.find_by_email(login_params[:email])
    # If the user exists and the password matches
    if @user&.authenticate(login_params[:password])
      # Encode a new token with their user ID
      @token = JsonWebToken.encode(user_id: @user.hashid)
      @time = Time.now + 24.hours.to_i
      # Send the token as a response
      render json: { token: @token, exp: @time.strftime("%m-%d-%Y %H:%M"), user_id: @user.hashid }, status: :ok
    else
      render json: { error: 'Email or password incorrect' }, status: :unauthorized
    end
  end

  # POST /auth/signup
  def signup
    # Try and make a new user
    @user = User.new(signup_params)
    if @user.save
      # Encode a new token with their user ID
      @token = JsonWebToken.encode(user_id: @user.hashid)
      @time = Time.now + 24.hours.to_i
      # Send the token as a response
      render json: { token: @token, exp: @time.strftime("%m-%d-%Y %H:%M"), user_id: @user.hashid }, status: :ok
    else
      # Signup failed, abort
      render json: { errors: @user.errors }, status: :unprocessable_entity
    end
  end

  # GET /auth/check
  def check
    render json: { status: 'ok' }, status: :ok
  end

  # GET /auth/me
  def me
    render json: @current_user, except: [
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

  private
    def login_params
      params.permit(
          :email, 
          :password)
    end
    def signup_params
      params.permit(
        :email,
        :first_name,
        :last_name,
        :gender,
        :birthdate,
        :password)
    end
end