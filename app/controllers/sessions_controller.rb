class SessionsController < ApplicationController
  def new
  end

  # Login controller action
  def create
    # If there isn't a provider, this is not an Omniauth login
    if not params[:provider] 
      # Get the user from the DB by the email
    	user = User.find_by_email(params[:email])
      # If the user exists and the password is correct
      if user && user.authenticate(params[:password])
        # Set the user id in the session
        session[:user_id] = user.id
        # Go back home
        redirect_to root_url
      else
        # TODO: Flash invalid email and password or something
        redirect_to root_url
      end
    else
      # TODO: Add ommiauth 
    end
  end

  # Logout controller action
  def destroy
    # Set the session user id to nil
  	session[:user_id] = nil
    # Go back home
  	redirect_to root_path
  end

  def failure
  end
end
