module Api::V1::BaseHelper
  # Render user data to JSON, stripping sensitive stuff
  def render_user(user)
    render json: user, except: [
      # Strip the user id, it's internal
      :id, 
      # Do NOT include the password digest or anything related to it!
      :password_digest, 
      # Strip the database timestamps
      # NOTE: No security reason, they're just not useful
      :created_at, :updated_at, 
      # Strip reset and activation data
      # NOTE: Not a huge security risk, but nothing would need it
      :activation_digest, :reset_digest, :reset_sent_at]
  end

  def render_post(post)
    render json: {
      color: post.color,
      background: post.background,
      text: post.text,
      font: post.font,
      position_x: post.position_x, 
      position_y: post.position_y, 
      rotation: post.rotation,
      latitude: post.latitude,
      longitude: post.longitude,
      image: post.get_image_url
    }
  end
end
