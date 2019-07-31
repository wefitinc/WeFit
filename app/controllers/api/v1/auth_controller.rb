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
      # Login failed, send an error message
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
    render_user @current_user
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