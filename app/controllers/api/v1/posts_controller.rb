class Api::V1::PostsController < Api::V1::BaseController
  before_action :authorize
  before_action :set_post, only:  [:show, :destroy, :likes, :comments, :views]
  before_action :check_owner, only: [:destroy]


  # GET: /api/v1/posts/category_top_posts
  # This will give initial posts from all categories along with the total count of unseen posts
  def category_top_posts
    # Post ids for posts which have been seen by the user
    @viewed_post_ids = get_seen_post_ids
    # This will give top N posts from each of the categories
    posts_results = get_top_posts_from_categories
    # This will give counter of unseen posts for the current user in each category
    counter_results = get_category_posts_counter
    # Get latest posts from users the current user is following
    following_posts = get_latest_following_posts 
    
    # Response variable
    @res = {}
    # Inserting Following Posts Information
    @res[FollowingCategoryName] = {
      counter: following_posts.total_entries, 
      posts: following_posts.map {|post| {media_url: post.media_url}}
    }
    # Initializing the response object with all categories info in case there are posts for a category
    initialize_response_obj
    # Creating the response object
    posts_results.each do |object|
      @res[object["tag_name"]][:counter] = counter_results[object["tag_name"]] if @res[object["tag_name"]][:counter] == 0
      @res[object["tag_name"]][:posts] << {media_url: object["media_url"]}
    end
  end

  # GET /api/v1/posts/category_posts
  # Params: {tag: <string>, page: <int>}
  # This will give paginated posts in the response for the category being passed in params. Posts since last 
  # PostsSinceLastXHours(constant) hours will be shown which have not been seen by the user ordered by post score.
  def category_posts
    # Get viewed posts' ids
    viewed_post_ids = get_seen_post_ids
    # Get posts based on tag: Following or Other
    if params[:tag] == FollowingCategoryName
      @posts = Post.includes(:user, post_tagged_users: :user).where(user_id: @current_user.following.pluck(:id)).where("posts.created_at > ?", 
        Time.zone.now - PostsSinceLastXHours.hours).where.not(id: viewed_post_ids).order(score: :desc, 
        created_at: :desc).page(@page_param)
    else
      @posts = Post.includes(:user, post_tagged_users: :user).tagged_with(params[:tag]).where("posts.created_at > ?", Time.zone.now - 
        CategoryPostsSinceLastXHours.hours).where.not(id: viewed_post_ids).order(score: :desc, 
        created_at: :desc).page(@page_param)
    end
    # Get post ids that the user has liked
    @liked_posts_ids = Like.where(owner_type: "Post", owner_id: @posts.map(&:id), 
      user_id: @current_user.id).pluck(:owner_id)

    render 'posts'
  end

  # POST: /api/v1/posts/rewatch
  # Params: {tag: <string>}
  # All the views for category tagged posts will be deleted
  def rewatch
    post_ids = Post.tagged_with(params[:tag]).where("posts.created_at > ?", Time.zone.now - 
      PostsSinceLastXHours.hours).pluck(:id)
    View.where(user_id: @current_user.id, post_id: post_ids).destroy_all
    render json: { message: "Success" }
  end

  # GET: /api/v1/posts/taggable_users
  # Initial list of users who are friends(def. in user model) of current user
  def taggable_users
    @users = @current_user.friends
    render json: @users
  end

  # POST: /api/v1/posts/search_taggable_user
  # Params: {name: <string>}
  # Search a user with first name or last name from amongst taggable users
  def search_taggable_user
    # TODO: make like to ilike. ilike is not supported in sql. change dev db to postgresql
    @users = User.where(id: Follow.where(follower_id: Follow.where(follower_id: @current_user.id).pluck(:user_id), 
      user_id: @current_user.id).pluck(:follower_id)).where("first_name like ? OR last_name like ?", 
      params[:name], params[:name]).page(@page_param)
    render json: @users
  end

  # GET: /api/v1/posts/categories
  # User can tag a post from amongst these categories only
  def categories
    @categories = Category.all
    render json: @categories
  end

  # POST /posts - Create a post
  def create
    # replace user hashid to id
    updated_post_params = process_tagged_user_attributes(post_params)
    # Create the new post
    @post = Post.new(updated_post_params)
    # Set the owner to the logged in user
    @post.user_id = @current_user.id
    # Attach the image if present
    @post.image.attach(data: params[:image]) if not params[:image].nil?
    # Update the score based on the followers
    update_score
    # Process tags and assign to this post
    process_tags
    # Save to DB
    if @post.save
      render json: @post
    else
      render json: { errors: @post.errors }, status: :unprocessable_entity
    end
  end

  # DELETE /posts/:id
  def destroy
    # only post's owner can remove the post
    @post.destroy
    render json: { message: "Post destroyed" }
  end

  # GET /posts
  # def index
  #   render json: Post.all
  # end

  # POST /posts/filter
  # def filter
  #   @posts = Post.all
  #   # Filter out posts that are 24 hours old
  #   # @posts = @posts.where(created_at: 24.hours.ago..Time.now)
    
  #   # Distance query
  #   @lat = tag_filter_params[:latitude]
  #   @lon = tag_filter_params[:longitude]
  #   @radius = tag_filter_params[:radius]
  #   # Filter posts where the distance is within the radius
  #   @posts = @posts.near([@lat, @lon], @radius) if @radius and @lat and @lon

  #   # Filter posts where the creator is followed by the current user
  #   @following_only = tag_filter_params[:following_only]
  #   @posts = @posts.where(user_id: @current_user.following) if @following_only 
    
  #   # Get the tag filtering parameters
  #   @tags = tag_filter_params[:tag_list]
  #   @match_all = tag_filter_params[:match_all]      
  #   # Fitler on tags
  #   @posts = @posts.tagged_with(@tags, match_all: @match_all) if @tags and not @tags.empty?
    
  #   # Render the posts
  #   render json: @posts
  # end

  # GET /posts/:id
  # def show
  #   # Render the post
  #   render json: @post
  # end

  # GET /user/:id/posts
  # def for_user
  #   # Get the user by the hashid
  #   @user = User.find_by_hashid(params[:id])
  #   # Render the user's posts
  #   render json: @user.posts
  # end

