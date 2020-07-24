class Api::V1::GroupsController < Api::V1::BaseController
  before_action :authorize, only: [:create, :destroy]
  before_action :set_group, only: [:show, :destroy]
  before_action :check_owner, only: [:destroy]

  # GET /groups
  def index
  	render json: Group.all
  end

  # GET /groups/:id
  def show
  	render json: @group
  end

  # POST /groups
  def create
    # Create the group
    @group = Group.new(group_params)
    # Set the owner to the logged in user
    @group.user_id = @current_user.id
    # Save to DB
    if @group.save
      render json: @group
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
  	render json: { message: "Group not found" }, status: :not_found if @group.nil?
  end

  def check_owner
    unless @group.user_id == @current_user.id
      render json: { errors: "You are not the owner of this group" }, status: :unauthorized 
    end
  end

  def group_params
  	params.require(:group).permit(
      :title,
      :location,
      :description,
      :public)
  end
end
