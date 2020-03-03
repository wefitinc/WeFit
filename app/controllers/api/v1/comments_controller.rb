class Api::V1::CommentsController < Api::V1::BaseController
  before_action :find_post
  before_action :authorize, only: [:create]

  # GET /posts/:id/comments
  def index
  	render json: @post.comments
  end

  # POST /posts/:id/comments
  def create
    @comment = @post.comments.where(user_id: @current_user.id, body: params[:body]).create
    if @comment.valid?
      render json: @comment
    else
      render json: { errors: @comment.errors }, status: :unprocessable_entity
    end
  end

private
  # Find the post for this comment
  def find_post
  	@post = Post.find(params[:post_id])
  end	
end
