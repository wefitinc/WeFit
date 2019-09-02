class UsersController < ApplicationController
  # GET /
  def new
    @user = User.new
  end
  # POST /users
  def create
    # Make a new user based on the user parameters
    @user = User.new(user_params)
    # If the user was successfully created
    if @user.save
      # Make the user automatically logged in
      log_in @user
      # Redirect to root
      redirect_to root_path
    else
      render 'index'
    end
  end

  # GET /account_settings
  def edit
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