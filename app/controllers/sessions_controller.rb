class SessionsController < ApplicationController
  # before_action :set_user, only: [ :update ]
  
  # Create new user
  def new
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        session[:user_id] = @user.id

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
    # If there isn't a provider, this is not an Omniauth login
    if not params[:provider] 
      # Get the user from the DB by the email
    	user = User.find_by_email(params[:email])
      # If the user exists and the password is correct
      if user && user.authenticate(params[:password])
        # Set the user id in the session
        session[:user_id] = user.id
        redirect_to root_url
      else
        # TODO: Flash invalid email and password or something
        redirect_to root_url, notice: "Invalid email or password"
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(
        :email, 
        :password, 
        :password_confirmation, 
        :provider, 
        :uid, 
        :first_name, 
        :last_name,
        :gender,
        :birthdate)
    end
end
