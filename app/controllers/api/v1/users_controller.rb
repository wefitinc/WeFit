class Api::V1::UsersController < Api::V1::BaseController
  before_action :set_user, only: [:show]

  # GET /users/:id
  def show
    # Strip out some sensitive user data and return as JSON 
    # render json: , except: [:created_at, :updated_at, :password_digest, :reset_digest, :reset_sent_at]
    render 'users/show'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end
end