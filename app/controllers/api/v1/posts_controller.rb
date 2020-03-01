class Api::V1::PostsController < Api::V1::BaseController
  # Authorize the user before posting
  before_action :authorize, only: [:create, :destroy]

  # GET /posts
  def index
    # Is this a request with filters?
    if params[:filters]
      # Get the filtering parameters
      @tags = tag_filter_params[:tag_list]
      @match_all = tag_filter_params[:match_all]
      # Get the posts that match
      @posts = Post.tagged_with(@tags, match_all: @match_all)
    else
      # Get all posts
      @posts = Post.all
    end
    # Render the posts
    render json: @posts
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
    @post.image.attach(data: params[:image])
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
    # Check for authorization in the header
    def authorize
      # Get the authorization token from the header
      header = request.headers['Authorization']
      header = header.split(' ').last if header
      begin
        # Try and decode the token
        @decoded = JsonWebToken.decode(header)
        # Get the user by the user ID from the token
        @current_user = User.find_by_hashid(@decoded[:user_id])
        # Return an error if the user doesn't exist 
        # NOTE: This should not happen, the token is encoded and signed with the secret key
        # But just incase theres a server error or something
        render json: { errors: "User not found" }, status: :not_found if @current_user == nil
      rescue JWT::DecodeError => e
        # If theres an error decoding the token, respond with the error and a 401 status
        render json: { errors: e.message }, status: :unauthorized
      end 
    end
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