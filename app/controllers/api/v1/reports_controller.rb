class Api::V1::ReportsController < Api::V1::BaseController
  before_action :authorize, only: [ :create, :destroy ]
  before_action :set_owner

  # GET /:owner/:id/reports
  def index
    render json: @owner.reports
  end
  # POST /:owner/:id/reports
  def create
    @owner.reports.where(user_id: @current_user.id).first_or_create
    render json: { message: "Reported!" }
  end

private
  def set_owner
    if params[:post_id]
      @owner = Post.find(params[:post_id])
      render json: { errors: "Post not found" }, status: :not_found if @owner.nil?
    elsif params[:activity_id]
      @owner = Activity.find(params[:activity_id])
      render json: { errors: "Activity not found" }, status: :not_found if @owner.nil?
    else
      render json: { errors: "Owner type not supported" }, status: :not_implemented
    end
  end
end
