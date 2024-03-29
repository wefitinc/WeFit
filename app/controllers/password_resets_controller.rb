class PasswordResetsController < ApplicationController
  # Before updating the password:
  #   Get the user
  before_action :get_user,   only: [:edit, :update]
  #   Check the user is valid (and reset token matches)
  before_action :valid_user, only: [:edit, :update]
  #   Check the reset is not expired
  before_action :check_expiration, only: [:edit, :update]

  def new
  end

  def create
  	@user = User.find_by(email: params[:password_reset][:email])
  	if @user
  		@user.create_reset_digest
  		@user.send_password_reset_email
  		redirect_to root_url
  	else
      # TODO: Flash an error or something
  		render 'new'
  	end
  end

  def edit
  end

  def update
    if params[:user][:password].empty?
      # Password field was empty
      render 'edit'
    elsif @user.update_attributes(user_params)
      # Success, password updated
      session[:user_id] = @user.id
      redirect_to root_url
    else
      # Couldn't update?
      render 'edit'
    end
  end

private
  def user_params
    params.require(:user).permit(:password)
  end

  def get_user
    @user = User.find_by(email: params[:email])
  end
  # Checks if the user exists and the reset token matches
  def valid_user
    unless (@user && @user.authenticated?(:reset, params[:id]))
      render 'new'
    end
  end
  # Checks expiration of reset token.
  def check_expiration
    if @user.password_reset_expired?
      redirect_to new_password_reset_url
    end
  end
end
