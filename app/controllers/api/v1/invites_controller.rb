class Api::V1::InvitesController < Api::V1::BaseController 
  before_action :authorize
  before_action :find_user
  before_action :find_group
  before_action :check_membership

  # POST /groups/:id/invites
  def create
    @group.invites.where(user_id: @user.id, invited_by: @current_user.id).first_or_create
    render json: { message: "Invited to the group!" }
  end

private
  # Find the user being invited
  def find_user
    @user = User.find_by_hashid(params[:user_id])
    render json: { errors: "Couldn't find user with id=#{params[:user_id]}" }, status: 404 if @user.nil?
  end
  # Find the group that the user is being invited to
  def find_group
    @group = Group.find(params[:group_id])
  end
  # Check and make sure this person can invite the user to the group
  def check_membership
  	# To invite someone, the group must be public OR the inviter must already be a member 
  	@can_invite = @group.public? || @group.member?(@current_user)
    unless @can_invite 
      render json: { errors: "This group is not public, you must be a member to invite someone else" }, status: :unauthorized
    end
  end
end
