class Api::V1::LikesController < Api::V1::BaseController
  before_action :find_post
  before_action :authorize, only: [:create]

  # GET /api/v1/posts/:id/likes
  def index
    render json: @post.likes
  end
  # POST /api/v1/posts/:id/likes
  def create
    @post.likes.where(user_id: @current_user.id).first_or_create
    render json: { message: "Liked!" }
  end

private
  def find_post
    @post = Post.find(params[:post_id])
    render json: { message: "Post not found" }, status: :not_found if @post.nil?
  end
end
