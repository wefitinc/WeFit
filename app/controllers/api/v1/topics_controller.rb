class Api::V1::TopicsController < Api::V1::BaseController
  before_action :authorize
  before_action :set_group, only: [ :index, :create ]
  before_action :set_topic, only: [ :show ]
  before_action :check_member, only: [ :create ]
  before_action :check_owner, only: [ :destroy ]

  # GET /topics
  def index
    # Posts should by default display by most recent at the top, and the filter option 
    # should be to display list by most recent or most popular (likes + comments).
  	render json: @group.topics, current_user: @current_user
  end

  # GET /topics/:id
  def show
  	render json: @topic, current_user: @current_user
  end

  # POST /topics
  def create
    # Users can attach a picture from their camera or photo gallery, and toggle on anonymous mode 
    # which conceals the users identity from being seen by anyone in the group
    
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
  	@topic = Topic.find(params[:topic_id])
  end

  def check_member
    unless @group.member?(@current_user)
      render json: { errors: "You are not a member of this group" }, status: :unauthorized
    end
  end
  def check_owner
    unless @topic.user_id == @current_user.id
      render json: { errors: "You are not the owner of this topic" }, status: :unauthorized 
    end
  end

  def topic_params
  	params.require(:topic).permit(
      :anonymous,
      :body)
  end
end
