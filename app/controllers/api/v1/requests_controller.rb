class Api::V1::RequestsController < Api::V1::BaseController
  before_action :find_group
  before_action :authorize
  before_action :set_user, only: [:reject]
  before_action :set_request, only: [:accept]
  before_action :check_owner_or_admin, only: [:reject, :accept]

  # GET /groups/:group_id/requests
  def index
    render json: @group.requests
  end
  # POST /groups/:group_id/requests
  def create
    @group.requests.where(user_id: @current_user.id).first_or_create
    render json: { message: "Requested!" }
  end
  # POST /groups/:group_id/requests/reject
  def reject
    @request = @group.requests.where(user_id: @user.id).first
    @request.destroy if not @request.nil?
    render json: { message: "Rejected!" }
  end
  # POST /groups/:group_id/requests/:id/accept
  def accept
    # Upon acceptance, the user will be accepted to the group
    @request.destroy
    @group.members.where(user_id: @request.user_id).first_or_create
    render json: { message: "Accepted!" }
  end

private
  # Find the group for this membership
  def find_group
    @group = Group.find(params[:group_id])
  end
  # Find the user with param :user_id
  def set_user
    @user = User.find_by_hashid(params[:user_id])
    render json: { errors: "Couldn't find user with id=#{params[:user_id]}" }, status: 404 if @user.nil?
  end
  # Find the user with param :user_id
  def set_request
    @request = JoinRequest.find_by_id(params[:id])
    render json: { errors: "Couldn't find request with id=#{params[:id]}" }, status: 404 if @request.nil?
  end
  # Check if current user is owner or admin => only then a request can be rejected
  def check_owner_or_admin
    unless @group.user_id == @current_user.id || @group.admins.pluck(:user_id).include?(@current_user.id)
      render json: { errors: "You are not the owner or admin of the group" }, status: :unauthorized 
    end
  end
end
