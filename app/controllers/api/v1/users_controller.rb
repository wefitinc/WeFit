class Api::V1::UsersController < Api::V1::BaseController
  before_action :set_user, only: [:show]

  # GET /users/:id
  def show
    # Render the user
    render json: @user
  end

private
  def set_user
    # Use find_by_hashid to not allow sequential ID lookups
    @user = User.find_by_hashid(params[:id])
    render json: { errors: "Not found" }, status: 404 if @user.nil?
  end
end