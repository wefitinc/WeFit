class Api::V1::MembersController < Api::V1::BaseController
  before_action :find_group
  before_action :authorize, only: [:create, :destroy]
  before_action :check_can_join, only: [:create]

  # GET /groups/:id/members
  def index
    render json: @group.members
  end
  # POST /groups/:id/members
  def create
    @group.members.where(user_id: @current_user.id).first_or_create
    render json: { message: "Joined the group!" }
  end
  # DELETE /groups/:id/members
  def destroy
    @group.members.where(user_id: @current_user.id).destroy
    render json: { message: "Left the group!" }
  end

private
  # Find the group for this membership
  def find_group
    @group = Group.find(params[:group_id])
  end
  # Check and make sure the user can join 
  def check_can_join
    # A user can join a group if it's public OR they've been previously invited
    @can_join = @group.public? || @group.invited?(@current_user) 
    unless @can_join
      render json: { errors: "This group is not public, you must be invited" }, status: :unauthorized
    end
  end
end
