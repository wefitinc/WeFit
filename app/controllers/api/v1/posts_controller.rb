class Api::V1::PostsController < Api::V1::BaseController
  before_action :set_post, only:  [:show, :destroy]
  # Authorize the user before posting
  before_action :authorize, only: [:filter, :create, :destroy]
  before_action :check_owner, only: [:destroy]

  # GET /posts
  def index
    render json: Post.all
  end

  # POST /posts/filter
  def filter
    # TODO: Should 'all' be the default? or should we make filters mandatory in this endpoint
    @posts = Post.all
    
    # Distance query
    @lat = tag_filter_params[:latitude]
    @lon = tag_filter_params[:longitude]
    @radius = tag_filter_params[:radius]
    # Filter posts where the distance is within the radius
    @posts = @posts.near([@lat, @lon], @radius) if @radius and @lat and @lon

    # Filter posts where the creator is followed by the current user
    @following_only = tag_filter_params[:following_only]
    @posts = @posts.where(user_id: @current_user.following) if @following_only 
    
    # Get the tag filtering parameters
    @tags = tag_filter_params[:tag_list]
    @match_all = tag_filter_params[:match_all]      
    # Fitler on tags
    @posts = @posts.tagged_with(@tags, match_all: @match_all) if @tags and not @tags.empty?
    
    # Render the posts
    render json: @posts
  end

  # GET /posts/:id
  def show
    # Render the post
    render json: @post
  end

  # DELETE /posts/:id
  def destroy
    @post.destroy
    render json: { message: "Post destroyed" }
  end

  # POST /posts
  def create
    # Create the new post
    @post = Post.new(post_params)
    # Set the owner to the logged in user
    @post.user_id = @current_user.id
    # Set the tag list to the proper tag format
    @tag_list = params["post"]["tag_list"]
    if @tag_list and @tag_list.kind_of?(Array)
      @post.tag_list = @tag_list.join(', ')
    end
    # Attach the image to the post
    @post.image.attach(data: params[:image]) if !params[:image].nil?
    # Save to DB
    if @post.save
      render json: @post
    else
      render json: { errors: @post.errors }, status: :unprocessable_entity
    end
  end

  # GET /user/:id/posts
  def for_user
    # Get the user by the hashid
    @user = User.find_by_hashid(params[:id])
    # Render the user's posts
    render json: @user.posts
  end

private
  def post_params
    params.require(:post).permit(
      :background,
      :header_color,
      :text,
      :font,
      :font_size,
      :color,
      :textview_rotation,
      :textview_position_x,
      :textview_position_y,
      :textview_width, 
      :textview_height,
      :image_rotation,
      :image_position_x,
      :image_position_y,
      :image_width, 
      :image_height,
      :latitude, :longitude)
  end
  def tag_list_param
    params.require(:post).permit(tag_list: [])
  end
  def tag_filter_params
    params.require(:filters).permit(
      :following_only, 
      :latitude,:longitude,:radius,
      :match_all,
      tag_list: [])
  end
  def set_post
    @post = Post.find(params[:id])
  rescue ActiveRecord::RecordNotFound
  end
  def check_owner
    unless @post.user_id == @current_user.id
      render json: { errors: "You are not the owner of this post" }, status: :unauthorized 
    end
  end
end