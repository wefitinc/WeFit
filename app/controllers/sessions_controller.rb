class SessionsController < ApplicationController
  # Login controller action
  def create
    # If there isn't a provider, this is not an Omniauth login
    if not params[:provider] 
      # Get the user from the DB by the email
    	@user = User.find_by_email(params[:email])
      # If the user exists 
      if @user
        # If the password is correct
        if @user.authenticate(params[:password])
          # Log in the user
          session[:user_id] = @user.id
          # Respond
          edirect_back fallback_location: root_path
        else
          flash[:login_notice] = "Invalid email or password"
          redirect_back fallback_location: root_path
        end
      else
        flash[:login_notice] = "Email not registered"
        redirect_back fallback_location: root_path
      end
    else
      # Get from OmniAuth
      @user = User.find_or_create_from_auth_hash(env["omniauth.auth"])
      if @user
        # Log in the user
        session[:user_id] = @user.id
        # Respond
        redirect_back fallback_location: root_path
      else
        redirect_back fallback_location: root_path, notice: "Failed to authenticate"
      end
    end
  end

  # Logout controller action
  def destroy
    # Log out the current user
    session[:user_id] = nil
    # Go back home
  	redirect_to root_path
  end

  def failure
  end
end
