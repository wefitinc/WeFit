class Api::V1::ViewsController < Api::V1::BaseController
  before_action :find_post
  before_action :authorize, only: [:create]

  # GET /views
  def index
  	render json: @post.views
  end
  # POST /views
  def create
    @view = @post.views.where(user_id: @current_user.id).first_or_create
    render json: { message: "Viewed" }
  end

private
  def find_post
    @post = Post.find(params[:post_id])
  end
end