private

  def post_params
    params.require(:post).permit(
      :latitude, 
      :longitude,
      :media_url, 
      post_tagged_users_attributes: [:user_id])
  end

  def process_tagged_user_attributes(post_params)
    if post_params[:post_tagged_users_attributes].present?
      post_params[:post_tagged_users_attributes].each do |user_hash|
        id = User.find_by_hashid(user_hash["user_id"]).try(:id)
        user_hash["user_id"] = id if id.present?
      end
    end
    return post_params
  end

  def process_tags
    tag_list = params["post"]["tag_list"]
    @post.tag_list = tag_list.join(', ') if tag_list && tag_list.kind_of?(Array)
  end

  def update_score
    followers_count = @current_user.followers.count
    score = 0
    case followers_count
    when 0..99
      score = 5
    when 100..249
      score = 10
    when 250..499
      score = 20
    when 500..999
      score = 50
    when 1000..4999
      score = 100
    when 5000..9999
      score = 500
    else
      score = 500
    end
    @post.score = score
  end

  def set_post
    @post = Post.find(params[:id])
  end

  def get_sql_for_top_posts_in_categories
    sql = "SELECT * FROM 
      (
        SELECT row_number() OVER () AS id, c_posts.post_id, c_posts.created_at, c_posts.tag_name, c_posts.media_url, 
        rank() OVER (PARTITION BY c_posts.tag_name ORDER BY c_posts.score DESC, c_posts.created_at DESC) AS ranking 
        FROM (
          SELECT posts.id AS post_id, posts.media_url, posts.score, posts.created_at, tags.name as tag_name 
          FROM posts 
          INNER JOIN taggings ON taggings.taggable_id = posts.id AND taggings.taggable_type = 'Post' 
          AND taggings.context = 'tags' 
          INNER JOIN tags ON tags.id = taggings.tag_id 
          AND posts.id NOT IN (#{@viewed_post_ids.join(',')}) 
        ) AS c_posts
      ) AS t_posts where ranking <= #{CategoryTopPostsNumber};"
    return sql
  end

  def get_top_posts_from_categories
    sql = get_sql_for_top_posts_in_categories
    return ActiveRecord::Base.connection.execute(sql)
  end

  def get_category_posts_counter
    return ActsAsTaggableOn::Tagging.joins(:tag).where(taggable_type: "Post", context: 
      "tags").where.not(taggable_id: @viewed_post_ids).group("tags.name").count
  end

  def get_seen_post_ids
    ids = View.where(user_id: @current_user.id).pluck(:post_id) 
    ids = [0] unless ids.present?
    return ids
  end

  def get_latest_following_posts
    return Post.where(user_id: @current_user.following.pluck(:id)).where("created_at > ?", Time.zone.now - 
      PostsSinceLastXHours.hours).where.not(id: @viewed_post_ids).order(score: :desc, 
      created_at: :desc).page(FirstPage).per_page(CategoryTopPostsNumber)
  end

  def initialize_response_obj
    Category.all.each do |category|
      @res[category.name] = {counter: 0, posts: []}
    end
  end
  
  def check_owner
    unless @post.user_id == @current_user.id
      render json: { errors: "You are not the owner of this post" }, status: :unauthorized 
    end
  end

  # def tag_list_param
  #   params.require(:post).permit(tag_list: [])
  # end
  
  # def tag_filter_params
  #   params.require(:filters).permit(
  #     :following_only, 
  #     :latitude,:longitude,:radius,
  #     :match_all,
  #     tag_list: [])
  # end

end