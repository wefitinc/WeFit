require 'json_web_token'

class Api::V1::AuthController < Api::V1::BaseController
  before_action :authorize, except: :login

  # POST /auth/login
  def login 
    @user = User.find_by_email(login_params[:email])
    if @user&.authenticate(login_params[:password])
      token = JsonWebToken.encode(user_id: @user.id)
      time = Time.now + 24.hours.to_i
      render json: { token: token, exp: time.strftime("%m-%d-%Y %H:%M") }, status: :ok
    else
      render json: { error: 'unauthorized' }, status: :unauthorized
    end
  end

  # GET /auth/test
  def test
    render json: { status: 'ok' }, status: :ok
  end

private
  def authorize
  	header = request.headers['Authorization']
  	header = header.split(' ').last if header
  	begin
  		@decoded = JsonWebToken.decode(header)
  		@current_user = User.find(@decoded[:user_id])
      render json: { errors: "User not found" }, status: :not_found if @current_user == nil
  	rescue JWT::DecodeError => e
  		render json: { errors: e.message }, status: :unauthorized
  	end 
  end
  def login_params
    params.permit(
        :email, 
        :password)
  end
end