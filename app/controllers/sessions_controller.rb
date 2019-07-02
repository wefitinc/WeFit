class SessionsController < ApplicationController
  def new
  end

  # Login controller action
  def create
  	# @user = User.find_or_create_from_auth_hash(env['omniauth.auth'])
  end

  # Logout controller action
  def destroy
  	session[:user_id] = nil
  	redirect_to root_path
  end

  def failure
  end
end
