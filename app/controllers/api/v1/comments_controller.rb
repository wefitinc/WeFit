class Api::V1::CommentsController < Api::V1::BaseController
  before_action :authorize, only: [ :create, :destroy ]
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
    # If this is a topic comment, then even the admins/owner of the group can remove the comment.
    if @owner.class.name == "Topic"
      @comment = Comment.find_by_id(params[:id])
      auth_destroy_action(@owner.group)
    else
      @comment = @owner.comments.where(id: params[:id], user_id: @current_user.id).first
    end
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

  def auth_destroy_action(group)
    unless group.owner?(@current_user) || group.admin?(@current_user) || @comment.user_id == @current_user.id
      render json: { errors: "You are not the owner of comment or owner/admin of this group" }, status: :unauthorized 
    end
  end
end