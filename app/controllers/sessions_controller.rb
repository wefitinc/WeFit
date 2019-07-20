class SessionsController < ApplicationController

  # Login controller action
  def create
    # Generate a response
    respond_to do |format|
      # If there isn't a provider, this is not an Omniauth login
      if not params[:provider] 
        # Get the user from the DB by the email
      	@user = User.find_by_email(params[:email])
        # If the user exists 
        if @user
          # If the password is correct
          if @user.authenticate(params[:password])
            # Set the user id in the session
            session[:user_id] = @user.id
            format.html { redirect_back fallback_location: root_path }
            format.json { render :show, status: :created, location: root_path }
          else
            flash[:login_notice] = "Invalid email or password"
            format.html { redirect_back fallback_location: root_path }
            format.json { render json: @user.errors, status: :unprocessable_entity }
          end
        else
          flash[:login_notice] = "Email not registered"
          format.html { redirect_back fallback_location: root_path }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      else
        # Get from OmniAuth
        @user = User.find_or_create_from_auth_hash(env["omniauth.auth"])
        if @user
          # Set the user id in the session
          session[:user_id] = @user.id
          format.html { redirect_back fallback_location: root_path }
          format.json { render :show, status: :created, location: root_path }
        else
          format.html { redirect_back fallback_location: root_path, notice: "Failed to authenticate" }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
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
