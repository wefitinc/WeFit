class Api::V1::UsersController < Api::V1::BaseController
  before_action :set_user, only: [:show]

  # GET /users/:id
  def show
    render_user @user
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      # Use find_by_hashid to not allow sequential ID lookups
      @user = User.find_by_hashid(params[:id])
    end
end