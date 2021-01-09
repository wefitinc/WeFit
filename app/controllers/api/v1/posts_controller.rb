class Api::V1::PostsController < Api::V1::BaseController
  before_action :set_post, only:  [:show, :destroy, :likes, :comments, :views]
  before_action :authorize, only: [:filter, :create, :destroy, :category_initial_posts]
  before_action :check_owner, only: [:destroy]


  # GET
  def category_initial_posts
    # This will give initial posts from all categories along with the total count of unseen posts
    # Categories are fixed.
    # Response: {categories: {following: {counter: 100, posts: []}, category_1: {counter: 100, posts: []}}}
    
    # TODO: break it down to smaller functions. Create a db View. Create scopes

    post_ids = View.where(user_id: @current_user.id).where("created_at > ?", 
      Time.zone.now - 24.hours).pluck(:post_id)

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
          where posts.created_at >= '#{(Time.zone.now - 24.hours).strftime("%Y-%m-%d %H:%M:%S")}' 
          AND posts.id NOT IN (#{post_ids.join(',')}) 
        ) 
        AS c_posts
      ) where ranking <= 10;"

    results = ActiveRecord::Base.connection.execute(sql)

    counter_results = ActsAsTaggableOn::Tagging.joins(:tag).where(taggable_type: "Post", context: 
      "tags").where.not(taggable_id: post_ids).where("taggings.created_at >= ?",
      Time.zone.now-24.hours).group("tags.name").count

    following_posts = Post.where(user_id: @current_user.following.pluck(:id)).where("created_at > ?", 
      Time.zone.now - 24.hours).where.not(id: post_ids).order(score: :desc, created_at: :desc).page(1).per_page(10)

    @res_hash = {}
    
    @res_hash["Following"] = {
      counter: following_posts.total_entries, 
      posts: following_posts.map {|post| {media_url: post.media_url}}
    }

    Category.all.each do |rec|
      @res_hash[rec.name] = {counter: 0, posts: []}
    end

    results.each do |hash|
      @res_hash[hash["tag_name"]][:counter] = counter_results[hash["tag_name"]] if @res_hash[hash["tag_name"]][:counter] == 0
      @res_hash[hash["tag_name"]][:posts] << {media_url: hash["media_url"]}
    end

    render json: @res_hash
  end

  # GET
  # Params: 
  def category_posts
    # This will give paginated posts in the response

    # Posts will be based on rank and then time. Rank will depend on likes, comments, views, and owner's followers
    # Only last 24 hours post.
    # Only the posts that the user has not viewed yet.

    # TODO: make it more readable. use scopes for filters. use constants. provide full reqd info in the response.
    seen_post_ids = View.where(user_id: @current_user.id).where("created_at > ?", 
      Time.zone.now - 24.hours).pluck(:post_id)

    if params[:tag] == "Following"
      @posts = Post.where(user_id: @current_user.following.pluck(:id)).where("created_at > ?", 
        Time.zone.now - 24.hours).where.not(id: seen_post_ids).order(score: :desc, created_at: :desc).page(@page_param)
    else
      @posts = Post.tagged_with(params[:tag]).where("created_at > ?", Time.zone.now - 
        24.hours).where.not(id: seen_post_ids).order(score: :desc, created_at: :desc).page(@page_param)
    end
    
    @liked_posts_ids = Like.where(owner_type: "Post", owner_id: @posts.map(&:id), 
      user_id: @current_user.id).pluck(:post_id)

    render 'posts'
    # Response: {posts: []}
  end

  # POST 
  def like
    # like post
    # update rank of post
  end

  # POST 
  def unlike
    # unlike a post. only like's owner can remove the like
    # update rank of post
  end

  # POST 
  def comment
    # comment on a post
    # update rank of post
  end

  # POST 
  def remove_comment
    # remove a comment. only comment's owner can remove the comment
    # update rank of post
  end

  # POST
  def view
    # params: {post_ids: []}
    # register a view for posts
  end

  # POST
  def rewatch
    # params: {category: c1}
    # Delete all the registered views for the current user for the given category
    post_ids = Post.tagged_with(params[:tag]).where("created_at > ?", Time.zone.now - 24.hours).pluck(:id)
    View.where(user_id: @current_user.id, post_id: post_ids).destroy_all
    render json: { message: "Success" }
  end

  # GET
  def likes
    # restricted to the owner of the post
    # get likes
    @likes = @post.likes.includes(:user)
  end

  # GET
  def comments
    # restricted to the owner of the post
    # get comments
    @comments = @post.comments.includes(:user)
  end

  # GET
  def views
    # restricted to the owner of the post
    # get views
    @views = @post.views.includes(:user)
  end

  # GET
  def to_be_tagged_users
    # the initial list of users who follow the current user and the current user follows back
    # It will return a paginated list of users
    @users = User.where(id: Follow.where(follower_id: Follow.where(follower_id: @current_user.id).pluck(:user_id), 
      user_id: @current_user.id).pluck(:follower_id)).page(@page_param)
  end

  # POST
  # Param: {name: <string>}
  def search_tagged_user
    # Search a user with first name or last name. Priority would be given to the user's followers
    # It will return a paginated list of users

    # TODO: make like to ilike. ilike is not supported in sql. change dev db to postgresql
    @users = User.where(id: Follow.where(follower_id: Follow.where(follower_id: @current_user.id).pluck(:user_id), 
      user_id: @current_user.id).pluck(:follower_id)).where("first_name like ? OR last_name like ?", params[:name], params[:name]).page(@page_param)
  end

  # GET
  def categories
    # This will get all categories(tags)
    # User can select only from these categories.
    @categories = Category.all.pluck(:id, :name)
  end

  # POST /posts - Create a post
  def create
    # Create the new post
    @post = Post.new(post_params)
    # Set the owner to the logged in user
    @post.user_id = @current_user.id
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

  ############# Extra APIs that will be implemented later ############
  
  # POST
  def send_as_message
    # Send post as message: available for all the viewers
  end

  # POST
  def report_post
    # report the post
  end

  # POST
  def follow_user
    # follow the owner of the post
  end

  # POST
  def block_user
    # block the owner of the post
  end

  ########### END ##############



























  # GET /posts
  # def index
  #   render json: Post.all
  # end

  

  # GET 
  # def category_info
  #   tag_counter_hash = ActsAsTaggableOn::Tagging.joins(:tag).where(taggable_type: "Post").where.not(taggable_id: 
  #     View.where(user_id: current_user.id).where(created_at: 
  #     24.hours.ago..Time.now).pluck(:post_id)).group("tags.name").count 

  #   following_posts_count = Post.where(id: UserPostFeed.where(user_id: @current_user.id).where.not(post_id: 
  #     View.where(user_id: @current_user.id).pluck(:post_id)).where(created_at: 
  #     24.hours.ago..Time.now).pluck(:post_id)).count

  #   tag_counter_hash[:following] = following_posts_count
  # end

  # def category_posts
  #   @posts = Post.tagged_with(params[:tag]).where(created_at: 24.hours.ago..Time.now).where.not(id: 
  #     View.where(user_id: @current_user.id).pluck(:post_id)).order(score: :desc).page(@page_param)

  #   render json: @posts
  # end

  # def following_posts
  #   @posts = Post.where(id: UserPostFeed.where(user_id: @current_user.id).where.not(post_id: 
  #     View.where(user_id: @current_user.id).pluck(:post_id)).where(created_at: 
  #     24.hours.ago..Time.now).pluck(:post_id))

  #   render json: @posts
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

  # def check_owner
  #   unless @post.user_id == @current_user.id
  #     render json: { errors: "You are not the owner of this post" }, status: :unauthorized 
  #   end
  # end

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