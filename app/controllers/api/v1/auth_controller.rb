# Require JSON web token code
require 'json_web_token'

class Api::V1::AuthController < Api::V1::BaseController
  # Make sure to authorize the user
  before_action :authorize, except: [ :login, :logins, :signup ]
  before_action :check_debug, only: [ :logins ]

  # POST /auth/login
  def login 
    # Get the user by the email
    @user = User.find_by_email(login_params[:email])
    # If the user exists and the password matches
    if @user&.authenticate(login_params[:password])
      render_login
    else
      # Login failed, send an error message
      render json: { errors: 'Email or password incorrect' }, status: :unauthorized
    end
  end

  # POST /auth/signup
  def signup
    # Try and make a new user
    @user = User.new(signup_params)
    if @user.save
      render_login
    else
      # Signup failed, abort
      render json: { errors: @user.errors }, status: :unprocessable_entity
    end
  end

  # GET /auth/check
  def check
    @header = request.headers['Authorization']
    @token  = @header.split(' ').last 
    render json: { message: 'Authorization token valid', token: @token }, status: :ok
  end

  # GET /auth/me
  def me
    render json: @current_user
  end

  # POST /auth/upgrade
  def upgrade
    @current_user.update(
      bio: params[:bio],
      professional: true, 
      professional_type: params[:professional_type])
    if @current_user.save then
      render json: @current_user
    else
      render json: { errors: @current_user.errors }, status: :unprocessable_entity
    end
  end

  # GET /auth/logins
  def logins
    @logins = Login.all
    render json: @logins
  end

private
  # Parameters for logging in
  # NOTE: Should we take in device location/type here too?
  def login_params
    params.permit(
        :email, 
        :password)
  end
  # Parameters for signing up
  def signup_params
    params.permit(
      :email,
      :password,
      :first_name,
      :last_name,
      :gender,
      :birthdate,
      :bio,
      :professional)
  end
  # Generate an authorization token and record a successful login
  def render_login
    # Encode a new token with their user ID
    @token = JsonWebToken.encode(user_id: @user.hashid)
    @time = Time.now + 24.hours.to_i
    # Record the login 
    @user.logins.create!(ip_address: request.remote_ip)
    # Send the token as a response
    render json: { token: @token, exp: @time.strftime("%m-%d-%Y %H:%M"), user_id: @user.hashid }, status: :ok
  end
end