class Api::V1::CommentsController < Api::V1::BaseController
  before_action :authorize, only: [ :create ]
  before_action :set_owner

  # GET /:owner/:id/comments
  def index
    render json: @owner.comments
  end
  # POST /:owner/:id/comments
  def create
    @owner.comments.where(user_id: @current_user.id, body: params[:body]).create
    render json: { message: "Commented!" }
  end
  # POST /:owner/:id/comments/:id
  def destroy
    @comment = Comment.find_by(id: params[:id])
    @comment.destroy if @comment.present?
    render json: { message: "Uncommented!" }
  end

private
  def set_owner
    if params[:post_id]
      @owner = Post.find(params[:post_id])
      render json: { errors: "Post not found" }, status: :not_found if @owner.nil?
    elsif params[:topic_id]
      @owner = Topic.find(params[:topic_id])
      render json: { errors: "Topic not found" }, status: :not_found if @owner.nil?
    else
      render json: { errors: "Owner type not supported" }, status: :not_implemented
    end
  end
end