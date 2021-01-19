class Api::V1::GroupsController < Api::V1::BaseController
  before_action :authorize
  before_action :set_group, only: [:show, :destroy, :leave, :admin, :remove_admin]
  before_action :set_user, only: [:admin, :remove_admin]
  before_action :auth_group_action, only: [:destroy, :admin]
  before_action :check_owner, only: [:leave]

  # GET /groups
  def index
  	render json: Group.all, current_user: @current_user
  end

  # GET /groups/suggestions
  def suggestions
    joined_group_ids = Member.where(user_id: @current_user.id).pluck(:group_id)
    @groups = Group.where.not(id: joined_group_ids).order(members_count: :desc, title: :asc).page(@page_param)
    @invited_groups = Invite.where(user_id: @current_user, group_id: @groups.map(&:id)).pluck(:group_id)
    render json: { 
      current_page: @groups.current_page, 
      total_pages:  @groups.total_pages,
      groups: ActiveModelSerializers::SerializableResource.new(@groups, current_user: @current_user).as_json
    }
  end

  # POST /groups/search
  def search
    @groups = Group.search_for(params[:search]).order(members_count: :desc, title: :asc).page(@page_param)
    render json: { 
      current_page: @groups.current_page, 
      total_pages:  @groups.total_pages,
      groups: ActiveModelSerializers::SerializableResource.new(@groups, current_user: @current_user).as_json
    }
  end

  # POST /groups/filter
  def filter
    @groups = Group.all
    # Allow searching on groups
    @groups = @groups.search_for(filter_params[:search]) if filter_params[:search].present?
    # Allow for filtering based on if the current user is a member
    @groups = @groups.joins(:members).where(user_id: @current_user.id) if filter_params[:is_member].present?
    # Allow for filtering based on if the user has been invited
    @groups = @groups.joins(:invites).where(user_id: @current_user.id) if filter_params[:is_invited].present?
    # Render the posts
    render json: @groups, current_user: @current_user
  end

  # GET /groups/:id
  def show
  	render json: @group, current_user: @current_user
  end

  # POST /groups
  def create
    # Create the group
    @group = Group.new(group_params)
    # Set the owner to the logged in user
    @group.user_id = @current_user.id
    # Attach the image to the group
    @group.image.attach(data: params[:image]) if not params[:image].nil?
    # Save to DB
    if @group.save
      render json: @group, current_user: @current_user
    else
      render json: { errors: @group.errors }, status: :unprocessable_entity
    end
  end

  # POST /groups/:id/leave
  # Leave a group. 
  def leave
    # Owner can't leave the group
    Member.where(group_id: @group.id, user_id: @current_user.id).last.try(:destroy)
    render json: { message: "Group left" }
  end

  # DELETE /groups/:id
  def destroy
    @group.destroy
    render json: { message: "Group destroyed" }
  end

private
  def set_group
  	@group = Group.find(params[:id])
  end

  def set_user
    @user = User.find_by_hashid(params[:user_id])
  end

  def auth_group_action
    unless @group.user_id == @current_user.id || @group.admins.pluck(:user_id).include?(@current_user.id)
      render json: { errors: "You are not the owner or admin of this group" }, status: :unauthorized 
    end
  end

  def check_owner
    if @group.user_id == @current_user.id
      render json: { errors: "Owners can't leave the group" }, status: :unauthorized 
    end
  end

  def filter_params
    params.permit(
      :search,
      :is_member,
      :is_invited)
  end

  def group_params
  	params.require(:group).permit(
      :title,
      :location,
      :description,
      :public)
  end
end
