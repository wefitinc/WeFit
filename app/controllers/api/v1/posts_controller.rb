class Api::V1::PostsController < Api::V1::BaseController
  # Authorize the user before posting
  before_action :authorize, only: [:create, :destroy]

  # GET /posts
  def index
    # Render the posts
    render json: Post.all
  end

  # POST /posts/filter
  def filter
    if parameters[:filters]
      # Get the filtering parameters
      @tags = tag_filter_params[:tag_list]
      @match_all = tag_filter_params[:match_all]
      # Get the posts that match
      render json: Post.tagged_with(@tags, match_all: @match_all)
    end
    render json: Post.all
  end

  # GET /posts/:id
  def show
    # Get the post
    @post = Post.find(params[:id])
    # Render the post
    render json: @post
  end

  # DELETE /posts/:id
  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    if @post.destroyed?
      render json: { message: "Post destroyed" }
    else
      render json: { message: "Failed to destroy post" }, status: :internal_server_error
    end
    rescue ActiveRecord::RecordNotFound
      render json: { message: "Post not found or already destroyed" }, status: :not_found
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
    if @user == nil
      # Return a 404 if the user was not found
      render json: { errors: "User not found" }, status: :not_found 
    else
      # Render the user's posts
      render json: @user.posts
    end
  end

private
  def post_params
    params.require(:post).permit(
      :background,
      :text,
      :font,
      :font_size,
      :color,
      :position_x,
      :position_y,
      :rotation,
      :textview_width, :textview_height,
      :header_color,
      :latitude, :longitude)
  end
  def tag_list_param
    params.require(:post).permit(tag_list: [])
  end
  def tag_filter_params
    params.require(:filters).permit(
      :match_all, 
      tag_list: [])
  end
end