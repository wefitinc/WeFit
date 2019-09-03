class UsersController < ApplicationController
  before_action :check_logged_in, only: [ :edit, :update ]

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
      render 'new'
    end
  end

  # GET /account_settings
  def edit
  end
  # PATCH /account_settings
  def update
    if @user.authenticate(user_params[:password])
      if not @user.update(user_params)
        @user.errors.add :base, "Failed to update"
      end
    else
      @user.errors.add :password, "does not match current password"
    end
    render 'edit'
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

    # Make sure we have a logged in user before we allow access to edit/update 
    def check_logged_in
      unless current_user?
        redirect_to root_path
      end
      @user = current_user
    end
end
