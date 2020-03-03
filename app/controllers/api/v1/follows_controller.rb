class Api::V1::FollowsController < Api::V1::BaseController
  before_action :find_user
  before_action :authorize, only: [:create, :destroy]

  # GET /users/:user_id/follows
  def index_follows
    render json: @user.follows
  end
  # GET /users/:user_id/followers
  def index_followers
    render json: @user.followers
  end

  # POST /users/:user_id/followers
  def create
    @follow = Follow.where(user_id: @user.id, follower_id: @current_user.id).first_or_initialize
    if @follow.save
      render json: { message: "Followed" }
    else
      render json: { errors: @follow.errors }, status: :unprocessable_entity
    end
  end

  # DESTROY /users/:user_id/followers
  def destroy
    @follow = Follow.where(user_id: @user.id, follower_id: @current_user.id)
    @follow.destroy if @follow
    render json: { message: "Unfollowed" }
  end

private
  def find_user
    @user = User.find_by_hashid(params[:user_id])
    render json: { error: "Not found" }, status: 404 if @user.nil?
  end
end
