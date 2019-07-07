class SessionsController < ApplicationController
  # Create new user
  def new
    # Make a new user based on the user parameters
    @user = User.new(user_params)
    # Generate a response
    respond_to do |format|
      # If the user was successfully created
      if @user.save
        # Make the user automatically logged in
        session[:user_id] = @user.id
        # Redirect to root
        format.html { redirect_to root_path, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: root_path }
      else
        format.html { redirect_to root_path }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end

  end

  # Login controller action
  def create
    # Generate a response
    respond_to do |format|
      # If there isn't a provider, this is not an Omniauth login
      if not user_params[:provider] 
        # Get the user from the DB by the email
      	@user = User.find_by_email(user_params[:email])
        # If the user exists and the password is correct
        if @user && @user.authenticate(user_params[:password])
          # Set the user id in the session
          session[:user_id] = @user.id
          format.html { redirect_to root_url }
          format.json { render :show, status: :created, location: root_path }
        else
          # TODO: Flash invalid email and password or something
          format.html { redirect_to root_url, notice: "Invalid email or password" }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      else
        # Get from OmniAuth
        @user = User.find_or_create_from_auth_hash(env["omniauth.auth"])
        if @user
          # Set the user id in the session
          session[:user_id] = @user.id
          format.html { redirect_to root_url }
          format.json { render :show, status: :created, location: root_path }
        else
          format.html { redirect_to root_url, notice: "Failed to authenticate" }
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

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(
        :email, 
        :password,  
        :provider, 
        :uid, 
        :first_name, 
        :last_name,
        :gender,
        :birthdate)
    end
end
