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

  # Check for authorization in the header
  def authorize
    # Get the authorization token from the header
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    begin
      # Try and decode the token
      @decoded = JsonWebToken.decode(header)
      # Get the user by the user ID from the token
      @current_user = User.find_by_hashid(@decoded[:user_id])
      # Return an error if the user doesn't exist 
      # NOTE: This should not happen, the token is encoded and signed with the secret key
      # But just incase theres a server error or something
      render json: { errors: "User not found" }, status: :not_found if @current_user == nil
    rescue JWT::DecodeError => e
      # If theres an error decoding the token, respond with the error and a 401 status
      render json: { errors: e.message }, status: :unauthorized
    end 
  end
end
