class Api::V1::ViewsController < ApplicationController
  before_action :find_post
  before_action :authorize, only: [:create]

  def index
  	render json: @post.views
  end

  def create
    @view = @post.views.where(user_id: @current_user.id).first_or_create
    render json: { message: "Viewed" }
  end

private
  def find_post
    @post = Post.find(params[:post_id])
    render json: { message: "Post not found" }, status: :not_found if @post.nil?
  end
end
