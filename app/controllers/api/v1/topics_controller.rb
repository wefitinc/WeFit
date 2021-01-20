class Api::V1::TopicsController < Api::V1::BaseController
  before_action :authorize
  before_action :set_group, only: [ :index, :create ]
  before_action :set_topic, only: [ :show, :destroy ]
  before_action :check_member, only: [ :create ]
  before_action :check_owner_or_admin, only: [ :destroy ]

  # GET /topics
  # Default => show recent posts at the top
  # Params: {popular: true} => this will show popular posts at the top
  def index
    if params[:popular]
      @topics = @group.topics.order('likes_count + comments_count DESC').page(@page_param)
    else
      @topics = @group.topics.order(created_at: :desc).page(@page_param)
    end
  	render json: @topics, current_user: @current_user
  end

  # GET /topics/:id
  def show
  	render json: @topic, current_user: @current_user
  end

  # POST /topics
  def create
    # Create the topic
    @topic = Topic.new(topic_params)
    # Set the group
    @topic.group = @group
    # Set the owner to the logged in user
    @topic.user_id = @current_user.id
    # Attach the image to the topic
    @topic.image.attach(data: params[:image]) if not params[:image].nil?
    # Save to DB
    if @topic.save
      render json: @topic, current_user: @current_user
    else
      render json: { errors: @topic.errors }, status: :unprocessable_entity
    end
  end

  # DELETE /topics/:id
  def destroy
    @topic.destroy
    render json: { message: "Topic destroyed" }
  end

private
  def set_group
  	@group = Group.find(params[:group_id])
  end
  def set_topic
  	@topic = Topic.find(params[:id])
  end

  def check_member
    unless @group.member?(@current_user)
      render json: { errors: "You are not a member of this group" }, status: :unauthorized
    end
  end
  def check_owner_or_admin
    unless @topic.user_id == @current_user.id || @group.owner?(@current_user) || @group.admin?(@current_user)
      render json: { errors: "You are not the owner of this topic or owner/admin of the group" }, status: :unauthorized 
    end
  end

  def topic_params
  	params.require(:topic).permit(
      :anonymous,
      :body)
  end
end
