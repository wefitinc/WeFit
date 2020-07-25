class Api::V1::FollowsController < Api::V1::BaseController
  before_action :find_user
  before_action :authorize, only: [:create, :destroy]

  # GET /users/:user_id/following
  def index_following
    render json: @user.following
  end
  # GET /users/:user_id/followers
  def index_followers
    render json: @user.followers
  end

  # POST /users/:user_id/followers
  def create
    @follow = @user.follows.where(follower_id: @current_user.id).first_or_create
    if @follow.valid?
      render json: { message: "Followed" }
    else
      render json: { errors: @follow.errors }, status: :unprocessable_entity
    end
  end

  # DELETE /users/:user_id/followers
  def destroy
    @follow = @user.follows.where(follower_id: @current_user.id).first
    @follow.destroy if !@follow.nil?
    render json: { message: "Unfollowed" }
  end

private
  def find_user
    @user = User.find_by_hashid(params[:user_id])
    render json: { errors: "Couldn't find user with id=#{params[:user_id]}" }, status: 404 if @user.nil?
  end
end
