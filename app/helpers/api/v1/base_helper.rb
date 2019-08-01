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
      # Strip reset data
      # NOTE: Not a huge security risk, but nothing would need it
      :reset_digest, :reset_sent_at]
  end
end
