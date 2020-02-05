class Api::V1::UsersController < Api::V1::BaseController
  before_action :set_user, only: [:show]

  # GET /users/:id
  def show
    # Render the user
    render json: @user
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      # Use find_by_hashid to not allow sequential ID lookups
      @user = User.find_by_hashid(params[:id])
      # Return a not found error if the user doesnt exist
      render json: { error: 'User not found' }, status: :not_found if @user.nil?
    end
end