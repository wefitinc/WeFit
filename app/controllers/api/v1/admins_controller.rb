class Api::V1::AdminsController < Api::V1::BaseController
  before_action :authorize, only: [:create, :remove]
  before_action :set_group
  before_action :set_user, only: [:create, :remove]
  before_action :check_owner_or_admin, only: [:create]
  before_action :check_owner, only: [:remove]

  # GET /groups/:id/admins
  def index
    render json: @group.admins
  end
  # POST /groups/:id/admins
  # Params: {user_id: <hashid>} => this is user hashid to be added as admin
  def create
    # owner and admins can both add admins
    # admin can delete posts and respond to join request for private groups
    @group.admins.where(user_id: @user.id).first_or_create
    render json: { message: "Added as Admin!" }
  end

  # POST /groups/:group_id/admins/remove
  # Params: {user_id: <hashid>} => this is user hashid to be added as admin
  def remove
    # only owner can remove admins
    @group.admins.where(user_id: @user.id).last.destroy
    render json: { message: "Removed as Admin!" }
  end

private

  def set_group
    @group = Group.find(params[:group_id])
  end

  def set_user
    @user = User.find_by_hashid(params[:user_id])
  end

  def check_owner_or_admin
    unless @group.user_id == @current_user.id || @group.admins.pluck(:user_id).include?(@current_user.id)
      render json: { errors: "You are not the owner or admin of this group" }, status: :unauthorized 
    end
  end

  def check_owner
    unless @group.user_id == @current_user.id
      render json: { errors: "You are not the owner of the group" }, status: :unauthorized 
    end
  end
  
end
