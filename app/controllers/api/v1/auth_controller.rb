# Require JSON web token code
require 'json_web_token'

class Api::V1::AuthController < Api::V1::BaseController
  # Make sure to authorize the user
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
      # Login failed, send an error message
      render json: { errors: 'Email or password incorrect' }, status: :unauthorized
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
    header = request.headers['Authorization']
    token = header.split(' ').last 
    render json: { message: 'Authorization token valid', token: token }, status: :ok
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

private
  def login_params
    params.permit(
        :email, 
        :password)
  end
  def signup_params
    params.permit(
      :email,
      :password,
      :first_name,
      :last_name,
      :gender,
      :birthdate,
      :bio)
  end
end