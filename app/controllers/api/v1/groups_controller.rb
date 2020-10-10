class Api::V1::GroupsController < Api::V1::BaseController
  before_action :authorize
  before_action :set_group, only: [:show, :destroy]
  before_action :check_owner, only: [:destroy]

  # GET /groups
  def index
  	render json: Group.all, current_user: @current_user
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

  # DELETE /groups/:id
  def destroy
    @group.destroy
    render json: { message: "Group destroyed" }
  end

private
  def set_group
  	@group = Group.find(params[:id])
  end

  def check_owner
    unless @group.user_id == @current_user.id
      render json: { errors: "You are not the owner of this group" }, status: :unauthorized 
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
