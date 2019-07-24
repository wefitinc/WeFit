class Api::V1::UsersController < Api::V1::BaseController
  before_action :set_user, only: [:show]

  # GET /users/:id
  def show
    render json: @user, except: [
      # Strip the user id, it's internal
      :id, 
      # Do NOT include the password digest or anything related to it!
      :password_digest, 
      # Strip the database timestamps
      # NOTE: No security reason, they're just not useful
      :created_at, :updated_at, 
      # Strip reset data
      # NOTE: Not a huge security risk, but nothing would need it
      :reset_digest, :reset_sent_at]
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      # Use find_by_hashid to not allow sequential ID lookups
      @user = User.find_by_hashid(params[:id])
    end
end