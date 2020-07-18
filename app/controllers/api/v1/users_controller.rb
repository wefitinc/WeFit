class Api::V1::UsersController < Api::V1::BaseController
  before_action :set_user, only: [:show, :destroy, :reset]
  before_action :check_debug, only: [:destroy]

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

  # POST /users/:id/reset
  def reset
    @user.create_reset_digest
    @user.send_password_reset_email
    render json: { message: "Password reset email sent" }, status: :ok
  end

  # GET /users/professionals
  def index_professionals
    @users = User.all
    render json: @users.where(professional: true)
  end

private
  def set_user
    # Use find_by_hashid to not allow sequential ID lookups
    @user = User.find_by_hashid(params[:id])
    render json: { errors: "Not found" }, status: 404 if @user.nil?
  end
end