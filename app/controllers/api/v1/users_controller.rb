class Api::V1::UsersController < Api::V1::BaseController
  before_action :set_user
  before_action :check_debug, only: [:delete]

  # GET /users/:id
  def show
    # Render the user
    render json: @user
  end

  # DELETE /users/:id
  def destroy
    @user.destroy
    render json: { message: "Account deleted" }
  end

private
  def set_user
    # Use find_by_hashid to not allow sequential ID lookups
    @user = User.find_by_hashid(params[:id])
    render json: { errors: "Not found" }, status: 404 if @user.nil?
  end
end