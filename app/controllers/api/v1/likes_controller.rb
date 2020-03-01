class Api::V1::LikesController < Api::V1::BaseController
  before_action :authorize, only: [:create]
  before_action :find_post

  # GET /api/v1/posts/:id/likes
  def index
    render json: @post.likes
  end
  # POST /api/v1/posts/:id/likes
  def create
    @post.likes.where(user_id: @current_user.id).first_or_create
    render json: { message: "Liked" }
  end

private
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
  # Find the post for this like
  def find_post
  	@post = Post.find(params[:post_id])
  end
end
