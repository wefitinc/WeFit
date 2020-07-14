class Api::V1::ReviewsController < Api::V1::BaseController
  before_action :find_user
  before_action :check_professional
  before_action :authorize, only: [:create, :destroy]

  # GET /users/:user_id/reviews
  def index
    @reviews = Review.all.where(professional_id: @user.id)
    render json: @reviews
  end

  # POST /users/:user_id/reviews
  def create
    @review = Review.create(user_id: @current_user.id, professional_id: @user.id, text: params[:text], stars: params[:stars])
    if @review.valid?
      render json: { message: "Review submitted" }
    else
      render json: { errors: @review.errors }, status: :unprocessable_entity
    end
  end

private
  def find_user
    @user = User.find_by_hashid(params[:user_id])
    render json: { errors: "User not found" }, status: 404 if @user.nil?
  end
  def check_professional
    render json: { errors: "This user is not a professional" }, status: :bad_request if not @user.professional? 
  end
end
