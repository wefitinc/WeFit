class UsersController < ApplicationController
  # POST /users
  # POST /users.json
  def create
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
